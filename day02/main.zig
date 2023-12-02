const std = @import("std");

pub fn solveFirstPart(input_data: []const u8) !void {
    const red_available = 12;
    const green_available = 13;
    const blue_available = 14;
    var is_possible = true;
    //const allocator = std.heap.page_allocator;
    //var my_hash_map = std.StringHashMap(u8).init(allocator);
    var total_possible_ids: usize = 0;
    var lines = std.mem.splitAny(u8, input_data, "\n");
    while (lines.next()) |line| {
        var game_separation = std.mem.splitAny(u8, line, ":");
        var game_id = game_separation.first();
        if (game_id.len < 5) {
            continue;
        }
        var game_number = game_id[5..];
        var int_game_number = try std.fmt.parseUnsigned(u8, game_number, 10);

        var game_info = game_separation.next().?;
        var game_sets = std.mem.splitAny(u8, game_info, ";");
        while (game_sets.next()) |set| {
            var cubes_per_set = std.mem.splitAny(u8, set, ",");
            while (cubes_per_set.next()) |cube_per_set| {
                var cube_per_set_trimmed = std.mem.trim(u8, cube_per_set, " ");
                var amount_and_color = std.mem.splitAny(u8, cube_per_set_trimmed, " ");
                var amount = amount_and_color.first();

                var int_amount = try std.fmt.parseUnsigned(u8, amount, 10);
                var color = amount_and_color.next().?;
                if (std.mem.eql(u8, color, "red") and int_amount > red_available) {
                    is_possible = false;
                } else if (std.mem.eql(u8, color, "green") and int_amount > green_available) {
                    is_possible = false;
                } else if (std.mem.eql(u8, color, "blue") and int_amount > blue_available) {
                    is_possible = false;
                }
                // var actual_amount = try my_hash_map.getOrPut(color);
                // if (!actual_amount.found_existing) {
                //     actual_amount.value_ptr.* = int_amount;
                // } else {
                //     try my_hash_map.put(color, actual_amount.value_ptr.* + int_amount);
                // }
            }
        }
        if (is_possible) {
            total_possible_ids += int_game_number;
        }
        is_possible = true;
        // var red = my_hash_map.get("red").?;
        // var green = my_hash_map.get("green").?;
        // var blue = my_hash_map.get("blue").?;
        // if (red >= red_available and green >= green_available and blue >= blue_available) {
        //     total_possible_ids += int_game_number;
        // }
        // my_hash_map.clearAndFree();
    }

    std.log.info("Solution for first part is: {d}\n", .{total_possible_ids});
}

pub fn solveSecondPart(input_data: []const u8) !void {
    var total_possible_ids: usize = 0;
    var lines = std.mem.splitAny(u8, input_data, "\n");
    while (lines.next()) |line| {
        var red_needed: usize = 0;
        var green_needed: usize = 0;
        var blue_needed: usize = 0;
        var game_separation = std.mem.splitAny(u8, line, ":");
        var game_id = game_separation.first();
        if (game_id.len < 5) {
            continue;
        }
        var game_info = game_separation.next().?;
        var game_sets = std.mem.splitAny(u8, game_info, ";");
        while (game_sets.next()) |set| {
            var cubes_per_set = std.mem.splitAny(u8, set, ",");
            while (cubes_per_set.next()) |cube_per_set| {
                var cube_per_set_trimmed = std.mem.trim(u8, cube_per_set, " ");
                var amount_and_color = std.mem.splitAny(u8, cube_per_set_trimmed, " ");
                var amount = amount_and_color.first();

                var int_amount = try std.fmt.parseUnsigned(u8, amount, 10);
                var color = amount_and_color.next().?;
                if (std.mem.eql(u8, color, "red") and int_amount > red_needed) {
                    red_needed = int_amount;
                } else if (std.mem.eql(u8, color, "green") and int_amount > green_needed) {
                    green_needed = int_amount;
                } else if (std.mem.eql(u8, color, "blue") and int_amount > blue_needed) {
                    blue_needed = int_amount;
                }
            }
        }
        var needed_for_set = red_needed * green_needed * blue_needed;
        total_possible_ids += needed_for_set;
    }

    std.log.info("Solution for second part is: {d}\n", .{total_possible_ids});
}

pub fn main() !void {
    var input = @embedFile("input.txt");
    try solveFirstPart(input);
    try solveSecondPart(input);
}
