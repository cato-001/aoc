const std = @import("std");

pub fn main() !void {
    const filename: []const u8 = "input.txt";
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buffer: [8096]u8 = undefined;
    var reader = file.reader(&buffer);

    var timelines: usize = 1;
    var state = std.mem.zeroes([300]usize);

    if (try reader.interface.takeDelimiter('\n')) |firstLine| {
        for (firstLine, 0..(firstLine.len)) |char, index| {
            if (char == 'S') {
                state[index] = 1;
            }
        }
    }

    while (try reader.interface.takeDelimiter('\n')) |line| {
        for (0..(line.len)) |index| {
            if (state[index] == 0) {
                continue;
            }
            if (line[index] != '^') {
                continue;
            }
            timelines += state[index];
            state[index-1] += state[index];
            state[index+1] += state[index];
            state[index] = 0;
        }
    }

    std.debug.print("{d}", .{timelines});
}
