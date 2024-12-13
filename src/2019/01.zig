const std = @import("std");
const utils = @import("../utils.zig");

pub fn answer(input: []u8) !void {
    std.debug.print("Fuel requirements\n", .{});

    var word_counter: u32 = 0;
    var word_buffer: [20]u8 = undefined;
    var number_counter: u32 = 0;
    var numbers_array: [1000]i32 = undefined;
    var i: u32 = 0;
    while (i < input.len) : (i += 1) {
        if (input[i] == '\n') {
            const word = word_buffer[0..word_counter];
            word_counter = 0;
            const number = try std.fmt.parseInt(i32, word, 10);
            numbers_array[number_counter] = number;
            number_counter += 1;

            continue;
        }

        word_buffer[word_counter] = input[i];
        word_counter += 1;
    }

    const numbers = numbers_array[0..number_counter];

    // part 1
    i = 0;
    var fuel_requirement_part_1: i32 = 0;
    while (i < numbers.len) : (i += 1) {
        const temp = @divFloor(numbers[i], 3) - 2;
        fuel_requirement_part_1 += temp;
    }

    std.debug.print("Part 1: {}\n", .{fuel_requirement_part_1});

    // part 2
    i = 0;
    var fuel_requirement_part_2: i32 = 0;
    while (i < numbers.len) : (i += 1) {
        const temp = calculateFuel(numbers[i]);
        fuel_requirement_part_2 += temp;
    }

    std.debug.print("Part 2: {}\n", .{fuel_requirement_part_2});
}

fn calculateFuel(mass: i32) i32 {
    const fuel = @divFloor(mass, 3) - 2;
    if (fuel < 0) {
        return 0;
    }

    return fuel + calculateFuel(fuel);
}
