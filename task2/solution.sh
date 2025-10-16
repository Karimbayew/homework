#!/bin/bash

# Проверка аргументов
if [ $# -eq 0 ]; then
    path="."
elif [ $# -eq 1 ]; then
    path="$1"
else
    echo "Использование: $0 [путь_к_директории]"
    exit 1
fi

# Проверка существования директории
if [ ! -d "$path" ]; then
    echo "Ошибка: Директория '$path' не существует"
    exit 1
fi

echo "Статистика для директории: $path"
echo "=========================================="

# Используем find для подсчета
file_count=$(find "$path" -type f 2>/dev/null | wc -l)
dir_count=$(find "$path" -type d 2>/dev/null | tail -n +2 | wc -l)  # tail -n +2 чтобы исключить саму директорию

# Находим самый большой файл
largest_file=$(find "$path" -type f -exec du -b {} + 2>/dev/null | sort -nr | head -1)

# Вывод результатов
echo "Количество файлов: $file_count"
echo "Количество директорий: $dir_count"

if [ -n "$largest_file" ]; then
    size=$(echo "$largest_file" | awk '{print $1}')
    file_path=$(echo "$largest_file" | cut -f2-)
    filename=$(basename "$file_path")
    
    # Форматируем размер для читаемости
    if command -v numfmt >/dev/null 2>&1; then
        # Используем numfmt если доступен
        human_size=$(numfmt --to=iec $size)
    else
        # Ручное форматирование
        if [ $size -ge 1073741824 ]; then
            human_size=$(echo "scale=2; $size/1073741824" | bc)" GB"
        elif [ $size -ge 1048576 ]; then
            human_size=$(echo "scale=2; $size/1048576" | bc)" MB"
        elif [ $size -ge 1024 ]; then
            human_size=$(echo "scale=2; $size/1024" | bc)" KB"
        else
            human_size="$size bytes"
        fi
    fi
    
    echo "Самый большой файл: $filename"
    echo "Размер: $human_size ($size bytes)"
    echo "Путь: $file_path"
else
    echo "Самый большой файл: не найден"
fi

echo "=========================================="