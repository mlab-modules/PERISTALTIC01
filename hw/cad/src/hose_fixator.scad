include <../configuration.scad>

hose_fixator();

hose_fixator_length = 15;

module hose_fixator() {
	$fn = 75;

	// Length
	h=hose_fixator_length;

	//Radius
	d_hose = 9;
	hose_wall = 1.5; 
	hose_fitting_delta_d = 0.2;
	r=d_hose/2-hose_wall+hose_fitting_delta_d/2; 

	//wall thickness
	th=0.45*3; 

	difference(){
		cylinder(r=r, h=h);
		cylinder(r=r-th, h=h);
	}
}