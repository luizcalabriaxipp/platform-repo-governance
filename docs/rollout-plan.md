# Plano de Rollout da Governança de Repositórios

## Objetivo
Garantir a adoção segura e controlada da padronização de branches, proteção de repositórios e environments, minimizando impactos nos times e nos pipelines existentes.

---

## Estratégia de Implementação

### Fase 1 — Auditoria
- Inventariar todos os repositórios
- Identificar:
  - Uso de `master`
  - Branch default
  - Falta de proteção
  - Ausência de environments
- Registrar evidências em CSV

---

### Fase 2 — Piloto
- Selecionar 3 a 5 repositórios representativos
- Aplicar:
  - Migração `master → main`
  - Proteção da `main`
  - Criação de branches padrão
  - Criação de environments
- Validar pipelines e deploys

---

### Fase 3 — Comunicação
- Comunicar times sobre:
  - Nova estratégia de branches
  - Impactos esperados
  - Boas práticas
- Disponibilizar documentação oficial

---

### Fase 4 — Expansão
- Aplicar automação por lote (batch)
- Priorizar repositórios críticos
- Monitorar incidentes

---

### Fase 5 — Governança Contínua
- Auditoria periódica via pipeline
- Detecção de desvios de padrão
- Correções controladas

---

## Critérios de Sucesso

- 100% dos repositórios usam `main`
- 0 repositórios com commit direto na main
- Environments configurados em todos os projetos
- Deploys rastreáveis no Jira