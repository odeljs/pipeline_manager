# Central organization link to securely clone private application repos
resource "aws_codestarconnections_connection" "github" {
  name          = "github-org-connection"
  provider_type = "GitHub"
}


###################OIDC#######################
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
}

resource "aws_iam_role" "github_actions_oidc" {
  name = "github-actions-module-ci-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:odeljs/*"
        },
        "StringEquals": {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name = "github-actions-ssm-eventbridge-policy"
  role = aws_iam_role.github_actions_oidc.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:PutParameter", "ssm:GetParameter"]
        Resource = "arn:aws:ssm:*:*:parameter/terraform/modules/*"
      },
      {
        Effect   = "Allow"
        Action   = ["events:PutEvents"]
        Resource = aws_cloudwatch_event_bus.tf_modules.arn
      }
    ]
  })
}

###################################################################