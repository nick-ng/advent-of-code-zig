const std = @import("std");

const digits: [10]u8 = .{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
const multiply_pattern: [8]u8 = .{ 'm', 'u', 'l', '(', 'd', ',', 'd', ')' };
const enable_pattern: [4]u8 = .{ 'd', 'o', '(', ')' };
const disable_pattern: [7]u8 = .{ 'd', 'o', 'n', '\'', 't', '(', ')' };

pub fn answer(input: []u8) !void {
    std.debug.print("Day 3: Mull It Over\n", .{});
    // std.debug.print("{?s}", .{input});

    var number_a: i32 = undefined;
    var number_b: i32 = undefined;

    var operator_buffer: [20]u8 = undefined;
    var operator_index: u32 = 0;
    var number_buffer: [3]u8 = undefined;
    var number_index: u32 = 0;
    var pattern_index: u32 = 0; // 8
    var enable_pattern_index: u32 = 0;
    var disable_pattern_index: u32 = 0;

    var total: i32 = 0;
    var toggle_total: i32 = 0;
    var enabled: bool = true;

    var i: u32 = 0;
    while (i < input.len) : (i += 1) {
        const character = input[i];
        // std.debug.print("character: {?c} {?c}\n", .{ character, multiply_pattern[pattern_index] });
        if (enable_pattern[enable_pattern_index] == character) {
            if (character == ')') {
                enable_pattern_index = 0;
                enabled = true;
            } else {
                enable_pattern_index += 1;
            }
        } else {
            enable_pattern_index = 0;
        }

        if (disable_pattern[disable_pattern_index] == character) {
            if (character == ')') {
                disable_pattern_index = 0;
                enabled = false;
            } else {
                disable_pattern_index += 1;
            }
        } else {
            disable_pattern_index = 0;
        }

        if (multiply_pattern[pattern_index] == character) {
            operator_buffer[operator_index] = character;
            operator_index += 1;
            // std.debug.print("match! {} {?c}\n", .{ pattern_index, multiply_pattern[pattern_index] });
            if (character == ',' or character == ')') {
                const number_string = number_buffer[0..number_index];
                const number = try std.fmt.parseInt(i32, number_string, 10);
                // std.debug.print("number: {}\n", .{number});
                number_index = 0;

                if (character == ',') {
                    number_a = number;
                }
                if (character == ')') {
                    number_b = number;

                    const product = number_a * number_b;
                    // std.debug.print("{} * {} = {}\n", .{ number_a, number_b, product });
                    total += product;
                    if (enabled) {
                        toggle_total += product;
                    }
                    // std.debug.print("{?s} = {} ({})\n", .{ operator_buffer[0..operator_index], product, total });
                    operator_index = 0;
                    pattern_index = 0;
                    number_a = 0;
                    number_b = 0;
                }
            }

            if (character != ')') {
                pattern_index += 1;
            }
        } else if (multiply_pattern[pattern_index] == 'd' or (pattern_index > 0 and multiply_pattern[pattern_index - 1] == 'd')) {
            // std.debug.print("digit\n", .{});
            var is_digit: bool = false;
            var j: u32 = 0;
            while (j < digits.len) : (j += 1) {
                // std.debug.print("{?c} == {?c}\n", .{ digits[j], character });
                if (digits[j] == character) {
                    // std.debug.print("match! {} {?c}\n", .{ pattern_index, multiply_pattern[pattern_index] });
                    number_buffer[number_index] = character;
                    number_index += 1;
                    is_digit = true;
                    operator_buffer[operator_index] = character;
                    operator_index += 1;
                    break;
                }
            }

            if (!is_digit) {
                // std.debug.print("not a digit", .{});
                pattern_index = 0;
                number_index = 0;
                operator_index = 0;
                if (character == multiply_pattern[0]) {
                    operator_buffer[operator_index] = character;
                    operator_index += 1;
                    pattern_index = 1;
                }
            } else if (multiply_pattern[pattern_index] == 'd') {
                pattern_index += 1;
            }
        } else {
            operator_index = 0;
            pattern_index = 0;
            number_index = 0;
            if (character == multiply_pattern[0]) {
                operator_buffer[operator_index] = character;
                operator_index += 1;
                pattern_index = 1;
            }
        }
    }

    std.debug.print("Part 1: {}\n", .{total});
    std.debug.print("Part 2: {}\n", .{toggle_total});
}
