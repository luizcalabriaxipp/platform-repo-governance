#!/bin/bash

ORG=$(yq '.github.org' config/org.yaml)
REPO=$1

default_branch=$(gh api repos/$ORG/$REPO --jq '.default_branch')

has_master=$(gh api repos/$ORG/$REPO/branches/master --silent && echo yes || echo no)
has_main=$(gh api repos/$ORG/$REPO/branches/main --silent && echo yes || echo no)

has_protection=$(gh api repos/$ORG/$REPO/branches/main/protection --silent && echo yes || echo no)

envs=$(gh api repos/$ORG/$REPO/environments --silent \
  && gh api repos/$ORG/$REPO/environments --jq '.environments[].name' | tr '\n' ';' \
  || echo none)

echo "repo,default_branch,has_main,has_master,main_protected,environments"
echo "$REPO,$default_branch,$has_main,$has_master,$has_protection,\"$envs\""
``