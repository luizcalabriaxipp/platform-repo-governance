#!/bin/bash
set -euo pipefail

ORG=$(yq '.github.org' config/org.yaml)
REPO=$1
APPROVALS=$(yq '.protection.required_approvals' config/branch-policy.yaml)

# JSON de proteção (tipos corretos)
cat > /tmp/branch_protection.json <<EOF
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": ${APPROVALS},
    "require_last_push_approval": true
  },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true
}
EOF

gh api \
  -X PUT "repos/${ORG}/${REPO}/branches/main/protection" \
  --input /tmp/branch_protection.json