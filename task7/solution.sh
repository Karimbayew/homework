#!/bin/bash

# Переходим в указанную директорию если передана как аргумент
if [ $# -eq 1 ]; then
    cd "$1" 2>/dev/null || {
        echo "Error: Directory '$1' does not exist"
        exit 1
    }
fi

# Выводим скрытые файлы, исключая . и .., сортируем
for item in .*; do
    if [ "$item" != "." ] && [ "$item" != ".." ] && [ -e "$item" ]; then
        echo "$item"
    fi
done | sort