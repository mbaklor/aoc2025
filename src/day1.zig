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

    const sum = try partTwo(reader);
    std.debug.print("sum: {d}\n", .{sum});
}

fn partOne(reader: *std.Io.Reader) !u16 {
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
        position = @mod(position, 100);
        std.debug.print("position {d}\n", .{position});
        if (position == 0) sum += 1;
    }
    return sum;
}

fn partTwo(reader: *std.Io.Reader) !u16 {
    var sum: u16 = 0;
    var position: i16 = 50;

    var i: u16 = 1;
    std.debug.print("0.\tstart:\tposition 50\tsum 0\n", .{});
    while (try reader.takeDelimiter('\n')) |line| : (i += 1) {
        if (line.len == 0) break;
        const num = try std.fmt.parseInt(i16, line[1..], 10);
        // const startingPosition = position;
        std.debug.print("{d}.\t {d} ", .{ i, position });
        var div: u16 = 0;
        switch (line[0]) {
            'L' => {
                if (position == 0) position = 100;
                position -= num;
                if (@mod(position, 100) == 0 and position != 0) {
                    div += 1;
                }
                std.debug.print("- {d} = ", .{num});
            },
            'R' => {
                position += num;
                std.debug.print("+ {d} = ", .{num});
            },
            else => {
                std.debug.print("how did we get here?? {s}\n", .{line});
                break;
            },
        }
        std.debug.print("{d}\t", .{position});
        div += @abs(@divFloor(position, 100));
        if (position == 0) div += 1;
        // if (startingPosition == 0 and line[0] == 'L' and div != 0) {
        //     div -= 1;
        // }
        position = @mod(position, 100);
        sum += @intCast(div);
        std.debug.print("new position {d}\tdiv {d}\tsum {d}\n", .{ position, div, sum });
    }

    return sum;
}
