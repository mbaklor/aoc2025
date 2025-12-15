const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const filename = "src/input_day4.txt";
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var read_buf: [1024]u8 = undefined;
    var file_reader: std.fs.File.Reader = file.readerStreaming(&read_buf);
    const reader = &file_reader.interface;

    const sum = try partOne(allocator, reader);
    std.debug.print("sum: {d}\n", .{sum});
}

test "partOne" {
    const filename = "src/example_day4.txt";
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var read_buf: [1024]u8 = undefined;
    var file_reader: std.fs.File.Reader = file.readerStreaming(&read_buf);
    const reader = &file_reader.interface;

    const sum = try partOne(std.testing.allocator, reader);
    try std.testing.expectEqual(@as(u64, 13), sum);
}

fn partOne(allocator: std.mem.Allocator, reader: *std.Io.Reader) !u64 {
    var sum: u64 = 0;
    var prev_line: []u8 = undefined;
    var curr_line: []u8 = undefined;
    var next_line: []u8 = undefined;
    var line_num: usize = 0;
    while (try reader.takeDelimiter('\n')) |data| : (line_num = line_num + 1) {
        curr_line = try allocator.dupe(u8, data);
        next_line = try allocator.dupe(u8, reader.peekDelimiterExclusive('\n') catch "");
        for (0..curr_line.len) |i| {
            var count: u8 = 0;
            if (curr_line[i] == '.') continue;
            const first_col = i == 0;
            const last_col = i == curr_line.len - 1;

            if (line_num > 0) {
                if (!first_col) {
                    if (prev_line[i - 1] != '.') count = count + 1;
                }
                if (prev_line[i] != '.') count = count + 1;
                if (!last_col) {
                    if (prev_line[i + 1] != '.') count = count + 1;
                }
            }

            if (!first_col) {
                if (curr_line[i - 1] != '.') count = count + 1;
            }

            if (!last_col) {
                if (curr_line[i + 1] != '.') count = count + 1;
            }

            if (!std.mem.eql(u8, next_line, "")) {
                if (!first_col) {
                    if (next_line[i - 1] != '.') count = count + 1;
                }
                if (next_line[i] != '.') count = count + 1;
                if (!last_col) {
                    if (next_line[i + 1] != '.') count = count + 1;
                }
            }

            if (count < 4) {
                sum = sum + 1;
                // curr_line[i] = 'x';
            }
        }
        std.debug.print("{s}\n", .{curr_line});
        if (line_num > 0) {
            allocator.free(prev_line);
        }
        if (next_line.len != 1) {
            allocator.free(next_line);
        }
        prev_line = curr_line;
    }
    allocator.free(curr_line);
    return sum;
}
