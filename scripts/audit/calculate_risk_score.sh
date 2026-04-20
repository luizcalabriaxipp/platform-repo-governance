#!/bin/bash
set -e

INPUT=$1
OUTPUT="audit_org_with_risk_$(date +%Y%m%d_%H%M).csv"

if [[ ! -f "$INPUT" ]]; then
  echo "❌ Arquivo não encontrado: $INPUT"
  exit 1
fi

echo "repo,default_branch,has_main,has_master,main_protected,branches,environments,compliance,risk_score,risk_level,risk_reasons" > "$OUTPUT"

tail -n +2 "$INPUT" | while IFS=',' read -r repo default_branch has_main has_master main_protected branches environments compliance; do

  score=0
  reasons=""

  if [[ "$default_branch" != "main" ]]; then
    score=$((score + 30))
    reasons+="default_branch_nao_main;"
  fi

  if [[ "$has_master" == "yes" ]]; then
    score=$((score + 20))
    reasons+="branch_master_existe;"
  fi

  if [[ "$main_protected" != "yes" ]]; then
    score=$((score + 40))
    reasons+="main_sem_protecao;"
  fi

  if [[ "$environments" == "none" || -z "$environments" ]]; then
    score=$((score + 10))
    reasons+="sem_environments;"
  fi

  if [[ "$compliance" == "PARCIAL" ]]; then
    score=$((score + 10))
    reasons+="compliance_parcial;"
  fi

  if [[ "$compliance" == "NAO_CONFORME" ]]; then
    score=$((score + 30))
    reasons+="nao_conforme;"
  fi

  if [[ $score -le 20 ]]; then
    level="LOW"
  elif [[ $score -le 40 ]]; then
    level="MEDIUM"
  elif [[ $score -le 70 ]]; then
    level="HIGH"
  else
    level="CRITICAL"
  fi

  echo "$repo,$default_branch,$has_main,$has_master,$main_protected,$branches,$environments,$compliance,$score,$level,\"$reasons\"" >> "$OUTPUT"

done

echo "✅ Risk score gerado:"
echo "📄 $OUTPUT"
