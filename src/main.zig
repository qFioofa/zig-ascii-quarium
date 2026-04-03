const std = @import("std");
const ColorModule = @import("Engine/Frame/Color.zig");
const Color = ColorModule.Color;
const ColorBase = ColorModule.ColorBase;
const ColorBrightness = ColorModule.ColorBrightness;
const Cell = @import("Engine/Frame/Frame.zig").Cell;

const cat = [_][]const u8{
    " /\\_/\\ ",
    "( o.o )",
    " >^<  ",
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const orange = Color.initFg(.yellow, .bright);
    const white = Color.initFg(.white, .normal);

    for (cat) |line| {
        for (line) |char| {
            const cell = if (char == 'o')
                Cell.init(char, orange, .default)
            else
                Cell.init(char, white, .default);

            if (!cell.fg.isDefault()) {
                try stdout.writeAll(cell.fg.ansiFg());
            }
            try stdout.writeByte(cell.char);
        }
        try stdout.writeAll(Color.reset());
        try stdout.writeByte('\n');
    }
}
