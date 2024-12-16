const std = @import("std");

// width doesn't include the new line
fn getIndex(x: u32, y: u32, width: u32) u32 {
    return (y * (width + 1)) + x;
}

fn getChar(x: u32, y: u32, width: u32, input: []u8) u8 {
    const index = getIndex(x, y, width);
    const character = input[index];
    return character;
}

pub fn answer(input: []u8) !void {
    std.debug.print("Day 4: Ceres Search\n", .{});
    // std.debug.print("{?s}\n", .{input});

    // get "width" of input
    var width: u32 = 0;
    var i: u32 = 0;
    while (i < input.len) : (i += 1) {
        const character = input[i];
        // std.debug.print("{} {?c}\n", .{ i, character });
        if (character == '\n') {
            width = i;
            break;
        }
    }

    const height = (input.len / width) - 1;

    std.debug.print("{} x {}\n", .{ width, height });

    // var x: u32 = 2;
    // var y: u32 = 0;
    // var index = getIndex(x, y, width);
    // var character = input[index];
    // std.debug.print("({},{}): {?c}\n", .{ x, y, character });

    // x = 3;
    // y = 7;
    // index = getIndex(x, y, width);
    // character = input[index];
    // std.debug.print("({},{}): {?c}\n", .{ x, y, character });

    var xmas: [4]u8 = undefined;
    var xmas_total: i32 = 0;
    var cross_mas_total: i32 = 0;
    var index: u32 = 0;
    i = 0;
    while (i < width) : (i += 1) {
        // std.debug.print("i: {} {}\n", .{ i, width });
        var j: u32 = 0;
        while (j < height) : (j += 1) {
            // std.debug.print("j: {} {}\n", .{ j, height });
            index = getIndex(i, j, width);
            if (index > (input.len - 1)) {
                std.debug.print("out of bounds ({}, {})\n", .{ i, j });
                break;
            }

            const character = input[index];
            if (character == 'X') {
                // std.debug.print("({}, {}) = {?c}\n", .{ i, j, character });
                // east
                if (width - i > 3) {
                    // std.debug.print("checking east\n", .{});
                    xmas[0] = getChar(i + 0, j, width, input);
                    xmas[1] = getChar(i + 1, j, width, input);
                    xmas[2] = getChar(i + 2, j, width, input);
                    xmas[3] = getChar(i + 3, j, width, input);

                    if (std.mem.eql(u8, &xmas, "XMAS")) {
                        // std.debug.print("E: ({}, {}): {?s}\n", .{ i, j, xmas });
                        xmas_total += 1;
                    }
                }

                // west
                if (i >= 3) {
                    // std.debug.print("checking west\n", .{});
                    xmas[0] = getChar(i - 0, j, width, input);
                    xmas[1] = getChar(i - 1, j, width, input);
                    xmas[2] = getChar(i - 2, j, width, input);
                    xmas[3] = getChar(i - 3, j, width, input);

                    if (std.mem.eql(u8, &xmas, "XMAS")) {
                        // std.debug.print("W: ({}, {}): {?s}\n", .{ i, j, xmas });
                        xmas_total += 1;
                    }
                }

                // south
                if (height - j > 3) {
                    // std.debug.print("checking south\n", .{});
                    xmas[0] = getChar(i, j + 0, width, input);
                    xmas[1] = getChar(i, j + 1, width, input);
                    xmas[2] = getChar(i, j + 2, width, input);
                    xmas[3] = getChar(i, j + 3, width, input);

                    if (std.mem.eql(u8, &xmas, "XMAS")) {
                        // std.debug.print("S: ({}, {}): {?s}\n", .{ i, j, xmas });
                        xmas_total += 1;
                    }
                }

                // north
                if (j >= 3) {
                    // std.debug.print("checking south\n", .{});
                    xmas[0] = getChar(i, j - 0, width, input);
                    xmas[1] = getChar(i, j - 1, width, input);
                    xmas[2] = getChar(i, j - 2, width, input);
                    xmas[3] = getChar(i, j - 3, width, input);

                    if (std.mem.eql(u8, &xmas, "XMAS")) {
                        // std.debug.print("N: ({}, {}): {?s}\n", .{ i, j, xmas });
                        xmas_total += 1;
                    }
                }

                // NE
                if (width - i > 3 and j >= 3) {
                    xmas[0] = getChar(i + 0, j - 0, width, input);
                    xmas[1] = getChar(i + 1, j - 1, width, input);
                    xmas[2] = getChar(i + 2, j - 2, width, input);
                    xmas[3] = getChar(i + 3, j - 3, width, input);

                    if (std.mem.eql(u8, &xmas, "XMAS")) {
                        // std.debug.print("NE: ({}, {}): {?s}\n", .{ i, j, xmas });
                        xmas_total += 1;
                    }
                }

                // SE
                if (width - i > 3 and height - j > 3) {
                    xmas[0] = getChar(i + 0, j + 0, width, input);
                    xmas[1] = getChar(i + 1, j + 1, width, input);
                    xmas[2] = getChar(i + 2, j + 2, width, input);
                    xmas[3] = getChar(i + 3, j + 3, width, input);

                    if (std.mem.eql(u8, &xmas, "XMAS")) {
                        // std.debug.print("SE: ({}, {}): {?s}\n", .{ i, j, xmas });
                        xmas_total += 1;
                    }
                }

                // SW
                if (i >= 3 and height - j > 3) {
                    xmas[0] = getChar(i - 0, j + 0, width, input);
                    xmas[1] = getChar(i - 1, j + 1, width, input);
                    xmas[2] = getChar(i - 2, j + 2, width, input);
                    xmas[3] = getChar(i - 3, j + 3, width, input);

                    if (std.mem.eql(u8, &xmas, "XMAS")) {
                        // std.debug.print("SW: ({}, {}): {?s}\n", .{ i, j, xmas });
                        xmas_total += 1;
                    }
                }

                // NW
                if (i >= 3 and j >= 3) {
                    xmas[0] = getChar(i - 0, j - 0, width, input);
                    xmas[1] = getChar(i - 1, j - 1, width, input);
                    xmas[2] = getChar(i - 2, j - 2, width, input);
                    xmas[3] = getChar(i - 3, j - 3, width, input);

                    if (std.mem.eql(u8, &xmas, "XMAS")) {
                        // std.debug.print("NW: ({}, {}): {?s}\n", .{ i, j, xmas });
                        xmas_total += 1;
                    }
                }
            }

            if (i > 0 and i < (width - 1) and j > 0 and j < (height - 1) and character == 'A') {
                // check for cross mas
                const a: [2]u8 = .{ getChar(i - 1, j - 1, width, input), getChar(i + 1, j + 1, width, input) };
                const check_a = std.mem.eql(u8, &a, "MS") or std.mem.eql(u8, &a, "SM");

                const b: [2]u8 = .{ getChar(i - 1, j + 1, width, input), getChar(i + 1, j - 1, width, input) };
                const check_b = std.mem.eql(u8, &b, "MS") or std.mem.eql(u8, &b, "SM");

                if (check_a and check_b) {
                    // std.debug.print("a {?s}\n", .{a});
                    // std.debug.print("b {?s}\n", .{b});
                    cross_mas_total += 1;
                }
            }
        }
    }

    std.debug.print("Part 1: {}\n", .{xmas_total});
    std.debug.print("Part 2: {}\n", .{cross_mas_total});
}
