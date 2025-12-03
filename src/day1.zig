const std = @import("std");

fn getFileReader(filename: []const u8) !*std.Io.Reader {
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var read_buf: [1024]u8 = undefined;
    var file_reader: std.fs.File.Reader = file.readerStreaming(&read_buf);

    return &file_reader.interface;
}

pub fn main() !void {
    // const filename = "example.txt";
    const filename = "input.txt";
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var read_buf: [1024]u8 = undefined;
    var file_reader: std.fs.File.Reader = file.readerStreaming(&read_buf);
    const reader = &file_reader.interface;

    var sum: u16 = 0;
    var position: i16 = 50;

    var i: u16 = 0;
    while (try reader.takeDelimiter('\n')) |line| : (i += 1) {
        const num = try std.fmt.parseInt(i16, line[1..], 10);
        std.debug.print("{d}. ", .{i});
        switch (line[0]) {
            'L' => {
                position -= num;
                std.debug.print("-{d}: ", .{num});
            },
            'R' => {
                position += num;
                std.debug.print("+{d}: ", .{num});
            },
            else => {
                std.debug.print("how did we get here?? {s}\n", .{line});
                break;
            },
        }
        while (position < 0) {
            position += 100;
        }
        while (position > 99) {
            position -= 100;
        }
        std.debug.print("position {d}\n", .{position});
        if (position == 0) sum += 1;
    }
    std.debug.print("sum: {d}\n", .{sum});
}
