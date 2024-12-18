#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

zig build

# ./zig-out/bin/advent-of-code.exe ./data/2024-09-test.txt
./zig-out/bin/advent-of-code.exe ./data/2024-09.txt
