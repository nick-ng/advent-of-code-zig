const std = @import("std");
const utils = @import("./utils.zig");
const aoc2019day1 = @import("./2019/01.zig");
const aoc2024day1 = @import("./2024/01.zig");

const digits: [10]u8 = .{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };

pub fn main() !void {
    var args_iter = std.process.args();

    _ = args_iter.skip();
    const temp_filename = args_iter.next();

    if (temp_filename == null) {
        std.debug.print("no input file given\n", .{});
        return;
    }

    const filename = temp_filename.?;
    std.debug.print("filename: {?s}\n", .{filename});
    var year: u32 = 0;
    var day: u8 = 0;
    var word: [20]u8 = undefined;
    var word_counter: u32 = 0;
    var i: u32 = 0;
    while (i < filename.len) : (i += 1) {
        const character = filename[i];
        if (character == '.' or character == '/' or character == '-') {
            if (word_counter == 0) {
                continue;
            }

            const temp1: []u8 = word[0..word_counter];
            word_counter = 0;
            if (year == 0) {
                year = std.fmt.parseInt(u32, temp1, 10) catch |err| {
                    std.debug.print("Could not parse year because: {}\n", .{err});
                    return err;
                };
            } else if (day == 0) {
                day = try std.fmt.parseInt(u8, temp1, 10);
            }

            continue;
        }

        var j: u32 = 0;
        while (j < digits.len) : (j += 1) {
            if (character == digits[j]) {
                word[word_counter] = character;
                word_counter += 1;
            }
        }
    }

    std.debug.print("{}, day {}\n", .{ year, day });

    const allocator = std.heap.page_allocator;
    const file_content = try utils.readFile(filename, allocator);
    defer allocator.free(file_content);

    switch (year) {
        2019 => {
            switch (day) {
                1 => {
                    try aoc2019day1.answer(file_content);
                    return;
                },
                else => {
                    std.debug.print("No solution for {}, day {}\n", .{ year, day });
                    return;
                },
            }
        },
        2024 => {
            switch (day) {
                1 => {
                    try aoc2024day1.answer(file_content);
                },
                else => {
                    std.debug.print("No solution for {}, day {}\n", .{ year, day });
                    return;
                },
            }
        },
        else => {
            std.debug.print("No solutions for {}\n", .{year});
            return;
        },
    }
}
