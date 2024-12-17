const std = @import("std");

// I read the question and I though "They're definitely going to ask you to sort the pages in part 2" and if you can sort the pages, you get part 1 for "free". So I was trying to give Zig's sort function a custome `lessThan()` but Zig needs the function to be known at complie time. So I just did part 1 without sorting and then of course, part 2 needs you to sort the pages. I only knew how to write bubble sort from memory so I just used that.

// returns true if the rule exists. if the rule doesn't exist, assume the inverse rule exists
fn getRule(rules: [2000][2]u32, rules_count: u32, a: u32, b: u32) bool {
    var i: u32 = 0;
    while (i < rules_count) : (i += 1) {
        const rule = rules[i];

        if (rule[0] == a and rule[1] == b) {
            return true;
        }
    }

    return false;
}

pub fn answer(input: []u8) !void {
    std.debug.print("Day 5: Print Queue\n", .{});
    // std.debug.print("{?s}\n", .{input});

    var i: u32 = 0;
    var prev_char: u8 = 0;
    var character: u8 = 0;
    var rules: [2000][2]u32 = undefined;
    var rules_count: u32 = 0;
    var number_buffer: [20]u8 = undefined;
    var number_index: u32 = 0;
    var rule_1: u32 = 0;
    var rule_2: u32 = 0;
    while (i < input.len) : (i += 1) {
        character = input[i];
        if (i > 0) {
            prev_char = input[i - 1];
        }

        if (character == '|') {
            const number_string = number_buffer[0..number_index];
            rule_1 = try std.fmt.parseInt(u32, number_string, 10);
            number_index = 0;

            continue;
        }

        if (character == '\n') {
            if (prev_char == '\n') {
                break;
            }

            const number_string = number_buffer[0..number_index];
            rule_2 = try std.fmt.parseInt(u32, number_string, 10);
            number_index = 0;

            rules[rules_count] = .{ rule_1, rule_2 };
            rules_count += 1;

            continue;
        }

        number_buffer[number_index] = character;
        number_index += 1;
    }

    // std.debug.print("rules: {any}\n", .{rules[0..rules_count]});

    var page_buffer: [32]u32 = undefined;
    var page_index: u32 = 0;
    number_index = 0;

    var total_of_middle: u32 = 0;
    var total_of_middle_incorrect: u32 = 0;
    // don't reset i. we are at the page numbers
    while (i < input.len) : (i += 1) {
        // std.debug.print("{?c}\n", .{input[i]});
        character = input[i];

        if (character == ',' or character == '\n') {
            if (number_index > 0) {
                // std.debug.print("{?s} {}\n", .{ number_buffer[0..number_index], number_index });
                const number_string = number_buffer[0..number_index];
                const number = try std.fmt.parseInt(u32, number_string, 10);
                page_buffer[page_index] = number;
                page_index += 1;
                number_index = 0;
            }
        } else {
            number_buffer[number_index] = character;
            number_index += 1;
        }

        if (character == '\n') {
            const page = page_buffer[0..page_index];
            // const page_buffer_copy = page_buffer[0..32].*;
            // const page_copy = page_buffer_copy[0..page_index];

            if (page_index == 0) {
                // std.debug.print("page: {any} page_index: {}", .{ page, page_index });
                continue;
            }

            var j: u32 = 0;
            var is_in_order: bool = true;
            while (j < (page_index - 1)) : (j += 1) {
                if (!is_in_order) {
                    break;
                }
                var k: u32 = j + 1;
                while (k < page_index) : (k += 1) {
                    const is_before = getRule(rules, rules_count, page[j], page[k]);

                    // std.debug.print("{} {} {}\n", .{ page[j], page[k], is_before });

                    if (!is_before) {
                        is_in_order = false;

                        break;
                    }
                }
            }

            const middle_index = (page_index / 2);
            if (is_in_order) {
                const middle_value = page[middle_index];
                // std.debug.print("{any} is in order {}\n", .{ page, middle_value });
                total_of_middle += middle_value;
            } else {
                // std.debug.print("{any} is not in order\n", .{page});

                // bubble sort lol
                var is_sorted: bool = false;
                while (!is_sorted) {
                    is_sorted = true;
                    var k: u32 = 1;
                    while (k < page_index) : (k += 1) {
                        j = k - 1;
                        const is_before = getRule(rules, rules_count, page[j], page[k]);

                        if (!is_before) {
                            is_sorted = false;
                            // swap
                            const buffer = page[j];
                            page[j] = page[k];
                            page[k] = buffer;
                        }
                    }
                }

                const middle_value = page[middle_index];
                total_of_middle_incorrect += middle_value;
                // std.debug.print("{any} is sorted {}\n", .{ page, middle_value });
            }

            page_index = 0;
        }
    }

    std.debug.print("Part 1: {}\n", .{total_of_middle});
    std.debug.print("Part 2: {}\n", .{total_of_middle_incorrect});
}
