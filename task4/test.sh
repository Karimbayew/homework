#!/bin/bash
set -e

mkdir -p test_env
cd test_env

mkdir -p test_dir/subdir
echo "test" > test_dir/file1.txt
echo "test2" > test_dir/subdir/file2.txt

../solution.sh test_dir

# Проверяем права
file_perms=$(stat -c "%a" test_dir/file1.txt)
dir_perms=$(stat -c "%a" test_dir/subdir)

if [ "$file_perms" = "640" ] && [ "$dir_perms" = "750" ]; then
    echo "PASS: Permissions set correctly"
else
    echo "FAIL: Permissions wrong (files: $file_perms, dirs: $dir_perms)"
    exit 1
fi

cd ..
rm -rf test_env