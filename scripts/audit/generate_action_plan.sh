#!/bin/bash
set -e

INPUT=$1
OUTPUT="audit_org_action_plan_$(date +%Y%m%d_%H%M).csv"

if [[ ! -f "$INPUT" ]]; then
  echo "❌ Arquivo não encontrado: $INPUT"
  exit 1
fi

echo "repo,risk_level,risk_score,priority,actions,recommended_execution" > "$OUTPUT"

tail -n +2 "$INPUT" | while IFS=',' read -r \
  repo default_branch has_main has_master main_protected branches environments compliance risk_score risk_level risk_reasons; do

  actions=""

  if [[ "$default_branch" != "main" ]]; then
    actions+="Migrar master->main | "
  fi

  if [[ "$has_master" == "yes" ]]; then
    actions+="Remover branch master | "
  fi

  if [[ "$main_protected" != "yes" ]]; then
    actions+="Aplicar proteção na main | "
  fi

  if [[ "$environments" == "none" || -z "$environments" ]]; then
    actions+="Criar environments | "
  fi

  if [[ "$compliance" != "OK" ]]; then
    actions+="Ajustar pipelines e padrões | "
  fi

  actions=$(echo "$actions" | sed 's/ | $//')

  case "$risk_level" in
    CRITICAL)
      priority="P1"
      execution="AUTOMACAO_IMEDIATA"
      ;;
    HIGH)
      priority="P2"
      execution="AUTOMACAO_COM_VALIDACAO"
      ;;
    MEDIUM)
      priority="P3"
      execution="PLANEJADO"
      ;;
    *)
      priority="P4"
      execution="MONITORAR"
      ;;
  esac

  echo "$repo,$risk_level,$risk_score,$priority,\"$actions\",$execution" >> "$OUTPUT"

done

echo "✅ Plano de ação gerado:"
echo "📄 $OUTPUT"
``