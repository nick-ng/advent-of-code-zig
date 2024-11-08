const std = @import("std");
const aoc2019day1 = @import("./2019/01.zig");

pub fn main() !void {
    std.debug.print("hello world\n", .{});
    var args_iter = std.process.args();

    _ = args_iter.skip();
    const temp_filename = args_iter.next();

    if (temp_filename == null) {
        std.debug.print("no input file given\n", .{});
        return;
    }

    // 10. determine year and day based on filename
    const filename = temp_filename.?;
    std.debug.print("filename: {?s}\n", .{filename});
    var year: u32 = 0;
    var day: u8 = 0;
    var word: [20]u8 = undefined;
    var word_counter = 0;
    var i: u32 = 0;
    while (i < filename.len) : (i += 1) {
        if (filename[i] == '.' or filename[i] == '/') {}
    }

    // 20. run function for year and day
    try aoc2019day1.answer();
}
