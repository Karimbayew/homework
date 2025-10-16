#!/bin/bash
set -e

mkdir -p test_env
cd test_env

touch regular_file.txt
mkdir regular_dir
touch .hidden_file
mkdir .hidden_dir
touch .another_hidden
mkdir .config

touch ..double_dot  # файл с двумя точками в начале
mkdir ...triple_dot

output=$(../solution.sh)

echo "$output" | grep -q '^.hidden_file$' || { echo "FAIL: .hidden_file не найден"; exit 1; }
echo "$output" | grep -q '^.hidden_dir$' || { echo "FAIL: .hidden_dir не найден"; exit 1; }
echo "$output" | grep -q '^.another_hidden$' || { echo "FAIL: .another_hidden не найден"; exit 1; }
echo "$output" | grep -q '^.config$' || { echo "FAIL: .config не найден"; exit 1; }

echo "$output" | grep -q 'regular_file' && { echo "FAIL: regular_file найден в выводе"; exit 1; }
echo "$output" | grep -q 'regular_dir' && { echo "FAIL: regular_dir найден в выводе"; exit 1; }

echo "$output" | grep -q '^\.$' && { echo "FAIL: . найден в выводе"; exit 1; }
echo "$output" | grep -q '^\.\.$' && { echo "FAIL: .. найден в выводе"; exit 1; }

echo "$output" | grep -q '^\.\.double_dot$' || { echo "FAIL: ..double_dot не найден"; exit 1; }
echo "$output" | grep -q '^\.\.\.triple_dot$' || { echo "FAIL: ...triple_dot не найден"; exit 1; }

sorted_output=$(echo "$output" | sort)
if [ "$output" != "$sorted_output" ]; then
    echo "FAIL: Вывод не отсортирован"
    exit 1
fi

line_count=$(echo "$output" | wc -l)
if [ "$line_count" -eq 6 ]; then
    echo "PASS: Все скрытые файлы найдены"
else
    echo "FAIL: Ожидалось 6 строк, получено $line_count"
    exit 1
fi

cd ..
rm -rf test_env