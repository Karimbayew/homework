#!/bin/bash

# Проверка аргументов
if [ $# -ne 1 ]; then
    echo "Использование: $0 <путь_к_директории>"
    exit 1
fi

path="$1"

# Проверка существования директории
if [ ! -d "$path" ]; then
    echo "Ошибка: Директория '$path' не существует"
    exit 1
fi

# Подсчет файлов и директорий
file_count=$(find "$path" -type f | wc -l)
dir_count=$(find "$path" -type d | tail -n +2 | wc -l)  # исключаем саму директорию из подсчета

# Самый большой файл
largest_file=$(find "$path" -type f -exec du -b {} + 2>/dev/null | sort -nr | head -1)

if [ -n "$largest_file" ]; then
    size=$(echo "$largest_file" | awk '{print $1}')
    file_path=$(echo "$largest_file" | awk '{$1=""; print $0}' | sed 's/^ //')
    file_name=$(basename "$file_path")
else
    size=0
    file_name=""
    file_path=""
fi

# Вывод В ТОЧНОМ ФОРМАТЕ который ожидают тесты
echo "Files: $file_count"
echo "Directories: $dir_count"
if [ -n "$largest_file" ]; then
    echo "Largest file: $file_name ($size bytes)"
else
    echo "Largest file:  (0 bytes)"
fi