terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Budgets are only supported in us-east-1
}

resource "aws_sns_topic" "budget_notifications" {
  name = "budget-notification-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.budget_notifications.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"  # 🔁 Replace with your actual email
}

resource "aws_budgets_budget" "monthly_budget" {
  name              = "MonthlyBudget"
  budget_type       = "COST"
  limit_amount      = "2"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon Elastic Compute Cloud - Compute"] # Optional: limit to specific services
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    notification_type         = "ACTUAL"
    threshold                 = 100  # in percentage of the budget (100% of $2)
    threshold_type            = "PERCENTAGE"

    subscriber {
      address          = aws_sns_topic.budget_notifications.arn
      subscription_type = "SNS"
    }
  }
}
