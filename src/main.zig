export fn Reset_Handler() callconv(.Naked) void {
    while (true) {}
}

const Isr: type = fn () callconv(.Naked) void;
export fn __inf_loop() callconv(.Naked) void {
    while (true) {}
}

export const NMIHandler = __inf_loop;
export const HardFaultHandler = __inf_loop;
export const MMUFaultHandler = __inf_loop;
export const BusFaultHandler = __inf_loop;
export const UsageFaultHandler = __inf_loop;
export const SVCCallFaultHandler = __inf_loop;
export const DebugHandler = __inf_loop;
export const PendSVHandler = __inf_loop;
export const SystickHandler = __inf_loop;

export var vector_table linksection(".isr_vector") = [_]?Isr{
    Reset_Handler,
    NMIHandler, // NMI
    HardFaultHandler, // Hard Fault
    MMUFaultHandler, // MMU Fault
    BusFaultHandler, // Bus fault
    UsageFaultHandler, // Usage Fault
    null, // Reserved
    null, // Reserved
    null, // Reserved
    null, // Reserved
    SVCCallFaultHandler, // SVC Call
    DebugHandler, // Debug
    null, // Reserved
    PendSVHandler, // PendSV
    SystickHandler, // Systick
};
