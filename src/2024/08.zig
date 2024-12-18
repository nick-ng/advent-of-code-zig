const std = @import("std");
const utils = @import("./utils.zig");

pub fn answer(input: []u8) !void {
    std.debug.print("Day 8: Resonant Collinearity\n", .{});
    // std.debug.print("debug:\n{?s}\n", .{input});

    const allocator = std.heap.page_allocator;

    const result = try allocator.alloc(u8, input.len);
    defer allocator.free(result);

    @memcpy(result, input);

    // find the width
    var width: u32 = 0;
    var i: u32 = 0;
    while (i < input.len) : (i += 1) {
        const character = input[i];
        if (character == '\n') {
            width = i;
            break;
        }
    }

    const height = (input.len / width) - 1;
    const height_f: f64 = @floatFromInt(height);

    // std.debug.print("debug: {} x {}\n", .{ width, height });

    var naive_antinode_count: u32 = 0;
    var naive_resonant_harmonics_count: u32 = 0;
    i = 0;
    while (i < (input.len - 1)) : (i += 1) {
        const character = input[i];

        if (character != '\n' and character != '.') {
            // var same_frequency_count: u32 = 0;
            var j: u32 = i + 1;
            while (j < input.len) : (j += 1) {
                const character_2 = input[j];
                if (character == character_2) {
                    const coords_i = utils.getSignedCoords(i, width);
                    const coords_j = utils.getSignedCoords(j, width);

                    // i - j
                    const difference_x: i32 = coords_i[0] - coords_j[0];

                    // i - j
                    const difference_y: i32 = coords_i[1] - coords_j[1];

                    // std.debug.print("debug: {?c} {any} {any} ({}, {})\n", .{ character, coords_i, coords_j, difference_x, difference_y });

                    // d = i - j
                    // i = j + d
                    // k = j + 2d
                    // j = i - d
                    // l = i - 2d

                    const antinode_k_x = coords_j[0] + 2 * difference_x;
                    const antinode_k_y = coords_j[1] + 2 * difference_y;
                    if (antinode_k_x >= 0 and antinode_k_x < width and antinode_k_y >= 0 and antinode_k_y < height) {
                        naive_antinode_count += 1;
                        const index_k = utils.getIndexFromSigned(antinode_k_x, antinode_k_y, width);
                        result[index_k] = '#';
                    }

                    const antinode_l_x = coords_i[0] - 2 * difference_x;
                    const antinode_l_y = coords_i[1] - 2 * difference_y;
                    if (antinode_l_x >= 0 and antinode_l_x < width and antinode_l_y >= 0 and antinode_l_y < height) {
                        naive_antinode_count += 1;
                        const index_l = utils.getIndexFromSigned(antinode_l_x, antinode_l_y, width);
                        result[index_l] = '#';
                    }

                    const diff_x_f: f64 = @floatFromInt(difference_x);
                    const diff_y_f: f64 = @floatFromInt(difference_y);
                    const gradient = diff_y_f / diff_x_f;

                    const x_f: f64 = @floatFromInt(coords_i[0]);
                    const y_f: f64 = @floatFromInt(coords_i[1]);

                    // y = k x + c
                    // c = y - (k * x)
                    const constant = y_f - (gradient * x_f);

                    // std.debug.print("debug: line formula {?c}: y = {} * x + {}\n", .{ character, gradient, constant });

                    var k: u32 = 0;
                    while (k < width) : (k += 1) {
                        const x: f64 = @floatFromInt(k);
                        const y = gradient * x + constant;

                        // const y_floor = @floor(y);
                        const y_round = @round(y);

                        const diff = @abs(y - y_round);
                        const tol = 1e-10;
                        if (y != y_round and diff < tol) {
                            // std.debug.print("debug: {?c} {} {} {}\n", .{ character, diff, .{ x, y }, .{ x, y_round } });
                        }

                        if (diff < tol and y >= 0 and y < height_f) {
                            const y_i: u32 = @intFromFloat(y_round);
                            const index_f = utils.getIndex(k, y_i, width);
                            // std.debug.print("debug: {}\n", .{.{ k, y_i }});
                            const character_f = result[index_f];
                            if (character_f != '#') {
                                result[index_f] = character;
                            }
                            naive_resonant_harmonics_count += 1;
                        }
                    }
                }
            }

            // std.debug.print("debug: {?c}: {}\n", .{ character, same_frequency_count });
        }
    }

    var antinode_count: u32 = 0;
    var resonant_harmonics_count: u32 = 0;
    i = 0;
    while (i < result.len) : (i += 1) {
        const character = result[i];
        if (character == '#') {
            antinode_count += 1;
        }

        if (character != '.' and character != '\n') {
            resonant_harmonics_count += 1;
        }
    }

    // std.debug.print("debug: overlapping antinodes {}\n", .{naive_antinode_count - antinode_count});
    // std.debug.print("debug: overlapping resonant_harmonics {}\n", .{naive_resonant_harmonics_count - resonant_harmonics_count});

    // std.debug.print("debug:\n{?s}\n", .{result});
    std.debug.print("Part 1: {}\n", .{antinode_count});
    std.debug.print("Part 2: {}\n", .{resonant_harmonics_count});
}
