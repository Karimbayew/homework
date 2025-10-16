#!/bin/bash

# Проверяем, передан ли аргумент (путь к файлу лога)
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

log_file="$1"

# Проверяем, существует ли файл
if [ ! -f "$log_file" ]; then
    echo "Error: Log file '$log_file' does not exist"
    exit 1
fi

# Инициализируем счетчики
info_count=0
error_count=0
warn_count=0
debug_count=0
other_count=0

# Читаем файл построчно
while IFS= read -r line; do
    # Извлекаем уровень лога (второе поле после разделителя "|")
    # Убираем лишние пробелы и преобразуем в верхний регистр для единообразия
    level=$(echo "$line" | awk -F'|' '{print $2}' | tr -d ' ' | tr '[:lower:]' '[:upper:]')
    
    case "$level" in
        "INFO")
            ((info_count++))
            ;;
        "ERROR")
            ((error_count++))
            ;;
        "WARN"|"WARNING")
            ((warn_count++))
            ;;
        "DEBUG")
            ((debug_count++))
            ;;
        "")
            # Пропускаем пустые строки или строки без уровня
            ;;
        *)
            ((other_count++))
            ;;
    esac
done < "$log_file"

# Выводим результаты
echo "INFO: $info_count"
echo "ERROR: $error_count"
echo "WARN: $warn_count"

# Если есть debug сообщения, выводим их тоже
if [ $debug_count -gt 0 ]; then
    echo "DEBUG: $debug_count"
fi

# Если есть другие уровни, выводим их
if [ $other_count -gt 0 ]; then
    echo "OTHER: $other_count"
fi