const std = @import("std");

pub fn solveFirstPart(input_data: []const u8) !void {
    const allocator = std.heap.page_allocator;
    var lines = std.mem.split(u8, input_data, "\n");
    var final_numbers = std.ArrayList([]u8).init(allocator);
    defer final_numbers.deinit();
    var total: usize = 0;
    while (lines.next()) |line| {
        for (line) |char| {
            if (std.ascii.isDigit(char)) {
                const new = try std.fmt.allocPrint(allocator, "{c}", .{char});
                try final_numbers.append(new);
            }
        }
        if (final_numbers.items.len > 0) {
            const final_number = try std.fmt.allocPrint(allocator, "{s}{s}", .{ final_numbers.items[0], final_numbers.getLast() });
            const final_number_int = try std.fmt.parseUnsigned(u8, final_number, 10);
            total += final_number_int;
        }
        final_numbers.clearAndFree();
    }

    std.log.info("Result of first part is: {d}", .{total});
}

pub fn solveSecondPart(input_data: []const u8) !void {
    const allocator = std.heap.page_allocator;
    var lines = std.mem.split(u8, input_data, "\n");
    var my_hash_map = std.StringHashMap([]u8).init(allocator);
    var final_numbers = std.ArrayList([]u8).init(allocator);
    defer final_numbers.deinit();
    const numbers_name = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    for (1.., numbers_name) |i, elem| {
        const num_string = try std.fmt.allocPrint(allocator, "{d}", .{i});
        _ = try my_hash_map.put(elem, num_string);
    }
    var total: usize = 0;
    while (lines.next()) |line| {
        for (line, 0..) |char, i| {
            if (std.ascii.isDigit(char)) {
                const new = try std.fmt.allocPrint(allocator, "{c}", .{char});
                try final_numbers.append(new);
            }
            for (numbers_name) |elem| {
                if (i + elem.len > line.len) {
                    continue;
                }
                if (std.mem.eql(u8, line[i .. i + elem.len], elem)) {
                    const found_element = my_hash_map.get(elem);
                    if (found_element) |v| {
                        try final_numbers.append(v);
                    }
                }
            }
        }
        if (final_numbers.items.len > 0) {
            const final_number = try std.fmt.allocPrint(allocator, "{s}{s}", .{ final_numbers.items[0], final_numbers.getLast() });
            const final_number_int = try std.fmt.parseUnsigned(u8, final_number, 10);
            total += final_number_int;
        }
        final_numbers.clearAndFree();
    }

    std.log.info("Result of first part is: {d}", .{total});
}

pub fn main() !void {
    var input_data = @embedFile("input.txt");
    try solveFirstPart(input_data);
    try solveSecondPart(input_data);
}
