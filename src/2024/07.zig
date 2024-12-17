const std = @import("std");

const operator_type_count: u32 = 3;

fn getOperator(permutation_index: u32, position: u32) u32 {
    // remove low significance
    const divisor = std.math.pow(u32, operator_type_count, position);
    const temp = permutation_index / divisor;
    const result = temp % operator_type_count;

    return result;
}

pub fn answer(input: []u8) !void {
    std.debug.print("Day 7: Bridge Repair\n", .{});
    // std.debug.print("debug: {?s}\n", .{input});

    var total_calibration_result: i64 = 0;
    var total_calibration_result_b: i64 = 0;
    var number_buffer: [20]u8 = undefined;
    var number_index: u32 = 0;
    var number: i64 = 0;
    var have_number: bool = false;
    var factor_buffer: [20]u8 = undefined;
    var factor_index: u32 = 0;
    var factors: [20]i64 = undefined;
    var factor_count: u32 = 0;
    var i: u32 = 0;
    while (i < input.len) : (i += 1) {
        const character = input[i];
        if (character == ' ' or character == '\n') {
            // parse the previous factor and add to the array
            const factor_str = factor_buffer[0..factor_index];
            const factor = std.fmt.parseInt(i64, factor_str, 10) catch {
                std.debug.print("error: not an int {?s}", .{factor_str});
                return;
            };
            factors[factor_count] = factor;
            factor_count += 1;
            factor_index = 0;

            if (character == '\n') {
                // figure out the sum

                const operator_permutations = std.math.pow(u32, operator_type_count, factor_count - 1);

                // std.debug.print("{}: {any} ({})\n", .{ number, factors[0..factor_count], operator_permutations });

                var j: u32 = 0;
                // var found_correct_operator_combination: bool = false;
                while (j < operator_permutations) : (j += 1) {
                    var k: u32 = 1;
                    var result: i64 = factors[0];
                    var used_concat: bool = false;
                    while (k < factor_count) : (k += 1) {
                        // const operator_mask = std.math.pow(u32, 2, k - 1);
                        const a = getOperator(j, k - 1);
                        if (a == 0) {
                            // std.debug.print("+", .{});
                            result = result + factors[k];
                        } else if (a == 1) {
                            // std.debug.print("*", .{});
                            result = result * factors[k];
                        } else {
                            used_concat = true;
                            var buf: [20]u8 = undefined;
                            const str = try std.fmt.bufPrint(&buf, "{}{}", .{ result, factors[k] });
                            result = try std.fmt.parseInt(i64, str, 10);
                            // std.debug.print("debug: {}\n", .{result});
                        }

                        if (result > number) {
                            break;
                        }
                    }

                    if (result == number) {
                        if (!used_concat) {
                            total_calibration_result += number;
                        }

                        total_calibration_result_b += number;
                        break;
                    }

                    // std.debug.print("\n", .{});
                }

                // reset indices
                number_index = 0;
                factor_index = 0;
                factor_count = 0;
                have_number = false;
            }

            continue;
        }

        if (character == ':') {
            // advance i an extra time to skip the space
            i += 1;
            // parse the number;
            const number_str = number_buffer[0..number_index];
            number = try std.fmt.parseInt(i64, number_str, 10);
            have_number = true;

            continue;
        }

        if (have_number) {
            factor_buffer[factor_index] = character;
            factor_index += 1;
        } else {
            number_buffer[number_index] = character;
            number_index += 1;
        }
    }

    std.debug.print("Part 1: {}\n", .{total_calibration_result});
    std.debug.print("Part 2: {}\n", .{total_calibration_result_b});
}
