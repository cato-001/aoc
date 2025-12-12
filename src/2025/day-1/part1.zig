const std = @import("std");

pub fn main() !void {
    const filename: []const u8 = "input.txt";
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buffer: [8096]u8 = undefined;
    var reader = file.reader(&buffer);

    var dial: isize = 50;
    var isZero: usize = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        var current: isize = 0;
        for (line[1..]) |char| {
            current *= 10;
            current += char - '0';
        }
        if (line[0] == 'L') {
            current *= -1;
        }
        dial = @mod(dial + current, 100);
        if (dial == 0) {
            isZero += 1;
        }
    }

    std.debug.print("{d}", .{isZero});
}
