# First, let's set up data sources we'll need
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# CloudWatch Log Group for EKS cluster logs
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.app_name}-${var.environment}/cluster"
  retention_in_days = 30

  tags = {
    Name        = "${var.app_name}-${var.environment}-eks-logs"
    Environment = var.environment
  }
}

# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/applications/${var.app_name}-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "${var.app_name}-${var.environment}-app-logs"
    Environment = var.environment
  }
}

# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.app_name}-${var.environment}-alerts"
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.alerts.arn
      }
    ]
  })
}

# CloudWatch Dashboard for application metrics
# modules/monitoring/main.tf

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.app_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EKS", "cluster_failed_node_count", "ClusterName", tostring(var.eks_cluster_name)],
            [".", "cluster_node_count", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "EKS Node Count"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", tostring(coalesce(var.alb_name, ""))]
          ]
          period = 300
          stat   = "Sum"
          region = data.aws_region.current.name
          title  = "Request Count"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.app_name}-${var.environment}-profile"]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "Database CPU"
        }
      }
    ]
  })
}


# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "${var.app_name}-${var.environment}-database-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period             = "300"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "Database CPU utilization is high"
  alarm_actions      = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = "${var.app_name}-${var.environment}-profile"
  }
}

resource "aws_cloudwatch_metric_alarm" "node_cpu" {
  alarm_name          = "${var.app_name}-${var.environment}-node-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period             = "300"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "EKS node CPU utilization is high"
  alarm_actions      = [aws_sns_topic.alerts.arn]

  dimensions = {
    ClusterName = var.eks_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "api_errors" {
  alarm_name          = "${var.app_name}-${var.environment}-api-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period             = "300"
  statistic          = "Sum"
  threshold          = "10"
  alarm_description  = "High number of 5XX errors detected"
  alarm_actions      = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = var.alb_name
  }
}

# Create IAM role for CloudWatch agent
resource "aws_iam_role" "cloudwatch_agent" {
  name = "${var.app_name}-${var.environment}-cloudwatch-agent"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach CloudWatch agent policy
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.cloudwatch_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}