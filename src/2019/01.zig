const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
    std.debug.print("hello world\n", .{});
}
