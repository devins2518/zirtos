const std = @import("std");
const Target = std.Target;

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{ .default_target = .{
        .cpu_arch = Target.Cpu.Arch.thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
        .os_tag = Target.Os.Tag.freestanding,
        .abi = Target.Abi.none,
    } });

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    b.setPreferredReleaseMode(.ReleaseSmall);
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("firmware", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.setLinkerScriptPath(.{ .path = "ld_src/stm32/linker.ld" });

    const kernel = b.addInstallRaw(exe, "firmware.bin", .{});
    const kernel_step = b.step("build", "Build the kernel");
    kernel_step.dependOn(&kernel.step);

    const run_cmd_str = &[_][]const u8{
        "qemu-system-arm",
        "-M",
        "stm32vldiscovery",
        "-kernel",
        "./zig-out/bin/firmware.bin",
    };

    const run_cmd = b.addSystemCommand(run_cmd_str);
    run_cmd.step.dependOn(kernel_step);

    const run_step = b.step("run", "Run the kernel");
    run_step.dependOn(&run_cmd.step);
}
