#!/usr/bin/env bash
set -Eeuo pipefail

section() { printf '\n==== %s ====\n' "$1"; }

section "Host"
hostnamectl 2>/dev/null || hostname
printf 'Uptime: '
uptime -p 2>/dev/null || uptime

section "CPU"
if command -v nproc >/dev/null 2>&1; then
  printf 'Logical CPUs: %s\n' "$(nproc)"
fi
if command -v uptime >/dev/null 2>&1; then
  uptime
fi

section "Memory"
if command -v free >/dev/null 2>&1; then
  free -h
else
  echo "free command not found"
fi

section "Filesystem usage"
df -hT -x tmpfs -x devtmpfs 2>/dev/null || df -h

section "Top processes by memory"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 11

section "Failed systemd units"
if command -v systemctl >/dev/null 2>&1; then
  systemctl --failed --no-pager || true
else
  echo "systemctl not available"
fi

section "Recent critical kernel messages (permission may be required)"
if command -v journalctl >/dev/null 2>&1; then
  journalctl -k -p err -n 20 --no-pager 2>/dev/null || echo "Unable to read kernel journal"
else
  echo "journalctl not available"
fi

echo
echo "Health report complete. No system settings were changed."
