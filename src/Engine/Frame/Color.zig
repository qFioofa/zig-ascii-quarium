const std = @import("std");

pub const ColorBase = enum(u3) {
    black = 0,
    red = 1,
    green = 2,
    yellow = 3,
    blue = 4,
    magenta = 5,
    cyan = 6,
    white = 7,

    pub fn ansiFgCode(self: ColorBase, bright: bool) []const u8 {
        if (bright) {
            return switch (self) {
                .black => "\x1b[90m",
                .red => "\x1b[91m",
                .green => "\x1b[92m",
                .yellow => "\x1b[93m",
                .blue => "\x1b[94m",
                .magenta => "\x1b[95m",
                .cyan => "\x1b[96m",
                .white => "\x1b[97m",
            };
        } else {
            return switch (self) {
                .black => "\x1b[30m",
                .red => "\x1b[31m",
                .green => "\x1b[32m",
                .yellow => "\x1b[33m",
                .blue => "\x1b[34m",
                .magenta => "\x1b[35m",
                .cyan => "\x1b[36m",
                .white => "\x1b[37m",
            };
        }
    }

    pub fn ansiBgCode(self: ColorBase, bright: bool) []const u8 {
        if (bright) {
            return switch (self) {
                .black => "\x1b[100m",
                .red => "\x1b[101m",
                .green => "\x1b[102m",
                .yellow => "\x1b[103m",
                .blue => "\x1b[104m",
                .magenta => "\x1b[105m",
                .cyan => "\x1b[106m",
                .white => "\x1b[107m",
            };
        } else {
            return switch (self) {
                .black => "\x1b[40m",
                .red => "\x1b[41m",
                .green => "\x1b[42m",
                .yellow => "\x1b[43m",
                .blue => "\x1b[44m",
                .magenta => "\x1b[45m",
                .cyan => "\x1b[46m",
                .white => "\x1b[47m",
            };
        }
    }
};

pub const ColorBrightness = enum(u1) {
    normal = 0,
    bright = 1,
};

pub const Color = union(enum) {
    default: void,
    fg: struct { base: ColorBase, bright: ColorBrightness },
    bg: struct { base: ColorBase, bright: ColorBrightness },

    pub fn initFg(base: ColorBase, bright: ColorBrightness) Color {
        return .{ .fg = .{ .base = base, .bright = bright } };
    }

    pub fn initBg(base: ColorBase, bright: ColorBrightness) Color {
        return .{ .bg = .{ .base = base, .bright = bright } };
    }

    pub fn ansiFg(self: Color) []const u8 {
        return switch (self) {
            .default => "",
            .fg => |f| f.base.ansiFgCode(f.bright == .bright),
            .bg => "",
        };
    }

    pub fn ansiBg(self: Color) []const u8 {
        return switch (self) {
            .default => "",
            .fg => "",
            .bg => |b| b.base.ansiBgCode(b.bright == .bright),
        };
    }

    pub fn reset() []const u8 {
        return "\x1b[0m";
    }

    pub fn isFg(self: Color) bool {
        return self == .fg;
    }

    pub fn isBg(self: Color) bool {
        return self == .bg;
    }

    pub fn isDefault(self: Color) bool {
        return self == .default;
    }

    pub fn toBg(self: Color) Color {
        return switch (self) {
            .default => .default,
            .fg => |f| .{ .bg = .{ .base = f.base, .bright = f.bright } },
            .bg => |b| .{ .bg = b },
        };
    }

    pub fn toFg(self: Color) Color {
        return switch (self) {
            .default => .default,
            .fg => |f| .{ .fg = f },
            .bg => |b| .{ .fg = .{ .base = b.base, .bright = b.bright } },
        };
    }

    pub fn getBase(self: Color) ?ColorBase {
        return switch (self) {
            .default => null,
            .fg => |f| f.base,
            .bg => |b| b.base,
        };
    }

    pub fn getBrightness(self: Color) ?ColorBrightness {
        return switch (self) {
            .default => null,
            .fg => |f| f.bright,
            .bg => |b| b.bright,
        };
    }
};

pub const perl_palette = [_]Color{
    Color.initFg(.cyan, .normal),
    Color.initFg(.cyan, .bright),
    Color.initFg(.red, .normal),
    Color.initFg(.red, .bright),
    Color.initFg(.yellow, .normal),
    Color.initFg(.yellow, .bright),
    Color.initFg(.blue, .normal),
    Color.initFg(.blue, .bright),
    Color.initFg(.green, .normal),
    Color.initFg(.green, .bright),
    Color.initFg(.magenta, .normal),
    Color.initFg(.magenta, .bright),
};

pub fn parseColorCode(code: u8) ?Color {
    return switch (code) {
        'c' => Color.initFg(.cyan, .normal),
        'C' => Color.initFg(.cyan, .bright),
        'r' => Color.initFg(.red, .normal),
        'R' => Color.initFg(.red, .bright),
        'y' => Color.initFg(.yellow, .normal),
        'Y' => Color.initFg(.yellow, .bright),
        'b' => Color.initFg(.blue, .normal),
        'B' => Color.initFg(.blue, .bright),
        'g' => Color.initFg(.green, .normal),
        'G' => Color.initFg(.green, .bright),
        'm' => Color.initFg(.magenta, .normal),
        'M' => Color.initFg(.magenta, .bright),
        else => null,
    };
}
