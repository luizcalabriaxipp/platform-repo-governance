repo-governance/
│
├── README.md
├── .env.example
├── .gitignore
│
├── config/
│   ├── orgs.yaml
│   ├── branch-policy.yaml
│   ├── environments.yaml
│
├── scripts/
│   ├── audit/
│   │   ├── audit_repos.sh
│   │   ├── audit_branches.sh
│   │   ├── audit_environments.sh
│   │   └── export_to_csv.sh
│   │
│   ├── migrate/
│   │   ├── migrate_master_to_main.sh
│   │   └── update_default_branch.sh
│   │
│   ├── enforce/
│   │   ├── protect_main.sh
│   │   ├── create_branches.sh
│   │   └── create_environments.sh
│   │
│   └── validate/
│       ├── validate_protection.sh
│       ├── validate_envs.sh
│       └── validate_branches.sh
│
├── workflows/
│   └── governance.yml
│
└── docs/
    ├── governance-model.md
    ├── branch-strategy.md
    ├── rollout-plan.md
    └── troubleshooting.md