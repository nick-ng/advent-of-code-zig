const std = @import("std");

pub fn answer(input: []u8) !void {
    std.debug.print("Day 2: Red-Nosed Reports\n", .{});
    // std.debug.print("{?s}", .{input});

    // a report consists of a number of levels
    // const reports: [1000][]i32 = undefined;
    var report_index: u32 = 0;
    var report: [20]i32 = undefined;
    var level_index: u32 = 0;

    var safe_reports: i32 = 0;
    var safe_reports_with_pd: i32 = 0;

    var word_buffer: [20]u8 = undefined;
    var word_buffer_index: u32 = 0;
    var i: u32 = 0;
    while (i < input.len) : (i += 1) {
        const character = input[i];

        if (character == ' ' or character == '\n') {
            // std.debug.print("word_buffer: {?s}\n", .{word_buffer});
            const word = word_buffer[0..word_buffer_index];
            // std.debug.print("word: {?s}\n", .{word});
            const number = try std.fmt.parseInt(i32, word, 10);
            report[level_index] = number;

            level_index += 1;
            word_buffer_index = 0;

            // std.debug.print("number: {}\n", .{number});

            if (character == '\n') {
                var problem_dampener: i32 = -1;

                while (problem_dampener < level_index) : (problem_dampener += 1) {
                    var j: u32 = 0;
                    var is_first: bool = true;
                    var prev_level: i32 = 0;

                    var safe_inc: bool = true;
                    var safe_dec: bool = true;
                    var difference: i32 = undefined;
                    while (j < level_index) : (j += 1) {
                        if (j == problem_dampener) {
                            continue;
                        }
                        const curr_level = report[j];

                        if (is_first) {
                            prev_level = curr_level;
                            is_first = false;
                            continue;
                        }

                        difference = curr_level - prev_level;

                        if (difference < 1 or difference > 3) {
                            safe_inc = false;
                        }
                        if (difference > -1 or difference < -3) {
                            safe_dec = false;
                        }

                        // std.debug.print("difference: {}, {}, {}\n", .{ difference, safe_inc, safe_dec });

                        prev_level = curr_level;
                    }

                    if (safe_inc or safe_dec) {
                        if (problem_dampener == -1) {
                            safe_reports += 1;
                        }

                        safe_reports_with_pd += 1;
                        break;
                    }

                    // std.debug.print("report: {any}\n", .{reports[report_index]});

                }

                report_index += 1;
                level_index = 0;
                word_buffer_index = 0;
            }

            continue;
        }

        word_buffer[word_buffer_index] = character;
        word_buffer_index += 1;
    }

    std.debug.print("Part 1: {}\n", .{safe_reports});
    std.debug.print("Part 2: {}\n", .{safe_reports_with_pd});
}
