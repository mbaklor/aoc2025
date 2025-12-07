const std = @import("std");

fn getFileReader(filename: []const u8) !*std.Io.Reader {
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var read_buf: [1024]u8 = undefined;
    var file_reader: std.fs.File.Reader = file.readerStreaming(&read_buf);

    return &file_reader.interface;
}

pub fn main() !void {
    // const filename = "src/example_day2.txt";
    const filename = "src/input_day2.txt";
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var read_buf: [1024]u8 = undefined;
    var file_reader: std.fs.File.Reader = file.readerStreaming(&read_buf);
    const reader = &file_reader.interface;

    const sum = try partOne(reader);
    std.debug.print("sum: {d}\n", .{sum});
}

fn partOne(reader: *std.Io.Reader) !u64 {
    var digits = [_]u8{0} ** 64;
    var sum: u64 = 0;
    while (try reader.takeDelimiter(',')) |range| {
        var rangeStart: u64 = 0;
        var rangeEnd: u64 = 0;
        var rangeSides = std.mem.splitAny(u8, range, "-");
        {
            var i: usize = 0;
            while (rangeSides.next()) |side| : (i += 1) {
                switch (i) {
                    0 => {
                        rangeStart = try std.fmt.parseInt(u64, std.mem.trim(u8, side, "\n"), 10);
                    },
                    1 => {
                        rangeEnd = try std.fmt.parseInt(u64, std.mem.trim(u8, side, "\n"), 10);
                    },
                    else => break,
                }
            }
        }
        std.debug.print("range: {d}-{d}\n", .{ rangeStart, rangeEnd });
        for (rangeStart..rangeEnd + 1) |num| {
            var num_rem: u64 = @intCast(num);
            const num_float: f64 = @floatFromInt(num);
            const len: u64 = @intFromFloat(@floor(@log10(num_float)) + 1);
            for (0..len) |i| {
                digits[len - i - 1] = @intCast(@mod(num_rem, 10));
                num_rem = @divFloor(num_rem, 10);
            }
            const full_digits: []u8 = digits[0..len];
            const is_repeat = if (std.mem.eql(u8, full_digits[0 .. len / 2], full_digits[len / 2 ..])) true else false;
            if (is_repeat) {
                sum += @intCast(num);
            }
            std.debug.print("{d}: ({any})\n", .{ num, is_repeat });
        }
        // std.debug.print("\n", .{});
    }
    return sum;
}

fn partTwo(reader: *std.Io.Reader) !u64 {
    var sum: u64 = 0;
    return sum;
}
