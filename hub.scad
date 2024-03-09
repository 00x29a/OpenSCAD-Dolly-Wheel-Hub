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
side_render     =   "i";   // or "o". inner outer yada yada

plate_lyr_thkns = layer_height*base_lyr_count;
hub_thickness   = extrude_width*wall_count;
spoke_thickness = extrude_width*wall_count;

washer_diam     =    10;
thread_diam     =   5.5; // plus .5 mm slop

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
// Module to create a single cylinder
module cylinder_spoke(cylinder_height = 10, cylinder_diameter = 10, num_cylinders = num_spokes) {
    cylinder(h = cylinder_height, d = cylinder_diameter, $fn = 50);
}
module cylinder_array(side = side_render) {
    // Generate cylinders around a central point
    for (i = [0 : num_spokes - 1]) {
        rotate([0, 0, i * 360 / num_spokes]) {
            translate([outer_radius-((tube_radius*2)+(hub_thickness*2)), 0, 0]) {
                cylinder_spoke();
            }
        }
    }
}
// Module for base hub structure
module hub_base( isHalf = true ) {
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

module hub_half(side = side_render) {
    // mirror([0,0,1]) 
    hub_base();
    if(side == "i") {
        cylinder(h = plate_lyr_thkns, r = outer_radius-tube_radius*2, $fn = 100);
        cylinder_array();
    }
    else {  
        cylinder(h = plate_lyr_thkns, r = outer_radius-tube_radius*2, $fn = 100);
        cylinder_array();
   }
}

// hub_base(false);

hub_half(side_render);

