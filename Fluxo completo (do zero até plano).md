Fluxo completo (do zero até plano)

1️⃣ Auditoria da org
./scripts/audit/audit_org_to_csv.sh


2️⃣ Calcular risco
Shell ./scripts/audit/calculate_risk_score.sh audit_org_YYYYMMDD.audit_org_to_csv

3️⃣ Gerar plano de ação automático
./scripts/audit/generate_action_plan.sh audit_org_with_risk_YYYYMMDD.csv




Repo Governance Automation
Este repositório centraliza toda a automação de governança de repositórios, incluindo auditoria, migração de branches, proteção da branch main, criação de branches padrão, criação de environments e validações contínuas.
Ele foi projetado para ser:

✅ Executado localmente via VS Code
✅ Versionado (GitOps)
✅ Auditável (com evidências)
✅ Escalável para dezenas ou centenas de repositórios


📁 Estrutura do Repositório

repo-governance/
│
├── README.md
├── .env.example
├── .gitignore
│
├── config/
│   ├── org.yaml
│   ├── branch-policy.yaml
│   └── environments.yaml
│
├── scripts/
│   ├── audit/
│   │   ├── audit_repos.sh
│   │   └── audit_branches.sh
│   │
│   ├── migrate/
│   │   └── migrate_master_to_main.sh
│   │
│   ├── enforce/
│   │   ├── protect_main.sh
│   │   ├── create_branches.sh
│   │   └── create_environments.sh
│   │
│   └── validate/
│       ├── validate_protection.sh
│       └── validate_envs.sh
│
├── workflows/
│   └── governance-audit.yml
│
└── docs/
    ├── branch-strategy.md
    ├── rollout-plan.md
    └── troubleshooting.md




🔧 Pré-requisitos

GitHub CLI (gh)
jq
yq
Bash (Linux / macOS / WSL)
VS Code (recomendado)

brew install gh jq yq



gh auth login




📄 Configurações
config/org.yaml

github:
  org: sua-organizacao


config/branch-policy.yaml

default_branch: main

required_branches:
  - develop
  - stage
  - preprod
  - UAT

protection:
  required_approvals: 1
  enforce_admins: true
  block_self_approval: true


config/environments.yaml

environments:
  - DEV
  - STG
  - PREPROD
  - UAT
  - PRODUÇÃO




🧪 AUDIT SCRIPTS
scripts/audit/audit_repos.sh

#!/bin/bash
ORG=$(yq '.github.org' config/org.yaml)

echo "repo,default_branch,has_main,has_master"

gh repo list $ORG --limit 1000 --json name,defaultBranchRef | jq -r '.[] | .name' | while read repo; do
  default=$(gh api repos/$ORG/$repo | jq -r .default_branch)
  has_main=$(gh api repos/$ORG/$repo/branches/main --silent && echo yes || echo no)
  has_master=$(gh api repos/$ORG/$repo/branches/master --silent && echo yes || echo no)
  echo "$repo,$default,$has_main,$has_master"
done




🔄 MIGRATION
scripts/migrate/migrate_master_to_main.sh

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




🔐 PROTEÇÃO DA MAIN
scripts/enforce/protect_main.sh

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




🌱 BRANCHES PADRÃO
scripts/enforce/create_branches.sh

#!/bin/bash
ORG=$(yq '.github.org' config/org.yaml)
REPO=$1
BASE_SHA=$(gh api repos/$ORG/$REPO/git/ref/heads/main | jq -r .object.sha)

for BRANCH in develop stage preprod UAT; do
  gh api repos/$ORG/$REPO/branches/$BRANCH --silent && continue
  gh api -X POST repos/$ORG/$REPO/git/refs -f ref=refs/heads/$BRANCH -f sha=$BASE_SHA
  echo "✅ Branch $BRANCH criada"
done




🌎 ENVIRONMENTS
scripts/enforce/create_environments.sh

#!/bin/bash
ORG=$(yq '.github.org' config/org.yaml)
REPO=$1

for ENV in $(yq '.environments[]' config/environments.yaml); do
  gh api -X PUT repos/$ORG/$REPO/environments/$ENV
  echo "✅ Environment $ENV criado"
done




✅ VALIDAÇÕES
scripts/validate/validate_envs.sh

#!/bin/bash
ORG=$(yq '.github.org' config/org.yaml)
REPO=$1

gh api repos/$ORG/$REPO/environments




🤖 GOVERNANÇA CONTÍNUA
workflows/governance-audit.yml

name: Repo Governance Audit

on:
  schedule:
    - cron: "0 6 * * 1"

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/audit/audit_repos.sh




📘 Documentação

docs/branch-strategy.md — Estratégia de branches
docs/rollout-plan.md — Plano de rollout por squad
docs/troubleshooting.md — Problemas conhecidos


✅ Próximos Passos

Clonar esse repositório
Configurar config/org.yaml
Rodar audit
Executar piloto
Expandir para todos os repositórios
Se desejar, este repositório pode ser facilmente adaptado para GitLab ou Azure DevOps.
