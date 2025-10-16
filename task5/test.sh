#!/bin/bash
set -e

mkdir -p test_env
cd test_env

mkdir -p dir1/dir2/dir3/dir4/dir5/dir6
dd if=/dev/zero of=dir1/large1.dat bs=1M count=3 2>/dev/null
dd if=/dev/zero of=dir1/dir2/large2.dat bs=1M count=2 2>/dev/null
dd if=/dev/zero of=large3.dat bs=1M count=4 2>/dev/null

output=$(../solution.sh .)

# Должно быть 5 строк вывода (заголовок + 5 результатов)
line_count=$(echo "$output" | wc -l)
if [ $line_count -eq 5 ]; then
    echo "PASS: Disk usage analysis working"
else
    echo "FAIL: Expected 5 lines, got $line_count"
    exit 1
fi

cd ..
rm -rf test_env