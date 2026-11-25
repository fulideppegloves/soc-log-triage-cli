#!/bin/bash
TARGET_FILE="$1"

if [ -z "$TARGET_FILE" ] || [ ! -f "$TARGET_FILE" ]; then
  echo "Usage: ./soc_triage.sh <path_to_log_or_pcap>"
  exit 1
fi
DATE_TAG=$(date +%Y%m%d_%H%M)
REPORT_FILE="triage_report_${DATE_TAG}.md"

{
echo "# SOC L1 Automated Triage Report"
echo "- **Target File:** \`$TARGET_FILE\`"
echo "- **Generated At:** $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""

  if [[ "$TARGET_FILE" == *.pcap ]]; then
    echo "## [PCAP Mode] Extracted HTTP Requests"
    cat "$TARGET_FILE" | tshark -r - -Y "http.request" -T fields -e ip.src -e http.host -e http.request.method -e http.request.uri -e http.user_agent 2>/dev/null
  else
    echo "## [1] Top Suspicious User-Agents (Non-Browser)"
    grep -v "Mozilla/5.0 (" "$TARGET_FILE" | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr

    echo ""
    echo "## [2] Critical: Successful Sensitive File / SQLi Hits (HTTP 200)"
    grep -E "UNION|SELECT|%27|/\.env" "$TARGET_FILE" | grep " 200 " | awk '{print $1, $7, $9}' | sort | uniq -c | sort -nr

    echo ""
    echo "## [3] Top Attacking Source IPs"
    grep -v "Mozilla/5.0 (" "$TARGET_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr
  fi
} | tee "$REPORT_FILE"

echo ""
echo "[+] Report saved to: $REPORT_FILE"
