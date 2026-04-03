const std = @import("std");

pub const direction = enum { left, right, up, bottom, static, custom };

pub const entity = struct { x: i32, y: i32, speed: usize, direction: direction };
