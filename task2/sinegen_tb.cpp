#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vsinegen.h"
#include "vbuddy.cpp" // include vbuddy code

#define MAX_SIM_CYC 1000000
#define ADDRESS_WIDTH 8
#define ROM_SZ 256

int main(int argc, char **argv, char **env) {
    int simcyc; // simulation clock count
    int tick;   // each clk cycle has 2 ticks for 2 edges

    Verilated::commandArgs(argc, argv);

    Vsinegen* top = new Vsinegen; // init top verilog instance
    Verilated::traceEverOn(true); // init trace dump
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("sinegen.vcd");

    // init Vbuddy
    if (vbdOpen() != 1) return (-1);
    vbdHeader("L2T2: Sine and Cosine");
    // vbdSetMode(1); // Flag mode set to one-shot

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->en = 1;
    top->incr = 1;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++) {
        // offset is read from Vbuddy (64)
        top->offset = vbdValue();

        // dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++){
            tfp->dump (2*simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        // plot ROM output and print cycle count
        vbdPlot(int(top->dout1), 0, 255);
        vbdPlot(int(top->dout2), 0, 255);
        vbdCycle(simcyc);

        // either simulation finished, or 'q' is pressed
        if ((Verilated::gotFinish()) || (vbdGetkey() == 'q'))
            exit(0);
    }

    vbdClose();   
    tfp->close();
    exit(0);

}