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

        var startNumberLength: usize = 0;
        var start: usize = 0;
        while (range[startNumberLength] != '-') {
            start *= 10;
            start += range[startNumberLength]-'0';
            startNumberLength += 1;
        }

        const end = parseInt(range[startNumberLength+1..]);

        var number = start;
        var numberBuffer: [20]u8 = undefined;
        var numberStr = range[0..startNumberLength];
        var length = numberStr.len;
        var numberFirstHalf = parseInt(numberStr[0..length>>1]);

        if (length&1 == 1) {
            numberFirstHalf = std.math.pow(usize, 10, length>>1);
            number = std.math.pow(usize, 10, length) + numberFirstHalf;
            length += 1;
            numberBuffer = @splat('0');
            numberStr = numberBuffer[0..length];
            numberStr[0] = '1';
        }

        @memcpy(numberStr[length>>1..length], numberStr[0..length>>1]);
        number = numberFirstHalf * std.math.pow(usize, 10, length>>1) + numberFirstHalf;

        while (number <= end) {
            if (start <= number and std.mem.eql(u8, numberStr[0..length>>1], numberStr[length>>1..length])) {
                total += number;
            }

            numberFirstHalf += 1;
            const increased = increase1(numberStr[0..length>>1]);
            if (increased == null) {
                length += 2;
                numberBuffer = @splat('0');
                numberStr = numberBuffer[0..length];
                numberStr[0] = '1';
                continue;
            }

            @memcpy(numberStr[0..length>>1], increased.?);
            @memcpy(numberStr[length>>1..length], increased.?);
            number = numberFirstHalf * std.math.pow(usize, 10, length>>1) + numberFirstHalf;
        }
    }

    std.debug.print("{d}", .{total});
}

fn parseInt(text: []const u8) usize {
    var value: usize = 0;
    for (text) |char| {
        value *= 10;
        value += char-'0';
    }
    return value;
}

fn increase1(text: []u8) ?[]u8 {
    var index = text.len;
    while (index > 0) {
        index -= 1;
        if (text[index] == '9') {
            text[index] = '0';
            continue;
        }
        text[index] += 1;
        return text;
    }
    return null;
}
