provider "aws" {
  region = "us-east-1" # Budgets are only supported in this region
}

resource "aws_sns_topic" "budget_notifications" {
  name = "budget-notification-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.budget_notifications.arn
  protocol  = "email"
  endpoint  = "himanshusingh28094.com"  # 🔁 Replace with your actual email
}

resource "aws_budgets_budget" "monthly_budget" {
  name         = "MonthlyBudget"
  budget_type  = "COST"
  limit_amount = "2"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notifications_with_subscribers {
    notification {
      notification_type   = "ACTUAL"
      comparison_operator = "GREATER_THAN"
      threshold_type      = "PERCENTAGE"
      threshold           = 100
    }

    subscriber {
      subscription_type = "SNS"
      address           = aws_sns_topic.budget_notifications.arn
    }
  }
}
