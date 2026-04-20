#!/bin/bash
set -e
ORG=$(yq '.github.org' config/org.yaml)
REPO=$1
APPROVALS=$(yq '.protection.required_approvals' config/branch-policy.yaml)

gh api -X PUT repos/$ORG/$REPO/branches/main/protection \
  -f enforce_admins=true \
  -f required_pull_request_reviews.required_approving_review_count=$APPROVALS \
  -f required_pull_request_reviews.require_last_push_approval=true \
  -f restrictions=null
