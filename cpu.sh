#!/bin/bash
LOGFILE="/var/log/cpu_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Read CPU stats twice with 1 second interval
CPU1=($(grep '^cpu ' /proc/stat))
sleep 1
CPU2=($(grep '^cpu ' /proc/stat))

# Extract idle and total times
IDLE1=${CPU1[4]}
IDLE2=${CPU2[4]}

TOTAL1=0
TOTAL2=0
for VALUE in "${CPU1[@]:1}"; do
    TOTAL1=$((TOTAL1 + VALUE))
done
for VALUE in "${CPU2[@]:1}"; do
    TOTAL2=$((TOTAL2 + VALUE))
done

# Calculate CPU usage percentage
DIFF_IDLE=$((IDLE2 - IDLE1))
DIFF_TOTAL=$((TOTAL2 - TOTAL1))
UTIL=$(( (100 * (DIFF_TOTAL - DIFF_IDLE)) / DIFF_TOTAL ))

# Determine status
if [ "$UTIL" -lt 80 ]; then
    STATUS="OK"
    EXIT=0
elif [ "$UTIL" -lt 90 ]; then
    STATUS="WARNING"
    EXIT=1
else
    STATUS="CRITICAL"
    EXIT=2
fi

echo "$TIMESTAMP - $STATUS - ${UTIL}% utilization" >> "$LOGFILE"
echo "Healthcheck run at: $(data)"
=======
# Log CPU status and top processes
{
    echo "$TIMESTAMP - $STATUS - ${UTIL}% utilization"
    echo "Top 5 CPU-consuming processes:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo "----------------------------------------"
} >> "$LOGFILE"
echo "Healthcheck run at: $(date)"

exit $EXIT

