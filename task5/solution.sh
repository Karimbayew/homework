#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist"
    exit 1
fi

# Используем временный файл для хранения результатов
temp_file=$(mktemp)

# Получаем размеры поддиректорий
du -b --max-depth=1 "$directory" 2>/dev/null | sort -nr | head -n 6 | tail -n +2 > "$temp_file"

# Читаем и выводим размеры
count=0
while IFS= read -r line && [ $count -lt 5 ]; do
    size=$(echo "$line" | awk '{print $1}')
    echo "$size"
    ((count++))
done < "$temp_file"

# Дополняем нулями, если нужно
while [ $count -lt 5 ]; do
    echo "0"
    ((count++))
done

# Удаляем временный файл
rm -f "$temp_file"