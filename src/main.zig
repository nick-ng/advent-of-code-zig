const std = @import("std");
const aoc2019day1 = @import("./2019/01.zig");

pub fn main() !void {
    std.debug.print("hello world\n", .{});
    var args_iter = std.process.args();

    _ = args_iter.skip();
    const file_name = args_iter.next();

    if (file_name == null) {
        std.debug.print("no input file given\n", .{});
        return;
    }

    // 10. determine year and day based on filename

    // 20. run function for year and day
    try aoc2019day1.answer();
}
