#!/bin/bash

# Вариант 1: Используем ps с совместимыми опциями
ps -u $(whoami) -o pid,pmem,comm --sort=-pmem 2>/dev/null || {
  # Вариант 2: Если предыдущая команда не работает, используем альтернативный подход
  echo "PID %MEM COMM"
  ps -e -o pid,pmem,comm --sort=-pmem 2>/dev/null | grep "^[ ]*[0-9]*[ ]*[0-9.]*[ ]*.*" | while read line; do
    echo "$line"
  done
}