#!/bin/bash
set -e

# Создаем тестовую среду
mkdir -p test_env
cd test_env

echo "foo test foo" > file1.txt
echo "another foo here" > file2.txt
mkdir -p subdir
echo "foo in subdir" > subdir/file3.txt

# Запускаем решение студента
../solution.sh . "foo" "bar"

# Проверяем результаты
grep -q "bar test bar" file1.txt || { echo "FAIL: file1 not replaced"; exit 1; }
grep -q "another bar here" file2.txt || { echo "FAIL: file2 not replaced"; exit 1; }
grep -q "bar in subdir" subdir/file3.txt || { echo "FAIL: file3 not replaced"; exit 1; }

echo "PASS: All files correctly modified"
cd ..
rm -rf test_env