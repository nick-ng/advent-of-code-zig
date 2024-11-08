const std = @import("std");

pub fn readFile(filename: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const stat = try file.stat();
    const file_size = stat.size;

    const file_content_buffer = try allocator.alloc(u8, file_size);
    const bytes_read = try file.readAll(file_content_buffer);
    _ = bytes_read;

    return file_content_buffer;
}
