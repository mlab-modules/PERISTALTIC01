// Created by Phisik on 2018-10-20
// Case for open source peristaltic pump

// Licence GPL 
// You are free to distibute & contribute to this part in any form

// Settings
//==============================================================================
include <../configuration.scad>
use <lcd1602.scad>
stl_dir = "../../stl/";

assembly      = 1;   // render assembly
render_top    = 1;   // render top part
render_bottom = 1;   // render bottom part
render_side_panel = 1;   // render bottom part

h_case = 68;
w_case = 115;
l_case = 115;

nema_clearance = 0.8;

// Front panel settings
front_angle=22.5;
back_angle=45;
wall_case = 0.46*cos(front_angle)*4;
wall_size_scale = 1/cos(front_angle);  // when 3d printing tilded walls will thicker


w_front_panel = w_lcd_plate + 35.9;


r_ext = r_hose + d_hose/2 + wall - hose_groove;
handle_length = r_ext+l_handle;
w_back_panel = handle_length+r_ext;


extra_lcd_n_ecn_shift = 5;

lcd_clearance = -0.1;
x_1602_shift = 11;
y_1602_shift = -y_lcd_shift+extra_lcd_n_ecn_shift;
z_1602_shift = -6;

x_enc_shift = -40;
y_enc_shift = 2.2+extra_lcd_n_ecn_shift;
z_enc_shift = -8.5;


// PCB settings
l_pcb = 58;
h_pcb = 1.6;
w_pcb = 51;
x_pcb_hole = 51.4;
y_pcb_hole = 43.8;
d_pcb_hole = 2;
x_shift_pcb = 0;
y_shift_pcb = -27;
z_shift_pcb = 8;

alpha = 1;

// ventillation holes settings
n_vent = 4;
h_vent = 25;
w_vent = 2.5;
dist_vent = 8;
vent_y_shift = 42;
vent_z_shift = 22;

// bottom plate settings
d_bottom_holes = 3;
d_bottom_legs = 20;
h_bottom_legs = 4;
legs_shift = w_case/2-d_bottom_legs/2-7.5;

// bottom plate holders
holders_size = 10;

// Assemble
//==============================================================================
if(assembly) {
    alpha = 1;
    

    color("red", alpha) 
        translate([x_shift_pcb, y_shift_pcb, z_shift_pcb]) 
        pcb();
    
    color("green", alpha) 
        translate([0,-l_case, h_case-w_back_panel*sin(back_angle)]) 
        rotate([back_angle, 0, 0])  
        translate([0,handle_length, 0]) 
        import(str(stl_dir, "assembly/pump.stl"));
    
    if(render_top)       case_main();
    if(render_bottom)    bottom_cover();
} else {
    if(render_top)       case_main();
    if(render_bottom)    bottom_cover();
}

// Bottom cover
//==============================================================================
module bottom_cover() {
    cover_clearance = 0.3;
        difference() {
            translate([-w_case/2 + wall_case + cover_clearance,
                   -l_case + wall_case + cover_clearance, 0]) 
           cube([
                w_case-2*wall_case-2*cover_clearance, 
                l_case-wall_case-2*cover_clearance, 
                wall_case], center=false);
    
        
     translate([x_shift_pcb, y_shift_pcb, 0]){
      translate([x_pcb_hole, y_pcb_hole, -eps]/2)
            cylinder(d=d_bottom_holes, h=wall_case+1);
        translate([x_pcb_hole, -y_pcb_hole, -eps]/2)
            cylinder(d=d_bottom_holes, h=wall_case+1);
        translate([-x_pcb_hole, y_pcb_hole, -eps]/2)
            cylinder(d=d_bottom_holes, h=wall_case+1);
        translate([-x_pcb_hole, -y_pcb_hole, -eps]/2)
            cylinder(d=d_bottom_holes, h=wall_case+1);
    } // pcb holes
    
             
         // holders for bottom plate
    translate([-w_case/2+wall_case-eps, eps, -eps]) 
        holder_hole(holders_size, d_bottom_holes);
    translate([-w_case/2+wall_case-eps, -l_case+wall_case+holders_size-eps, -eps]) holder_hole(holders_size, d_bottom_holes);
    translate([w_case/2-wall_case+eps, -l_case+wall_case-eps, -eps]) 
    rotate([0,0,180]) holder_hole(holders_size, d_bottom_holes);
    translate([w_case/2-wall_case+eps, -holders_size+eps, -eps]) 
    rotate([0,0,180]) holder_hole(holders_size, d_bottom_holes);
}

translate([0,-l_case/2 + 0.5*wall_case + cover_clearance, -h_bottom_legs]) {
translate(legs_shift*[1,1,0])    
cylinder(d=d_bottom_legs, h=h_bottom_legs);
    translate(legs_shift*[1,-1,0])    
cylinder(d=d_bottom_legs, h=h_bottom_legs);
    translate(legs_shift*[-1,1,0])    
cylinder(d=d_bottom_legs, h=h_bottom_legs);
    translate(legs_shift*[-1,-1,0])    
cylinder(d=d_bottom_legs, h=h_bottom_legs);
                   }

module holder_hole(size, d){
    translate([size/2, -size/2, 0])
            cylinder(d=d,h=20);
}
            
}

// Case main/top part
//==============================================================================
//font_thickness = 1;
//minkowski(){
//translate([0,wall_case,0.6*(h_case-w_front_panel*sin(front_angle))])
//    rotate([90,0,180]) 
//    linear_extrude(font_thickness) 
//    text("Pump v3", size = 15, halign="center", valign="center");
//sphere(d=1);
//}
//
//translate([0,wall_case,0.25*(h_case-w_front_panel*sin(front_angle))])
//    rotate([90,0,180]) 
//    linear_extrude(font_thickness) 
//    text("(c) 2018 Phisik", size = 5, halign="center", valign="center");

module case_main() {

    // front panel with lcd & encoder
    translate( [  0,
                 -w_front_panel/2*cos(front_angle)+wall_case,
                  h_case-0.5*w_front_panel*sin(front_angle)
               ])
    rotate([-front_angle,0,0])
    translate([0,0,-wall_case]) {
        difference(){
            translate([-w_case/2,-w_front_panel/2,0]) 
               cube([w_case, w_front_panel, wall_case], center=false);

            translate([x_1602_shift, y_1602_shift, z_1602_shift])
                translate([x_lcd_shift,y_lcd_shift,10])
                    cube([l_lcd+lcd_clearance*2, w_lcd+2*lcd_clearance, 20], center=true);
            translate([x_enc_shift - 2, y_enc_shift - 2.57,-8.5])
                rotate([0,0,-90]) {
                    cylinder(d=7.5, h=20);
                }
        } // difference()
        
        // pins for lcd
         d_stand = d_lcd_hole+2;
            d_stand_hole = 1.5;
        
        translate([x_1602_shift, y_1602_shift, z_1602_shift+h_lcd_plate]) {
           
            translate([x_lcd_hole, y_lcd_hole, -eps]/2) 
            difference(){
                cylinder(d=d_stand, h=-z_1602_shift+eps);
                cylinder(d=d_stand_hole, h=-z_1602_shift+2*eps);
            }
            translate([x_lcd_hole, -y_lcd_hole, -eps]/2)
            difference(){
                cylinder(d=d_stand, h=-z_1602_shift+eps);
                cylinder(d=d_stand_hole, h=-z_1602_shift+2*eps);
            }
            translate([-x_lcd_hole, y_lcd_hole, -eps]/2)
            difference(){
                cylinder(d=d_stand, h=-z_1602_shift+eps);
                cylinder(d=d_stand_hole, h=-z_1602_shift+2*eps);
            }
            translate([-x_lcd_hole, -y_lcd_hole, -eps]/2)
            difference(){
                cylinder(d=d_stand, h=-z_1602_shift+eps);
                cylinder(d=d_stand_hole, h=-z_1602_shift+2*eps);
            }
        }// translate()
        
        
        translate([x_enc_shift+7.25, y_enc_shift, z_enc_shift+1.5]){
            translate([0, 6.5, 0])difference(){
                cylinder(d=d_stand, h=-z_enc_shift);
                cylinder(d=d_stand_hole, h=-z_enc_shift+2*eps-1);
            }
            translate([0, -7.4, 0])difference(){
                cylinder(d=d_stand, h=-z_enc_shift);
                cylinder(d=d_stand_hole, h=-z_enc_shift+2*eps-1);
            }
        } // translate()

        
        if(assembly) {
            color("blue", alpha) 
            translate([x_1602_shift, y_1602_shift, z_1602_shift]) 
                 lcd1602();
            color("purple", alpha)  
            translate([x_enc_shift, y_enc_shift, z_enc_shift])
                rotate([0,0,+90]) import(str(stl_dir, "ky-040.stl"));
        }  // if(assembly)
    } // translate()


    // front wall
    translate([-w_case/2,0,0]) 
        cube([w_case, wall_case, h_case-w_front_panel*sin(front_angle)], center=false);

    // back panel
    translate([-w_case/2,-l_case,0]) 
    difference(){
        cube([w_case, wall_case, h_case-w_back_panel*sin(back_angle)], center=false);
        translate([w_case-10, 20, h_case/2]) rotate([90,0,0]) 
            cylinder(d=8.1/cos(30), h=40, $fn=6);
    } 
    
      // side panels
    if(render_side_panel) difference(){
        union(){
            // if(!assemble)
                // right panel
                translate([-w_case/2+wall_case*(1-wall_size_scale),-l_case,0]) 
                    cube([wall_case*wall_size_scale, l_case+wall_case, h_case+eps], center=false);

            // left panel
            translate([+w_case/2-wall_case,-l_case,0]) 
                cube([wall_case*wall_size_scale, l_case+wall_case, h_case+eps], center=false);
        }   // uinon()
        
        // cut angles
        translate( [  -w_case, -w_front_panel*cos(front_angle)+wall_case-eps, h_case])
            rotate([-front_angle, 0,0])
            cube([2*w_case + 2*eps, l_case+h_case, h_case], center=false);
            
        translate( [  -w_case, 
                      -l_case-(h_case-w_back_panel*sin(back_angle))/tan(back_angle)+eps, 0])
            rotate([back_angle, 0,0])
            cube([2*w_case, l_case+h_case, h_case], center=false);
        
        // ventilation holes
        for(i=[0:n_vent-1])
            translate( [-10-w_case/2, -l_case+vent_y_shift+(w_vent+dist_vent)*i, vent_z_shift])
                cube([w_case + 20, w_vent, h_vent], center=false);
    } // difference()


    // top panel
    translate([-w_case/2,-l_case+w_back_panel*cos(back_angle),h_case-wall_case]) 
            cube([ w_case, 
                   l_case+wall_case-w_back_panel*cos(back_angle)-w_front_panel*cos(front_angle), 
                   wall_case], center=false);

    // head panel
    translate([0,-l_case,h_case]) 
    difference(){
        translate([-w_case/2,0,-w_back_panel*sin(back_angle)])
            rotate([back_angle, 0, 0])
            translate([0,0,-wall_case])
            cube([ w_case, w_back_panel, wall_case], center=false);
        
        translate([0,-0, -w_back_panel*sin(back_angle)]) 
            rotate([back_angle, 0, 0])  
            translate([0,handle_length, 0]) { 
                    intersection(){   
                        w =  nema_width+2*nema_clearance;
                        h = 100;
                        cube([w, w, h], center=true);   
                        rotate([0,0,45]) {
                            w =  nema_width*sqrt(2)-2*nema_angle_cut/sqrt(2)+2*nema_clearance;
                           cube([w,w,h], center=true);
                        }
                    }

                    // Head mount holes
                    translate([r_ext+mount_length/2, -handle_length+mount_length/2, -wall-eps]) 
                        cylinder(d=d_screw, 10, $fn=6);
                    translate([-r_ext-mount_length/2, -handle_length+mount_length/2, -wall-eps]) 
                        cylinder(d=d_screw, 10, $fn=6);
                    translate([r_ext+mount_length/2, r_ext-mount_length/2, -wall-eps]) 
                        cylinder(d=d_screw, 10, $fn=6);
                    translate([-r_ext-mount_length/2, r_ext-mount_length/2, -wall-eps]) 
                        cylinder(d=d_screw, 10, $fn=6);
                } // translate() 
    } // difference()
    

    



    // holders for bottom plate
    translate([-w_case/2+wall_case-eps, eps, wall_case]) 
        holder(holders_size);
    translate([-w_case/2+wall_case-eps, -l_case+wall_case+holders_size-eps, wall_case]) 
        holder(holders_size);
    translate([w_case/2-wall_case+eps, -l_case+wall_case-eps, wall_case]) 
        rotate([0,0,180]) 
        holder(holders_size);
    translate([w_case/2-wall_case+eps, -holders_size+eps, wall_case]) 
        rotate([0,0,180]) 
        holder(holders_size);
}


// Bottom cover holders
//==============================================================================
module holder(size){
    difference(){
        rotate([90,0,0])
            linear_extrude(size)
            polygon(points=[[0,0],[1,0],[1,1/2],[0,1.5]]*size);
        
        translate([size/2, -size/2, 0])
            cylinder(d=1.5,h=9);
    }
}



// PBC 3d model
//==============================================================================
module pcb()
{
    difference() {
     translate([0,0,h_pcb/2]) 
        cube([l_pcb, w_pcb, h_pcb], center=true);
    
      translate([x_pcb_hole, y_pcb_hole, -eps]/2)
            cylinder(d=d_pcb_hole, h=2);
        translate([x_pcb_hole, -y_pcb_hole, -eps]/2)
            cylinder(d=d_pcb_hole, h=2);
        translate([-x_pcb_hole, y_pcb_hole, -eps]/2)
            cylinder(d=d_pcb_hole, h=2);
        translate([-x_pcb_hole, -y_pcb_hole, -eps]/2)
            cylinder(d=d_pcb_hole, h=2);
    }
    
    translate([15,0,8]) 
        cube([18, 33, 15], center=true);
    translate([-3,5,8]) 
        cube([15, 20, 15], center=true);
    translate([-20,-5,8]) 
        cube([15, 20, 15], center=true);
}


