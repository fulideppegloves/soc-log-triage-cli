# SOC L1 Automated Log & PCAP Triage CLI (`soc_triage.sh`)

A lightweight Bash & `tshark` triage utility built for SOC L1 analysts to rapidly detect web reconnaissance, brute-force probes, and SQL injection patterns from raw access logs or packet captures.

## Key Features
- **Auto File-Type Routing:** Automatically switches between web log parsing (`grep`/`awk`) and packet payload extraction (`tshark`) based on `.log` vs. `.pcap` input.
- **Automated Threat Detection:** Flags non-browser User-Agents (`sqlmap`, `Nikto`, `python-requests`, `curl`), isolates successful `HTTP 200` exposures (`/.env`, `UNION SELECT`), and ranks top attacking source IPs.
- **Instant Incident Reporting:** Exports timestamped Markdown triage reports (`triage_report_YYYYMMDD_HHMM.md`) via `tee`.

## Usage
```bash
chmod +x soc_triage.sh
./soc_triage.sh prod_access.log
./soc_triage.sh capture.pcap
