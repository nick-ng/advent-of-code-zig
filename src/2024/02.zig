const std = @import("std");

pub fn answer(input: []u8) !void {
    std.debug.print("Day 2: Red-Nosed Reports\n", .{});
    std.debug.print("{?s}", .{input});

    // a report consists of a number of levels
    // const reports: [1000][]i32 = undefined;
    var report_index: u32 = 0;
    var report: [20]i32 = undefined;
    var level_index: u32 = 0;

    var safe_reports: i32 = 0;

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

            std.debug.print("number: {}\n", .{number});

            if (character == '\n') {
                var j: u32 = 2;

                var direction: i32 = 1;
                var difference = report[1] - report[0];
                var safe: i32 = 1;
                if (difference < 0) {
                    direction = -1;
                    difference = difference * direction;
                }

                if (difference < 1 or difference > 3) {
                    safe = 0;
                }

                var prev_level = report[1];
                while (j < level_index) : (j += 1) {
                    const curr_level = report[j];
                    difference = curr_level - prev_level;
                    difference = difference * direction;
                    std.debug.print("difference: {}\n", .{difference});
                    if (difference < 1 or difference > 3) {
                        safe = 0;
                    }

                    prev_level = curr_level;
                }

                std.debug.print("safe: {}\n", .{safe});

                safe_reports += safe;

                // std.debug.print("report: {any}\n", .{reports[report_index]});

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
}
