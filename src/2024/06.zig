const std = @import("std");

const directions: [4][2]i32 = .{ .{ 0, -1 }, .{ 1, 0 }, .{ 0, 1 }, .{ -1, 0 } };

// width doesn't include the new line
fn getIndex(x: u32, y: u32, width: u32) u32 {
    return (y * (width + 1)) + x;
}

fn getCoords(index: u32, width: u32) [2]u32 {
    const x = index % (width + 1);
    const y = index / (width + 1);
    const result: [2]u32 = .{ x, y };
    return result;
}

fn getChar(x: u32, y: u32, width: u32, input: []u8) u8 {
    const index = getIndex(x, y, width);
    const character = input[index];
    return character;
}

pub fn answer(input: []u8) !void {
    std.debug.print("Day 6: Guard Gallivant\n", .{});
    std.debug.print("debug:\n{?s}\n", .{input});

    var width: u32 = 0;
    var starting_position: [2]u32 = undefined;
    var current_position: [2]u32 = undefined;
    var starting_position_found: bool = false;

    var i: u32 = 0;

    while (i < input.len) : (i += 1) {
        const character = input[i];

        if (width == 0 and character == '\n') {
            width = i;
        }

        if (character == '^') {
            if (width == 0) {
                starting_position[0] = i;
                starting_position[1] = 0;
            } else {
                const temp = getCoords(i, width);
                starting_position[0] = temp[0];
                starting_position[1] = temp[1];
            }

            std.debug.print("debug: starting position: {any}\n", .{starting_position});

            starting_position_found = true;
        }

        if (starting_position_found and width > 0) {
            break;
        }
    }

    current_position[0] = starting_position[0];
    current_position[1] = starting_position[1];
    const starting_index = getIndex(starting_position[0], starting_position[1], width);

    const height = (input.len / width) - 1;

    var next_position: [2]u32 = undefined;
    var current_direction: u32 = 0;
    var step_counter: u32 = 0;
    while (true) {
        const signed_curr_x: i32 = @intCast(current_position[0]);
        const signed_next_x = signed_curr_x + directions[current_direction][0];
        if (signed_next_x < 0 or signed_next_x >= width) {
            break;
        }

        next_position[0] = @intCast(signed_next_x);

        const signed_curr_y: i32 = @intCast(current_position[1]);
        const signed_next_y = signed_curr_y + directions[current_direction][1];
        if (signed_next_y < 0 or signed_next_y >= height) {
            break;
        }

        next_position[1] = @intCast(signed_next_y);

        // std.debug.print("debug: current position: {any}\n", .{current_position});
        // std.debug.print("debug: next position: {any}\n", .{next_position});

        const next_char = getChar(next_position[0], next_position[1], width, input);

        if (next_char == '#') {
            current_direction = (current_direction + 1) % 4;
            // std.debug.print("debug: {}\n{?s}\n", .{ step_counter, input });
        } else {
            current_position[0] = next_position[0];
            current_position[1] = next_position[1];
            const current_index = getIndex(current_position[0], current_position[1], width);
            if (input[current_index] != '^') {
                input[current_index] = 'X';
            }
            step_counter += 1;
            // std.time.sleep(100_000_000);
        }
        // std.debug.print("debug: {}\n{?s}\n", .{ step_counter, input });

        if (step_counter > 100000) {
            break;
        }
    }

    i = 0;
    var distinct_positions: u32 = 0;
    while (i < input.len) : (i += 1) {
        const character = input[i];
        if (character == 'X' or character == '^') {
            distinct_positions += 1;
        }
    }

    std.debug.print("debug: {}\n{?s}\n", .{ step_counter, input });

    // var obstruction_candidates: [2000][2]u32 = undefined;
    var obstruction_candidate_count: u32 = 0;
    i = 0;
    var repeat: u32 = 0;
    var fate_changed: bool = false;
    while (i < input.len) : (i += 1) {
        if (input[i] == '#' or i == starting_index) {
            continue;
        }

        var j: u32 = 0;
        // reset lab. starting position is already stored
        while (j < input.len) : (j += 1) {
            if (input[j] != '#') {
                input[j] = '.';
            }

            if (j == i and input[j] == '.') {
                input[j] = 'O';
            }
        }

        std.debug.print("debug: trying {}/{}\n", .{ i, input.len });
        current_position[0] = starting_position[0];
        current_position[1] = starting_position[1];
        current_direction = 0;
        repeat = 0;
        step_counter = 0;
        fate_changed = false;
        while (true) {
            const signed_curr_x: i32 = @intCast(current_position[0]);
            const signed_next_x = signed_curr_x + directions[current_direction][0];
            if (signed_next_x < 0 or signed_next_x >= width) {
                break;
            }

            next_position[0] = @intCast(signed_next_x);

            const signed_curr_y: i32 = @intCast(current_position[1]);
            const signed_next_y = signed_curr_y + directions[current_direction][1];
            if (signed_next_y < 0 or signed_next_y >= height) {
                break;
            }

            next_position[1] = @intCast(signed_next_y);

            // std.debug.print("debug: current position: {any}\n", .{current_position});
            // std.debug.print("debug: next position: {any}\n", .{next_position});

            const current_index = getIndex(current_position[0], current_position[1], width);
            const next_index = getIndex(next_position[0], next_position[1], width);
            const next_char = input[next_index];

            // you bump into an obstruction
            if (next_char == '#' or next_char == 'O') {
                const current_direction_mask = std.math.pow(u32, 2, current_direction);

                // fate has been changed and you are at an obstruction
                if (fate_changed) {
                    // mark which direction you were going when you hit this obstacle
                    const current_char = input[current_index];
                    if (current_char != '.' and current_char != 'X' and current_char != '^') {
                        // it should be a mark
                        const number_str: [1]u8 = .{current_char};
                        const current_mark = try std.fmt.parseInt(u32, &number_str, 16);
                        const a = current_mark & current_direction_mask;
                        // std.debug.print("{} = {} & {}\n", .{ a, current_mark, current_direction_mask });
                        if (a == current_direction_mask) {
                            // it's the same mark as the direction we are travelling. this means we have found a loop
                            repeat += 1;
                            if (repeat > 3) {
                                obstruction_candidate_count += 1;
                                break;
                            }
                        } else {
                            // it's in a different direction. we should update it so it includes our current direction
                            const new_mark = current_mark + current_direction_mask;

                            var buf: [1]u8 = undefined;
                            const str = try std.fmt.bufPrint(&buf, "{x}", .{new_mark});
                            input[current_index] = str[0];
                        }
                    }

                    if (current_char == '.' or current_char == 'X' or current_char == '^') {
                        // we haven't marked this square yet

                        var buf: [1]u8 = undefined;
                        const str = try std.fmt.bufPrint(&buf, "{}", .{current_direction_mask});
                        // std.debug.print("Current Direction: {c}\n", .{str[0]});
                        input[current_index] = str[0];
                    }
                }

                if (next_char == 'O') {
                    fate_changed = true;
                }

                current_direction = (current_direction + 1) % 4;
            } else {
                current_position[0] = next_position[0];
                current_position[1] = next_position[1];
                if (fate_changed) {
                    if (input[next_index] == '.') {
                        input[next_index] = 'X';
                    }
                }

                // only check if the guard's fate has changed and the guard took a step
                if (fate_changed) {}

                step_counter += 1;
                // std.time.sleep(100_000_000);
            }
            // std.debug.print("debug: {}\n{?s}\n", .{ step_counter, input });

            if (step_counter > 100000000) {
                std.debug.print("debug: too many steps {}\n{?s}\n", .{ i, input });
                std.debug.print("too many steps\n", .{});
                break;
            }
        }
    }

    std.debug.print("Part 1: {}\n", .{distinct_positions});
    std.debug.print("Part 2: {}\n", .{obstruction_candidate_count});
}
