#!/bin/bash

# Проверяем, передан ли аргумент (путь к директории)
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

directory="$1"

# Проверяем, существует ли директория
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist"
    exit 1
fi

# Используем временные файлы для хранения результатов
temp_file=$(mktemp)
temp_dirs=$(mktemp)

# Находим все файлы и директории
find "$directory" -type f 2>/dev/null > "$temp_file"
find "$directory" -type d 2>/dev/null > "$temp_dirs"

# Считаем количество
file_count=$(wc -l < "$temp_file")
dir_count=$(wc -l < "$temp_dirs")

# Находим самый большой файл
if [ $file_count -gt 0 ]; then
    largest_info=$(find "$directory" -type f -exec du -b {} + 2>/dev/null | sort -nr | head -1)
    if [ -n "$largest_info" ]; then
        largest_size=$(echo "$largest_info" | awk '{print $1}')
        largest_path=$(echo "$largest_info" | awk '{print $2}')
        largest_file=$(basename "$largest_path")
    else
        largest_file=""
        largest_size=0
    fi
else
    largest_file=""
    largest_size=0
fi

# Выводим результаты
echo "Files: $file_count"
echo "Dirs: $dir_count"
if [ $file_count -gt 0 ] && [ -n "$largest_file" ]; then
    echo "Largest file: $largest_file ($largest_size bytes)"
else
    echo "Largest file: -"
fi

# Удаляем временные файлы
rm -f "$temp_file" "$temp_dirs"