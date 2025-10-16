#!/bin/bash
set -e

output=$(./solution.sh)

echo $output

# Проверяем что вывод содержит нужные колонки
echo "$output" | head -1 | grep -q "PID" || { echo "FAIL: PID column missing"; exit 1; }
echo "$output" | head -1 | grep -q "%MEM" || { echo "FAIL: PMEM column missing"; exit 1; }
echo "$output" | head -1 | grep -q "COMM" || { echo "FAIL: COMM column missing"; exit 1; }

echo "PASS: Process list formatted correctly"