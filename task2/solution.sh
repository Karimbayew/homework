#!/bin/bash

if [ $# -eq 0 ]; then
    path="."
else
    path="$1"
fi

if [ ! -d "$path" ]; then
    echo "Ошибка: Директория '$path' не существует"
    exit 1
fi

echo "Статистика для директории: $path"
echo "=================================================="

# Количество файлов и директорий
file_count=0
dir_count=0

while IFS= read -r -d '' item; do
    if [ -f "$item" ]; then
        ((file_count++))
    elif [ -d "$item" ]; then
        ((dir_count++))
    fi
done < <(find "$path" -mindepth 1 -print0 2>/dev/null)

# Самый большой файл
largest_file=$(find "$path" -type f -printf "%s %p\n" 2>/dev/null | sort -nr | head -1)

echo "Количество файлов: $file_count"
echo "Количество директорий: $dir_count"

if [ -n "$largest_file" ]; then
    size=$(echo "$largest_file" | awk '{print $1}')
    file_path=$(echo "$largest_file" | cut -d' ' -f2-)
    file_name=$(basename "$file_path")
    
    size_kb=$(echo "scale=2; $size / 1024" | bc)
    size_mb=$(echo "scale=2; $size / 1048576" | bc)
    
    echo "Самый большой файл: $file_name"
    echo "Размер: $size байт ($size_kb KB, $size_mb MB)"
    echo "Путь: $file_path"
else
    echo "Файлы не найдены"
fi

echo "=================================================="