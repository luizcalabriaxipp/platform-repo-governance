#!/bin/bash
ORG=$(yq '.github.org' config/org.yaml)
REPO=$1

gh api repos/$ORG/$REPO/environments
