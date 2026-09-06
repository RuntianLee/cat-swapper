#!/bin/sh
set -eu

sha256_file() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    sha256sum "$1" | awk '{print $1}'
  fi
}

check_hash() {
  path=$1
  expected=$2
  actual=$(sha256_file "$path")
  test "$actual" = "$expected" || {
    echo "SHA-256 mismatch: $path" >&2
    echo "expected: $expected" >&2
    echo "actual:   $actual" >&2
    exit 1
  }
  grep -Fq "$expected" README.md
}

test -f skills/cat-swapper/references/single-cat.md
test -f skills/cat-swapper/references/multi-cat.md
grep -Fq 'references/single-cat.md' skills/cat-swapper/SKILL.md
grep -Fq 'references/multi-cat.md' skills/cat-swapper/SKILL.md
grep -Fq 'prompt.txt' skills/cat-swapper/references/single-cat.md
grep -Fq 'prompt-multi.txt' skills/cat-swapper/references/multi-cat.md

check_hash skills/cat-swapper/prompt.txt c4a5bc29660791242df2c49fbda6576208baaaea00e94fca12fd4efc008dbe96
check_hash skills/cat-swapper/prompt-multi.txt 23bb0b2a20d751a8eb83a414247cf2be1b6dc92aa2fc7ef625c902b33751c554
check_hash skills/dog-swapper/prompt.txt a354867f9b97a48dc7f3457204b6d672e3b62bd80f6f528482ef71ffd79f3fb6

echo "Skill files and prompt hashes are valid."
