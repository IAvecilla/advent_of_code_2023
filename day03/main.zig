const std = @import("std");
const print = std.debug.print;

pub fn solveFirstPart(input_data: []const u8) !void {
    const allocator = std.heap.page_allocator;
    var lines = std.mem.splitAny(u8, input_data, "\n");
    var digit: []u8 = "";
    var reading_number: bool = false;
    var total: usize = 0;
    var number_start_index: usize = 0;
    var previous_line: []const u8 = "";
    var already_summed: bool = false;
    // var a: usize = 0;
    while (lines.next()) |line| {
        //var line_length = line.len;
        for (0.., line) |i, char| {
            if (std.ascii.isDigit(char)) {
                if (!reading_number)
                    number_start_index = i;
                digit = try std.fmt.allocPrint(allocator, "{s}{c}", .{ digit, char });
                reading_number = true;
            } else if (reading_number) {
                // Next character to number is a symbol
                var next_char = &[_]u8{line[i]};
                if (!std.mem.eql(u8, next_char, ".") and !already_summed) {
                    var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                    total += int_digit;
                    already_summed = true;
                }

                if (number_start_index > 0) {
                    var previous_char = &[_]u8{line[number_start_index - 1]};
                    // Previous character was a symbol
                    if (!std.mem.eql(u8, previous_char, ".") and !already_summed) {
                        var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                        total += int_digit;
                        already_summed = true;
                    }
                }

                // Character or below was a symbol
                if (number_start_index > 0) {
                    if (!std.mem.eql(u8, previous_line, "") and !already_summed) {
                        for (previous_line[number_start_index - 1 .. i + 1]) |it| {
                            if (!std.ascii.isDigit(it) and !std.mem.eql(u8, &[_]u8{it}, ".")) {
                                var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                                total += int_digit;
                                already_summed = true;
                            }
                        }
                    }
                } else {
                    if (!std.mem.eql(u8, previous_line, "") and !already_summed) {
                        for (previous_line[number_start_index .. i + 1]) |it| {
                            if (!std.ascii.isDigit(it) and !std.mem.eql(u8, &[_]u8{it}, ".")) {
                                var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                                total += int_digit;
                                already_summed = true;
                            }
                        }
                    }
                }

                // Character or below was a symbol
                var next_line = lines.peek().?;
                if (next_line.len > 0) {
                    if (number_start_index > 0) {
                        for (next_line[number_start_index - 1 .. i + 1]) |it| {
                            if (!std.ascii.isDigit(it) and !std.mem.eql(u8, &[_]u8{it}, ".") and !already_summed) {
                                var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                                total += int_digit;
                                already_summed = true;
                            }
                        }
                    } else {
                        for (next_line[number_start_index .. i + 1]) |it| {
                            if (!std.ascii.isDigit(it) and !std.mem.eql(u8, &[_]u8{it}, ".") and !already_summed) {
                                var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                                total += int_digit;
                                already_summed = true;
                            }
                        }
                    }
                }

                number_start_index = 0;
                digit = "";
                reading_number = false;
                already_summed = false;
            }
        }

        if (reading_number) {
            var previous_char = &[_]u8{line[number_start_index - 1]};
            // Previous character was a symbol
            if (!std.mem.eql(u8, previous_char, ".") and !already_summed) {
                var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                total += int_digit;
                already_summed = true;
            }

            // Character or below was a symbol
            if (!std.mem.eql(u8, previous_line, "") and !already_summed) {
                for (previous_line[number_start_index - 1 .. line.len]) |it| {
                    if (!std.ascii.isDigit(it) and !std.mem.eql(u8, &[_]u8{it}, ".")) {
                        var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                        total += int_digit;
                        already_summed = true;
                    }
                }
            }

            // Character or below was a symbol
            var next_line = lines.peek().?;
            for (next_line[number_start_index - 1 .. line.len]) |it| {
                if (!std.ascii.isDigit(it) and !std.mem.eql(u8, &[_]u8{it}, ".") and !already_summed) {
                    var int_digit: u32 = try std.fmt.parseUnsigned(u32, digit, 10);
                    total += int_digit;
                    already_summed = true;
                }
            }
        }

        digit = "";
        number_start_index = 0;
        reading_number = false;
        previous_line = line[0..];
        reading_number = false;
        already_summed = false;
    }

    print("Total: {d}\n", .{total});
}

pub fn solveSecondPart(input_data: []const u8) !void {
    const allocator = std.heap.page_allocator;
    var lines = std.mem.splitAny(u8, input_data, "\n");
    var total: usize = 0;
    var previous_line: []const u8 = "";
    var first_number_to_gear: u32 = 0;
    var second_number_to_gear: u32 = 0;
    while (lines.next()) |line| {
        for (0.., line) |i, char| {
            if (std.mem.eql(u8, &[_]u8{char}, "*")) {
                first_number_to_gear = 0;
                second_number_to_gear = 0;

                var next_char = line[i + 1];
                if (std.ascii.isDigit(next_char)) {
                    var digit: []u8 = "";
                    for (line[i + 1 ..]) |it| {
                        if (!std.ascii.isDigit(it)) {
                            break;
                        }
                        digit = try std.fmt.allocPrint(allocator, "{s}{c}", .{ digit, it });
                    }
                    first_number_to_gear = try std.fmt.parseUnsigned(u32, digit, 10);
                }

                var previous_char = line[i - 1];
                if (std.ascii.isDigit(previous_char)) {
                    var digit: []u8 = "";
                    for (1..4) |it| {
                        var actual_char = line[i - it];
                        if (!std.ascii.isDigit(actual_char)) {
                            break;
                        }
                        digit = try std.fmt.allocPrint(allocator, "{c}{s}", .{ actual_char, digit });
                    }
                    if (first_number_to_gear == 0) {
                        first_number_to_gear = try std.fmt.parseUnsigned(u32, digit, 10);
                    } else {
                        second_number_to_gear = try std.fmt.parseUnsigned(u32, digit, 10);
                    }
                }

                if (first_number_to_gear == 0 or second_number_to_gear == 0) {
                    var next_line = lines.peek().?;
                    for (0.., next_line[i - 1 .. i + 2]) |aux, it| {
                        if (std.ascii.isDigit(it)) {
                            var digit: []u8 = try std.fmt.allocPrint(allocator, "{c}", .{it});
                            for (next_line[i + aux ..]) |it2| {
                                if (!std.ascii.isDigit(it2)) {
                                    break;
                                }
                                digit = try std.fmt.allocPrint(allocator, "{s}{c}", .{ digit, it2 });
                            }
                            for (1..4) |it2| {
                                if (i + aux - it2 == 0) {
                                    break;
                                }
                                var aux2 = next_line[i - 1 + aux - it2];
                                if (!std.ascii.isDigit(aux2)) {
                                    break;
                                }
                                digit = try std.fmt.allocPrint(allocator, "{c}{s}", .{ aux2, digit });
                            }
                            if (first_number_to_gear == 0) {
                                first_number_to_gear = try std.fmt.parseUnsigned(u32, digit, 10);
                                if (next_line[i] != '.')
                                    break;
                            } else {
                                second_number_to_gear = try std.fmt.parseUnsigned(u32, digit, 10);
                                if (next_line[i] != '.')
                                    break;
                            }
                        }
                    }
                }

                if (first_number_to_gear == 0 or second_number_to_gear == 0) {
                    if (!std.mem.eql(u8, previous_line, "")) {
                        for (0.., previous_line[i - 1 .. i + 2]) |aux, it| {
                            if (std.ascii.isDigit(it)) {
                                var digit: []u8 = try std.fmt.allocPrint(allocator, "{c}", .{it});
                                for (previous_line[i + aux ..]) |it2| {
                                    if (!std.ascii.isDigit(it2)) {
                                        break;
                                    }
                                    digit = try std.fmt.allocPrint(allocator, "{s}{c}", .{ digit, it2 });
                                }
                                for (1..4) |it2| {
                                    if (i + aux - it2 == 0) {
                                        break;
                                    }
                                    var aux2 = previous_line[i - 1 + aux - it2];
                                    if (!std.ascii.isDigit(aux2)) {
                                        break;
                                    }
                                    digit = try std.fmt.allocPrint(allocator, "{c}{s}", .{ aux2, digit });
                                }
                                if (first_number_to_gear == 0) {
                                    first_number_to_gear = try std.fmt.parseUnsigned(u32, digit, 10);
                                    if (previous_line[i] != '.')
                                        break;
                                } else {
                                    second_number_to_gear = try std.fmt.parseUnsigned(u32, digit, 10);
                                    if (previous_line[i] != '.')
                                        break;
                                }
                            }
                        }
                    }
                }

                if (first_number_to_gear != 0 and second_number_to_gear != 0) {
                    total += first_number_to_gear * second_number_to_gear;
                }
            }
        }

        previous_line = line[0..];
    }

    print("Total: {d}\n", .{total});
}

pub fn main() !void {
    var input_data = @embedFile("input.txt");
    try solveFirstPart(input_data);
    try solveSecondPart(input_data);
}
