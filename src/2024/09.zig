const std = @import("std");
const utils = @import("./utils.zig");

pub fn answer(input: []u8) !void {
    std.debug.print("Day 9: Disk Fragmenter\n", .{});
    // std.debug.print("debug:\n{?s}\n", .{input});

    var disk_size: u32 = 0;
    var i: u32 = 0;
    while (i < input.len) : (i += 1) {
        const character = input[i];

        if (character == '\n') {
            break;
        }

        const str: [1]u8 = .{character};

        const number = try std.fmt.parseInt(u32, &str, 10);

        disk_size += number;
    }

    std.debug.print("debug: disk size {}\n", .{disk_size});

    const allocator = std.heap.page_allocator;

    const disk = try allocator.alloc(i16, disk_size);
    const disk_defragment = try allocator.alloc(i16, disk_size);
    defer allocator.free(disk);
    defer allocator.free(disk_defragment);

    i = 0;
    var j: u32 = 0;
    var file_id: i16 = 0;
    var is_file: bool = true;
    while (i < input.len) : (i += 1) {
        const character = input[i];

        if (character == '\n') {
            break;
        }

        const str: [1]u8 = .{character};

        const number = try std.fmt.parseInt(u32, &str, 10);

        var k: u32 = 0;
        while (k < number) : (k += 1) {
            if (is_file) {
                disk[j] = file_id;
            } else {
                disk[j] = -1;
            }

            j += 1;
        }

        if (is_file) {
            file_id += 1;
        }

        is_file = !is_file;
    }

    @memcpy(disk_defragment, disk);

    // std.debug.print("debug: before {any}\n", .{disk});

    var write_head: u32 = 0;
    var read_head: u32 = @intCast(disk.len);
    read_head -= 1;
    while (write_head < read_head) {
        // find next empty block
        while (write_head < read_head) : (write_head += 1) {
            if (disk[write_head] < 0) {
                break;
            }
        }

        // find next data block
        while (read_head > write_head) : (read_head -= 1) {
            if (disk[read_head] >= 0) {
                break;
            }
        }

        // move data block
        disk[write_head] = disk[read_head];
        disk[read_head] = -1;

        write_head += 1;
        read_head -= 1;
    }

    var current_file_id: i16 = file_id - 1;
    var file_start: u32 = 0;
    var file_size: u32 = 0;
    var space_start: u32 = 0;
    var space_size: u32 = 0;
    while (current_file_id >= 0) : (current_file_id -= 1) {
        file_start = 0;
        file_size = 0;
        i = 0;
        while (i < disk_size) : (i += 1) {
            if (disk_defragment[i] == current_file_id) {
                if (file_size == 0) {
                    file_start = i;
                }
                file_size += 1;
            }
        }

        space_start = 0;
        space_size = 0;
        i = 0;
        while (i < disk_size) : (i += 1) {
            if (disk_defragment[i] == -1) {
                // the block is empty
                if (space_size == 0) {
                    space_start = i;
                }
                space_size += 1;

                if (space_size >= file_size and file_start > space_start) {
                    // move the file.
                    j = 0;

                    while (j < file_size) : (j += 1) {
                        write_head = space_start + j;
                        disk_defragment[write_head] = current_file_id;

                        write_head = file_start + j;
                        disk_defragment[write_head] = -1;
                    }

                    break;
                }
            } else {
                // the block has data
                space_size = 0;
            }
        }
    }

    // std.debug.print("debug: after {any}\n", .{disk});

    // calculate checksum
    var checksum: u64 = 0;
    i = 0;
    while (i < disk.len) : (i += 1) {
        if (disk[i] < 0) {
            break;
        }
        const datum: u64 = @intCast(disk[i]);
        const i_64: u64 = @intCast(i);
        const check = datum * i_64;
        checksum += check;
    }

    // std.debug.print("debug: after {any}\n", .{disk_defragment});

    var checksum_2: u64 = 0;
    i = 0;
    while (i < disk_defragment.len) : (i += 1) {
        if (disk_defragment[i] < 0) {
            continue;
        }
        const datum: u64 = @intCast(disk_defragment[i]);
        const i_64: u64 = @intCast(i);
        const check = datum * i_64;
        checksum_2 += check;
    }

    std.debug.print("Part 1: {}\n", .{checksum});
    std.debug.print("Part 2: {}\n", .{checksum_2});
}
