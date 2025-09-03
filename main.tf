data "aws_iam_policy_document" "perpetua_gcp_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["accounts.google.com"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "accounts.google.com:sub"
      values   = ["${var.gcp_unique_id}"]
    }
  }
}

data "aws_iam_policy_document" "perpetua_gcp_access" {
  statement {
    sid    = "AllowS3Access"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "perpetua_gcp_role" {
  name               = "PerpetuaGCPRole"
  assume_role_policy = data.aws_iam_policy_document.perpetua_gcp_assume_role.json

  inline_policy {
    name   = "InlinePerpetuaGCP"
    policy = data.aws_iam_policy_document.perpetua_gcp_access.json
  }

}