#!/bin/bash

# Проверяем, что передано ровно 3 аргумента
if [ $# -ne 3 ]; then
  echo "Usage: $0 <directory> <search_string> <replace_string>"
  exit 1
fi

dir=$1
search=$2
replace=$3

# Проверяем, что директория существует
if [ ! -d "$dir" ]; then
  echo "Directory not found: $dir"
  exit 1
fi

# Ищем все .txt файлы и заменяем строку
find "$dir" -type f -name "*.txt" -exec sed -i "s/${search}/${replace}/g" {} +

