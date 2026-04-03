const std = @import("std");

const FrameModule = @import("../../share.zig").FrameModule;
const Cell = FrameModule.Cell;

const tty = struct {
    stdout: std.fs.File,

    pub fn init() tty {
        return .{
            .stdout = std.io.getStdOut(),
        };
    }

    pub fn printCell(self: *const tty, cell: *const Cell) !void {
        try self.stdout.writer().print("{}", .{cell});
    }
};
