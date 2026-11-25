#!/bin/bash
LOG_FILE="$1"

if [ -z "$LOG_FILE" ]; then
  echo "Usage: ./soc_triage.sh <path_to_access_log>"
  exit 1
fi

echo "=========================================="
echo "   SOC L1 AUTOMATED TRIAGE REPORT"
echo "   Target File: $LOG_FILE"
echo "=========================================="

echo -e "\n[1] TOP SUSPICIOUS USER-AGENTS (Non-Browser):"
grep -v "Mozilla/5.0 (" "$LOG_FILE" | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr

echo -e "\n[2] CRITICAL: SUCCESSFUL SENSITIVE FILE / SQLi HITS (HTTP 200):"
grep -E "UNION|SELECT|%27|/\.env" "$LOG_FILE" | grep " 200 " | awk '{print $1, $7, $9}' | sort | uniq -c | sort -nr

echo -e "\n[3] TOP ATTACKING SOURCE IPs:"
grep -v "Mozilla/5.0 (" "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr
