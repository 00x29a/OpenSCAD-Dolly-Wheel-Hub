// Parameters for the toroid
outer_radius    =  100;   // The overall radius of the toroid
tube_radius     = 22.5;   // The radius of the tube

// Paremeters for hub
hub_height      =   38;
hub_thickness   =    4;
spoke_thickness =    4;
num_spokes = 8; // The number of spokes in the wheel

// Toroid formula
module toroid(outer_radius, tube_radius) {
    rotate_extrude($fn=100)
    translate([outer_radius-tube_radius, 0, 0])
    circle(tube_radius, $fn=50);
}
 // Function to create a single spoke                                                                                                                                                                                             
 module spoke() {                                                                                                                                                                                                                 
     cube([spoke_thickness, (outer_radius-tube_radius)*2, hub_height], center=true);                                                                                                                                                                      
 }                                                                                                                                                                                                                                

// hub assembly
difference() {
    color("red"){
        intersection(){
            cylinder(h = hub_height, r = outer_radius-tube_radius, center=true);
            toroid(outer_radius-hub_thickness,tube_radius);
        }
        // Rotate and place spokes around a circle
        for (i = [0 : num_spokes - 1]) {
            rotate([0, 0, i * 360 / num_spokes]) {
                translate([0, tube_radius / 2, 0]) {
                    spoke();
                }
            }
        }
    }
    toroid(outer_radius, tube_radius);
}
                                                                                                                                                
                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                  