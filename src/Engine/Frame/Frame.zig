const std = @import("std");
const Color = @import("Color.zig").Color;

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

    pub fn initDefault() Cell {
        return .{
            .char = ' ',
            .fg = .default,
            .bg = .default,
        };
    }

    pub fn initChar(char: u8) Cell {
        return .{
            .char = char,
            .fg = .default,
            .bg = .default,
        };
    }

    pub fn isEmpty(self: Cell) bool {
        return self.char == ' ' and self.fg.isDefault() and self.bg.isDefault();
    }

    pub fn eq(self: Cell, other: Cell) bool {
        return self.char == other.char and colorsEqual(self.fg, other.fg) and colorsEqual(self.bg, other.bg);
    }

    fn colorsEqual(a: Color, b: Color) bool {
        return switch (a) {
            .default => b == .default,
            .fg => |fa| switch (b) {
                .fg => |fb| fa.base == fb.base and fa.bright == fb.bright,
                else => false,
            },
            .bg => |ba| switch (b) {
                .bg => |bb| ba.base == bb.base and ba.bright == bb.bright,
                else => false,
            },
        };
    }
};

pub const Frame = struct {
    width: usize,
    height: usize,
    cells: []Cell,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, width: usize, height: usize) !Frame {
        const cells = try allocator.alloc(Cell, width * height);
        @memset(cells, Cell.initDefault());
        return .{
            .width = width,
            .height = height,
            .cells = cells,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: Frame) void {
        self.allocator.free(self.cells);
    }

    pub fn clear(self: Frame) void {
        @memset(self.cells, Cell.initDefault());
    }

    pub fn getIndex(self: Frame, x: usize, y: usize) usize {
        return y * self.width + x;
    }

    pub fn inBounds(self: Frame, x: usize, y: usize) bool {
        return x < self.width and y < self.height;
    }

    pub fn get(self: Frame, x: usize, y: usize) ?Cell {
        if (!self.inBounds(x, y)) return null;
        return self.cells[self.getIndex(x, y)];
    }

    pub fn set(self: Frame, x: usize, y: usize, cell: Cell) void {
        if (self.inBounds(x, y)) {
            self.cells[self.getIndex(x, y)] = cell;
        }
    }

    pub fn setChar(self: Frame, x: usize, y: usize, char: u8) void {
        if (self.inBounds(x, y)) {
            self.cells[self.getIndex(x, y)].char = char;
        }
    }

    pub fn row(self: Frame, y: usize) []Cell {
        const start = y * self.width;
        return self.cells[start .. start + self.width];
    }

    pub fn eq(self: Frame, other: Frame) bool {
        if (self.width != other.width or self.height != other.height) return false;
        for (self.cells, 0..) |cell, i| {
            if (!cell.eq(other.cells[i])) return false;
        }
        return true;
    }
};

pub const Mask = struct {
    content: [][]const u8,

    pub fn init(content: [][]const u8) Mask {
        return .{ .content = content };
    }

    pub fn getHeight(self: Mask) usize {
        return self.content.len;
    }

    pub fn getWidth(self: Mask) usize {
        if (self.content.len == 0) return 0;
        return self.content[0].len;
    }

    pub fn getChar(self: Mask, x: usize, y: usize) ?u8 {
        if (y >= self.content.len) return null;
        if (x >= self.content[y].len) return null;
        return self.content[y][x];
    }
};
