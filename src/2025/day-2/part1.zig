const std = @import("std");

pub fn main() !void {
    const filename: []const u8 = "input.txt";
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buffer: [8096]u8 = undefined;
    var reader = file.reader(&buffer);

    var total: usize = 0;

    while (try reader.interface.takeDelimiter(',')) |rawRange| {
        var range = rawRange[0..];
        const endChar = rawRange[range.len-1];
        if (endChar < '0' or endChar > '9') {
            range = range[0..range.len-1];
        }

        var startNumLength: usize = 0;
        var start: usize = 0;
        while (range[startNumLength] != '-') {
            start *= 10;
            start += range[startNumLength]-'0';
            startNumLength += 1;
        }
        var end: usize = 0;
        for (range[startNumLength+1..]) |char| {
            end *= 10;
            end += char-'0';
        }

        for (start..end+1) |number| {
            var length: usize = 1;
            var part1: usize = number;
            var part2: usize = 0;
            while (part1 != 0) {
                const value = @rem(part1, 10);
                part1 = @divFloor(part1, 10);
                part2 += value * std.math.pow(usize, 10, length-1);
                if (part1 == part2 and value != 0) {
                    total += number;
                }
               length += 1;
            }
        }
    }

    std.debug.print("{d}", .{total});
}
