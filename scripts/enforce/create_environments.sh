#!/bin/bash
ORG=$(yq '.github.org' config/org.yaml)
REPO=$1

for ENV in $(yq '.environments[]' config/environments.yaml); do
  gh api -X PUT repos/$ORG/$REPO/environments/$ENV
  echo "✅ Environment $ENV criado"
done
