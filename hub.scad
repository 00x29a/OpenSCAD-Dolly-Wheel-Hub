// Parameters for the toroid
outer_radius    =   100;   // The overall radius of the toroid
tube_radius     =  22.5;   // The radius of the tube

// Printer Params
extrude_width   =   0.7;
wall_count      =     6;

layer_height    =   0.3;
base_lyr_count  =     6;


// Paremeters for hub
hub_height      =    38;
num_spokes      =     6;   // The number of spokes in the wheel
axle_height     =  31.5;
axle_diam       =  29.7;
bearings        = false;
side_render     =   "i";   // or "o" 

hub_thickness   = extrude_width*wall_count;
spoke_thickness = extrude_width*wall_count;

// Toroid formula
module toroid(outer_radius, tube_radius) {
    rotate_extrude($fn=100)
    translate([outer_radius-tube_radius, 0, 0])
    circle(tube_radius, $fn=50);
}
 // Function to create a single spoke                                                                                                                                                                                             
module spoke() { 
    cube([spoke_thickness, (outer_radius-tube_radius)*2, axle_height], center=true);
}

module hub( isHalf = true ){
    if(isHalf == true){
        difference() {
            // hub assembly
            difference() {
                color("red"){
                    intersection(){
                        cylinder(h = hub_height, r = outer_radius-tube_radius, center=true);
                        toroid(outer_radius-hub_thickness,tube_radius);
                    }
                    difference() {
                        // Rotate and place spokes around a circle
                        for (i = [0 : num_spokes - 1]) {
                            rotate([0, 0, i * 360 / num_spokes]) {
                                translate([0, tube_radius / 2, 0]) {
                                    spoke();
                                }
                            }
                        }
                        // remove for axle assembly
                        cylinder(h = axle_height+.1, d = axle_diam, center = true, $fn = 100);
                    }

                    // axle assembly
                    difference() {
                        cylinder(h = axle_height, d = axle_diam+(spoke_thickness*2), center = true, $fn = 100);
                        cylinder(h = axle_height+.1, d = axle_diam, center = true, $fn = 100);
                    }
                    
                }
                toroid(outer_radius, tube_radius);
            }
            mirror([0,0,1]) 
            cylinder(h = hub_height, d = outer_radius*2);
        }
    }
    else{
        // hub assembly
        difference() {
            color("red"){
                intersection(){
                    cylinder(h = hub_height, r = outer_radius-tube_radius, center=true);
                    toroid(outer_radius-hub_thickness,tube_radius);
                }
                difference() {
                    // Rotate and place spokes around a circle
                    for (i = [0 : num_spokes - 1]) {
                        rotate([0, 0, i * 360 / num_spokes]) {
                            translate([0, tube_radius / 2, 0]) {
                                spoke();
                            }
                        }
                    }
                    // remove for axle assembly
                    cylinder(h = axle_height+.1, d = axle_diam, center = true, $fn = 100);
                }

                // axle assembly
                difference() {
                    cylinder(h = axle_height, d = axle_diam+(spoke_thickness*2), center = true, $fn = 100);
                    cylinder(h = axle_height+.1, d = axle_diam, center = true, $fn = 100);
                }
                
            }
            toroid(outer_radius, tube_radius);
        }
    }
}

hub(false);
