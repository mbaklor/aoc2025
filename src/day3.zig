const std = @import("std");

pub fn main() !void {
    const filename = "src/input_day3.txt";
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var read_buf: [1024]u8 = undefined;
    var file_reader: std.fs.File.Reader = file.readerStreaming(&read_buf);
    const reader = &file_reader.interface;

    const sum = try partOne(reader);
    std.debug.print("sum: {d}\n", .{sum});
}

test "partOne" {
    const filename = "src/example_day3.txt";
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var read_buf: [1024]u8 = undefined;
    var file_reader: std.fs.File.Reader = file.readerStreaming(&read_buf);
    const reader = &file_reader.interface;

    const sum = try partOne(reader);
    try std.testing.expectEqual(@as(u64, 357), sum);
}

fn partOne(reader: *std.Io.Reader) !u64 {
    var sum: u64 = 0;
    while (try reader.takeDelimiter('\n')) |data| {
        var max: u8 = 0;
        var sec_max: u8 = 0;
        for (data, 0..data.len) |char, i| {
            const digit = char - '0';
            if (digit > max and i < data.len - 1) {
                max = digit;
                sec_max = 0;
            } else if (digit > sec_max) {
                sec_max = digit;
            }
        }
        const full = max * 10 + sec_max;
        sum = sum + full;
        std.debug.print("{s}: ({d} {d})\n", .{ data, max, sec_max });
        // std.debug.print("\n", .{});
    }
    return sum;
}
