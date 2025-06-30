provider "aws" {
  region = "us-east-1" # Budget service is only supported in us-east-1
}

# SNS topic for budget alerts
resource "aws_sns_topic" "budget_notifications" {
  name = "budget-notification-topic"
}

# Subscribe your email to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.budget_notifications.arn
  protocol  = "email"
  endpoint  = "himanshusingh28094@gmail.com"  # ✅ Use a valid email address
}

# AWS Budget configuration
resource "aws_budgets_budget" "monthly_budget" {
  name         = "MonthlyBudget"
  budget_type  = "COST"
  limit_amount = "2"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    threshold           = 100
    threshold_type      = "PERCENTAGE"

    subscriber {
      subscription_type = "SNS"
      address           = aws_sns_topic.budget_notifications.arn
    }
  }
}

