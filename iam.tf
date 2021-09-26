data "aws_iam_policy_document" "assume-role" {
  statement {
    sid     = "CloudWatchLogsAgentTrustPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "application-iam-role" {
  name               = "${local.application}-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_instance_profile" "arachnys-take-home-test-instance-profile" {
  name = "${local.application}-instance-profile"
  role = aws_iam_role.application-iam-role.name
}

data "aws_iam_policy_document" "cw-logs" {
  statement {
    sid       = "CloudWatchLogsAgentLogsActions"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
    ]
  }
}

data "aws_iam_policy_document" "cw-metrics" {
  statement {
      sid    = "CWLMetricsActions"
      effect = "Allow"
      resources = ["*"]

      actions = [
        "cloudwatch:PutMetricData",
        "ec2:DescribeTags",
      ]
    }
}

resource "aws_iam_policy" "cw-logs-policy" {
  name   = "${local.application}-cw-logs-policy"
  policy = data.aws_iam_policy_document.cw-logs.json
}



resource "aws_iam_policy" "cw-metrics-policy" {
  name   = "${local.application}-cw-metrics-policy"
  policy = data.aws_iam_policy_document.cw-metrics.json
}

resource "aws_iam_role_policy_attachment" "cw-logs-policy-attachment" {
  role       = aws_iam_role.application-iam-role.name
  policy_arn = aws_iam_policy.cw-logs-policy.arn
}

resource "aws_iam_role_policy_attachment" "cw-metrics-policy-attachment" {
  role       = aws_iam_role.application-iam-role.name
  policy_arn = aws_iam_policy.cw-metrics-policy.arn
}

#SSM policy
data "aws_iam_policy" "aws_ssm_core_access" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core_policy_attach" {
  role       = aws_iam_role.application-iam-role.name
  policy_arn = data.aws_iam_policy.aws_ssm_core_access.arn
}

