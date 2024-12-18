// width doesn't include the new line character
pub fn getIndex(x: u32, y: u32, width: u32) u32 {
    return (y * (width + 1)) + x;
}

pub fn getIndexFromSigned(x: i32, y: i32, width: u32) u32 {
    const u_x: u32 = @intCast(x);
    const u_y: u32 = @intCast(y);
    const result = getIndex(u_x, u_y, width);
    return result;
}

// inverse of getIndex
pub fn getCoords(index: u32, width: u32) [2]u32 {
    const x = index % (width + 1);
    const y = index / (width + 1);
    const result: [2]u32 = .{ x, y };
    return result;
}

pub fn getSignedCoords(index: u32, width: u32) [2]i32 {
    const coords = getCoords(index, width);
    const x: i32 = @intCast(coords[0]);
    const y: i32 = @intCast(coords[1]);

    const result: [2]i32 = .{ x, y };
    return result;
}

pub fn getChar(x: u32, y: u32, width: u32, input: []u8) u8 {
    const index = getIndex(x, y, width);
    const character = input[index];
    return character;
}
