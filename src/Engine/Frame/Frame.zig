const Color = @import("Color.zig");

pub const Mask = struct {
    char_space: u8,
    char_fill: u8,
    content: [][]const u8,

    pub fn init(char_space: u8, char_fill: u8, content: [][]const u8) Mask {
        return .{ .char_space = char_space, .char_fill = char_fill, .content = content };
    }
};

pub const Cell = struct {
    char: u8,
    fg: Color,
    bg: Color,

    pub fn init(char: u8, fg: Color, bg: Color) Cell {
        return .{
            .char = char,
            .fg = fg,
            .bg = bg,
        };
    }
};

pub const AsciiFrame = struct {
    width: usize,
    hight: usize,
    content: [][]const Cell,

    pub fn init(w: usize, h: usize, content: [][]const Cell) AsciiFrame {
        return .{ .width = w, .hight = h, .content = content };
    }
};
