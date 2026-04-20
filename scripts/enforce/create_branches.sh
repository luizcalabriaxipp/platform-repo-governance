#!/bin/bash
ORG=$(yq '.github.org' config/org.yaml)
REPO=$1
BASE_SHA=$(gh api repos/$ORG/$REPO/git/ref/heads/main | jq -r .object.sha)

for BRANCH in develop stage preprod UAT; do
  gh api repos/$ORG/$REPO/branches/$BRANCH --silent && continue
  gh api -X POST repos/$ORG/$REPO/git/refs -f ref=refs/heads/$BRANCH -f sha=$BASE_SHA
  echo "✅ Branch $BRANCH criada"
done
