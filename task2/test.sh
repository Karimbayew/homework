#!/bin/bash
set -e

mkdir -p test_env
cd test_env

mkdir -p dir1/dir2
echo "test" > file1.txt
dd if=/dev/zero of=largefile.dat bs=1M count=2 2>/dev/null
echo "small" > small.txt

output=$(../solution.sh .)

echo "$output" | grep -q "Files: 3" || { echo "FAIL: File count wrong"; exit 1; }
echo "$output" | grep -q "Dirs: 3" || { echo "FAIL: Dir count wrong"; exit 1; }
echo "$output" | grep -q "largefile.dat" || { echo "FAIL: Largest file not found"; exit 1; }

echo "PASS: Statistics correct"
cd ..
rm -rf test_env