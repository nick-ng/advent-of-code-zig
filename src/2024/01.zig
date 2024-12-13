const std = @import("std");

pub fn answer(input: []u8) !void {
    std.debug.print("Day 1: Historian Hysteria\n", .{});

    var left_word_counter: u32 = 0;
    var left_word_buffer: [20]u8 = undefined;
    var left_numbers_buffer: [1000]i32 = undefined;
    var left_numbers_counter: u32 = 0;
    var right_word_counter: u32 = 0;
    var right_word_buffer: [20]u8 = undefined;
    var right_numbers_buffer: [1000]i32 = undefined;
    // probably don't need separate left and right counters.
    var right_numbers_counter: u32 = 0;
    var current_word: u8 = 0; // 0 = left, 1 = right
    var i: u32 = 0;
    while (i < input.len) : (i += 1) {
        const character = input[i];
        // the input data doesn't come with a trailing \n but my editor is set up to add one when you save the file.
        if (character == '\n') {
            const left_word = left_word_buffer[0..left_word_counter];
            left_word_counter = 0;
            const left_number = try std.fmt.parseInt(i32, left_word, 10);
            left_numbers_buffer[left_numbers_counter] = left_number;
            left_numbers_counter += 1;

            const right_word = right_word_buffer[0..right_word_counter];
            right_word_counter = 0;
            const right_number = try std.fmt.parseInt(i32, right_word, 10);
            right_numbers_buffer[right_numbers_counter] = right_number;
            right_numbers_counter += 1;

            current_word = 0; // left
            continue;
        }

        // this will get set a number of times because there are multiple spaces between the columns. slightly inefficient but it will have to do for now.
        if (character == ' ') {
            current_word = 1; // right
            continue;
        }

        if (current_word == 0) {
            left_word_buffer[left_word_counter] = character;
            left_word_counter += 1;
            continue;
        } else {
            right_word_buffer[right_word_counter] = character;
            right_word_counter += 1;
            continue;
        }
    }

    const left_numbers = left_numbers_buffer[0..left_numbers_counter];
    const right_numbers = right_numbers_buffer[0..right_numbers_counter];

    std.mem.sort(i32, left_numbers, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, right_numbers, {}, comptime std.sort.asc(i32));

    var total_distance: i32 = 0;
    i = 0;
    while (i < left_numbers.len) : (i += 1) {
        var difference = left_numbers[i] - right_numbers[i];
        if (difference < 0) {
            difference = 0 - difference;
        }

        total_distance += difference;
    }

    std.debug.print("Part 1 - Distance: {}\n", .{total_distance});

    // part 2
    var total_similarity: i32 = 0;
    var current_number: i32 = 0;
    var previous_number: i32 = 0;
    var current_count: i32 = 0;
    var previous_count: i32 = 0;
    i = 0;
    var j: u32 = 0;
    while (i < left_numbers.len) : (i += 1) {
        current_number = left_numbers[i];
        if (current_number == previous_number) {
            // @todo(nick-ng): if the current number is the same as the previous number, then its similarity score will be the same as the previous.
            total_similarity += (previous_count * current_number);
            continue;
        }

        current_count = 0;
        // don't re-initialise j. since both sets of numbers are sorted, we don't need to check previously checked numbers.
        while (j < right_numbers.len) {
            if (right_numbers[j] > current_number) {
                break;
            }
            if (right_numbers[j] == current_number) {
                current_count += 1;
            }

            // increment j manually because we don't want to skip numbers.
            j += 1;
        }

        total_similarity += (current_count * current_number);
        previous_count = current_count;
        previous_number = current_number;
    }

    std.debug.print("Part 2 - Similarity: {}\n", .{total_similarity});
}
