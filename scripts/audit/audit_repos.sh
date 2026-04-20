#!/bin/bash
ORG=$(yq '.github.org' config/org.yaml)

echo "repo,default_branch,has_main,has_master"

gh repo list $ORG --limit 1000 --json name,defaultBranchRef | jq -r '.[] | .name' | while read repo; do
  default=$(gh api repos/$ORG/$repo | jq -r .default_branch)
  has_main=$(gh api repos/$ORG/$repo/branches/main --silent && echo yes || echo no)
  has_master=$(gh api repos/$ORG/$repo/branches/master --silent && echo yes || echo no)
  echo "$repo,$default,$has_main,$has_master"
done
