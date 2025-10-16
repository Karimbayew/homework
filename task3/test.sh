#!/bin/bash
set -e

mkdir -p test_env
cd test_env

cat > test.log << EOF
2023-10-25 10:00:00 | INFO | System started
2023-10-25 10:01:00 | ERROR | Database connection failed
2023-10-25 10:02:00 | WARN | High memory usage
2023-10-25 10:03:00 | INFO | User login
2023-10-25 10:04:00 | ERROR | File not found
2023-10-25 10:05:00 | INFO | Backup completed
EOF

output=$(../solution.sh test.log)

echo "$output" | grep -q "INFO.*3" || { echo "FAIL: INFO count wrong"; exit 1; }
echo "$output" | grep -q "ERROR.*2" || { echo "FAIL: ERROR count wrong"; exit 1; }
echo "$output" | grep -q "WARN.*1" || { echo "FAIL: WARN count wrong"; exit 1; }

echo "PASS: Log parsing correct"
cd ..
rm -rf test_env