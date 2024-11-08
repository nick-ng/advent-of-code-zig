const std = @import("std");
const utils = @import("../utils.zig");

pub fn answer() !void {
    const allocator = std.heap.page_allocator;
    const file_content = try utils.readFile("./data/2019-01.txt", allocator);
    defer allocator.free(file_content);

    var word_counter: u32 = 0;
    var word_buffer: [20]u8 = undefined;
    var number_counter: u32 = 0;
    var numbers_array: [1000]i32 = undefined;
    var i: u32 = 0;
    while (i < file_content.len) : (i += 1) {
        if (file_content[i] == '\n') {
            // std.debug.print("\n{s}, new line!\n", .{word_buffer[0..word_counter]});

            const word = word_buffer[0..word_counter];
            word_counter = 0;
            const number = try std.fmt.parseInt(i32, word, 10);
            numbers_array[number_counter] = number;
            number_counter += 1;

            continue;
        }

        // std.debug.print("{c}", .{file_content[i]});
        word_buffer[word_counter] = file_content[i];
        word_counter += 1;
    }

    const numbers = numbers_array[0..number_counter];
    // std.debug.print("{any}\n", .{numbers});

    // part 1
    i = 0;
    var fuel_requirement_part_1: i32 = 0;
    while (i < numbers.len) : (i += 1) {
        const temp = @divFloor(numbers[i], 3) - 2;
        fuel_requirement_part_1 += temp;
    }

    std.debug.print("Fuel requirement part 1: {}\n", .{fuel_requirement_part_1});

    // part 2
    i = 0;
    var fuel_requirement_part_2: i32 = 0;
    while (i < numbers.len) : (i += 1) {
        const temp = calculateFuel(numbers[i]);
        fuel_requirement_part_2 += temp;
    }

    std.debug.print("Fuel requirement part 2: {}\n", .{fuel_requirement_part_2});
}

fn calculateFuel(mass: i32) i32 {
    const fuel = @divFloor(mass, 3) - 2;
    if (fuel < 0) {
        return 0;
    }

    return fuel + calculateFuel(fuel);
}
