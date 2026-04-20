# Estratégia Corporativa de Branches

## Objetivo
Definir uma estratégia padronizada de branches para todos os repositórios da organização, garantindo previsibilidade, governança, rastreabilidade e redução de riscos no ciclo de desenvolvimento e entrega de software.

Essa estratégia é obrigatória para todos os projetos versionados sob a organização e deve ser seguida independentemente da stack tecnológica.

---

## Branches Oficiais

| Branch    | Finalidade |
|----------|-----------|
| main     | Versão principal estável do sistema (produção) |
| develop  | Consolidação do desenvolvimento contínuo |
| stage    | Validação em ambiente de STG |
| preprod  | Preparação para produção |
| UAT      | Homologação com usuários / negócio |

---

## Regras Gerais

- Nenhuma alteração pode ser feita diretamente na `main`
- Toda mudança deve ocorrer via **Pull Request**
- A branch `main` deve estar protegida em todos os repositórios
- Pull Requests para `main` exigem:
  - Pelo menos **1 aprovação**
  - Aprovação por alguém diferente do autor
- Commits diretos na `main` são **proibidos**

---

## Fluxo de Promoção de Código

```text
feature/* → develop → stage → preprod → UAT → main