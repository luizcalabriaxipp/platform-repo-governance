# Troubleshooting — Governança de Repositórios

## Problemas Conhecidos e Soluções

---

### ❌ Pipeline falhando após migração de `master` para `main`

**Causa**
- Pipeline referenciando explicitamente `master`

**Solução**
- Atualizar definição do pipeline:
```yaml
on:
  push:
    branches:
      - main
``