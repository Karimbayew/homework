#!/bin/bash
set -e

mkdir -p test_env/logs test_env/archive
cd test_env

# Создаем старые файлы
echo "log1" > logs/file1.log
echo "log2" > logs/file2.log

# Меняем дату модификации на 8 дней назад
touch -d "8 days ago" logs/file1.log
touch -d "8 days ago" logs/file2.log

# Создаем новый файл
echo "log3" > logs/file3.log

../solution.sh logs archive

# Проверяем что старые файлы заархивированы
if [ -f archive/file1.log.gz ] && [ -f archive/file2.log.gz ]; then
    # Проверяем что новый файл не тронут
    [ -f logs/file3.log ] || { echo "FAIL: New file removed"; exit 1; }
    echo "PASS: Log rotation working"
else
    echo "FAIL: Old files not archived"
    exit 1
fi

cd ..
rm -rf test_env