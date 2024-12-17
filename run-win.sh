#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

zig build

# ./zig-out/bin/advent-of-code.exe ./data/2024-07-test.txt
./zig-out/bin/advent-of-code.exe ./data/2024-07.txt
