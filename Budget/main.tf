provider "aws" {
  region = "us-east-1" # Budgets are only supported in us-east-1
}

resource "aws_sns_topic" "budget_notifications" {
  name = "budget-notification-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.budget_notifications.arn
  protocol  = "email"
  endpoint  = "himanshusingh28094@gmail.com" # Replace with your real email
}

resource "aws_budgets_budget" "monthly_budget" {
  name         = "MonthlyBudget-v2"
  budget_type  = "COST"
  limit_amount = "2"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    notification_type   = "ACTUAL"
    comparison_operator = "GREATER_THAN"
    threshold_type      = "PERCENTAGE"
    threshold           = 100
    subscriber_email_addresses = [
      "your-email@example.com"  # Replace with your email
    ]
    subscriber_sns_topic_arns = [
      aws_sns_topic.budget_notifications.arn
    ]
  }
}
