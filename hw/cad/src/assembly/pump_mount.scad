use <../pump-v3.scad>
use <../lib/bolts.scad>
use <../lib/copyFunctions.scad>
$fn=30;

stl_dir = "../../../stl/";
pd = 10.16; // pin distance

module pump(a1, a2){
    color("white", a1){
        stator_base();
        translate([0, 0, 4])
        stator_support();
        stator_cover();
        rotor(1);
        rotor(2);
        rotate([180, 0, 0]) mirror_copy([1, 0, 0]){
            translate([-71.12/2, -25.52, -7])
                bolt(3, 53, false);
            translate([-71.12/2, 35.44, -7])
                bolt(3, 53, false);
        }
    }
    color("gray", a2) translate([0,0,-40]) import(str(stl_dir, "Nema17_40h.stl"));
}

module HBSTEP01B(alpha){
    color("blue", alpha){
        translate([pd*2, pd*2.5, 1]){
            cube([pd*4, pd*5, 2], center=true);
            mirror_copy([1, 0, 0])
            mirror_copy([0, 1, 0])
            translate([- 1.5*pd, -2*pd, 4]) rotate([180, 0, 0])
                bolt(3, 10, false);
        }
    }
}

module I2CSPI(alpha){
    color("red", alpha){
        translate([pd*1.5, pd*2, 1]){
            cube([pd*3, pd*4, 2], center=true);
            mirror_copy([1, 0, 0])
            mirror_copy([0, 1, 0])
            translate([- 1*pd, -1.5*pd, 4]) rotate([180, 0, 0])
                bolt(3, 10, false);
        }
    }
}

module USBI2C(alpha){
    color("green", alpha) I2CSPI();
}

// PERISTALTICs
translate([35.5 + 10 + pd, 35.5 + 10 + pd, 45])
    pump(1, 1);
translate([35.5 + 10 + 11*pd, 35.5 + 10 + pd, 45])
    pump(1, 1);
translate([35.5 + 10 + pd, 35.5 + 10 + 8*pd, 45]) rotate([0, 0, 180])
    pump(1, 1);
translate([35.5 + 10 + 11*pd, 35.5 + 10 + 8*pd, 45]) rotate([0, 0, 180])
    pump(1, 1);

// ALBASE1521
    difference(){
        cube([250, 180, 5]);
        for (i = [1:21]) {
            for (j = [1:15])
            translate([10 + i*pd, 10 + j*pd, -0.1 ])
                cylinder(d=3.2, 5.2);
        }
    }

// HBSTEP01B
translate([10 + pd/2 + 7*pd, 10 + pd/2 + 1*pd, 5])
    HBSTEP01B(1);
translate([10 + pd/2 + 17*pd, 10 + pd/2 + 1*pd, 5])
    HBSTEP01B(1);
translate([10 + pd/2 + 7*pd, 10 + pd/2 + 9*pd, 5])
    HBSTEP01B(1);
translate([10 + pd/2 + 17*pd, 10 + pd/2 + 9*pd, 5])
    HBSTEP01B(1);

// I2CSPI
translate([10 + pd/2 + 16*pd, 10 + pd/2 + 6*pd, 5]) rotate([0, 0, 90])
    I2CSPI(1);

// USBI2C
translate([10 + pd/2 + 6*pd, 10 + pd/2 + 6*pd, 5]) rotate([0, 0, 90])
    USBI2C(1);

//Nema 17 size
//cube([43, 43, 40]);
