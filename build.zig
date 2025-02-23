const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const builder = b.dependency("rpmalloc", .{
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.addModule("bindings", .{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const art = builder.artifact("rpmalloc_static");
    for (art.root_module.include_dirs.items) |inc| {
        lib_mod.include_dirs.append(b.allocator, inc) catch @panic("OOM");
    }
    lib_mod.linkLibrary(art);
}
