
#!/bin/bash

LOG="/var/log/server-monitor.log"
THRESHOLD=80
SSH_THRESHOLD=5

# Create log file if it does not exist
touch "$LOG"

# 1. CPU load percentage (approximation)
CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
CORES=$(nproc)

CPU_PERCENT=$(awk -v load="$CPU_LOAD" -v cores="$CORES" \
    'BEGIN {printf "%.0f", (load/cores)*100}')

# 2. Memory usage percentage
MEM=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')

# 3. Root disk usage percentage
DISK=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

# Write current monitoring results
echo "$(date) CPU=${CPU_PERCENT}% MEM=${MEM}% DISK=${DISK}%" >> "$LOG"

# 4. CPU threshold alert
if [ "$CPU_PERCENT" -ge "$THRESHOLD" ]; then
    echo "$(date) ALERT: CPU threshold exceeded (${CPU_PERCENT}%)" >> "$LOG"
fi

# 5. Memory threshold alert
if [ "$MEM" -ge "$THRESHOLD" ]; then
    echo "$(date) ALERT: Memory threshold exceeded (${MEM}%)" >> "$LOG"
fi

# 6. Disk threshold alert
if [ "$DISK" -ge "$THRESHOLD" ]; then
    echo "$(date) ALERT: Disk threshold exceeded (${DISK}%)" >> "$LOG"
fi

# 7. Service availability
for SERVICE in ssh nginx mysql postfix; do
    if systemctl is-active --quiet "$SERVICE"; then
        echo "$(date) OK: $SERVICE is running" >> "$LOG"
    else
        echo "$(date) ALERT: $SERVICE is not running" >> "$LOG"
    fi
done

# 8. Failed SSH attempts
if [ -r /var/log/auth.log ]; then
    FAILED=$(grep -c "Failed password" /var/log/auth.log)
else
    FAILED=0
fi

echo "$(date) Failed SSH attempts recorded: $FAILED" >> "$LOG"

if [ "$FAILED" -ge "$SSH_THRESHOLD" ]; then
    echo "$(date) ALERT: 5 or more failed SSH attempts recorded" >> "$LOG"
fi

# 9. Monitoring completed
echo "$(date) Monitoring check completed" >> "$LOG"

