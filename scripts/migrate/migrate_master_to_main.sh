#!/bin/bash
set -e
ORG=$(yq '.github.org' config/org.yaml)
REPO=$1

if gh api repos/$ORG/$REPO/branches/main --silent; then
  echo "Repo já possui branch main"
  exit 0
fi

gh api -X POST repos/$ORG/$REPO/branches/master/rename -f new_name=main
gh api -X PATCH repos/$ORG/$REPO -f default_branch=main

echo "✅ $REPO migrado para main"
