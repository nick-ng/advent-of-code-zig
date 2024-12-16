#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

zig build

./zig-out/bin/advent-of-code.exe ./data/2024-04-test.txt
# ./zig-out/bin/advent-of-code.exe ./data/2024-04.txt
