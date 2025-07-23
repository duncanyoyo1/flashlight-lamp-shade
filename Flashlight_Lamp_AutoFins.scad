$fa = 0.1; // Quality Settings
$fs = 0.1; // Increase these if you have issues rendering

//Select Light Model
model = "D3AA"; // ["D3AA", "DA1K", "D4K", "D4V2", "D4SV2", "KR1", "KR4", "K1", "K9.3", "KC1", "D1", "D1K", "D18", "DM1.12", "DM11", "M44", "TS10", "TS11", "TS25", "S21E", "Custom"]

//Only used if model = "Custom"
custom_head_diameter = 32; // [10:120]

//Head Diameter
flashlight_head_diameter =
    model == "D3AA"   ? 24.25 :
    model == "DA1K"   ? 30.32 :
    model == "D4K"    ? 28.30 :
    model == "D4V2"   ? 28.23 :
    model == "D4SV2"  ? 39.23 :
    model == "KR1"    ? 35.23 :
    model == "KR4"    ? 29.23 :
    model == "K1"     ? 72.23 :
    model == "K9.3"   ? 52.20 :
    model == "KC1"    ? 14.48 :
    model == "D1"     ? 35.23 :
    model == "D1K"    ? 35.23 :
    model == "D18"    ? 58.23 :
    model == "DM1.12" ? 63.23 :
    model == "DM11"   ? 40.23 :
    model == "M44"    ? 58.23 :
    model == "TS10"   ? 21.26 :
    model == "TS11"   ? 40.28 :
    model == "TS25"   ? 29.85 :
    model == "S21E"   ? 27.60 :
    model == "Custom" ? custom_head_diameter :
    assert(false, str("Invalid model: ", model));
    echo("model=", model, " -> head_dia=", flashlight_head_diameter);

wall_thickness = 1.2;                 // [0.1:10]

//Ratios (editable via Customizer)
// The ratio of the Flashlight Head to the Lamp Shade Diameter
outer_diameter_ratio = 3.33;          // [0.5:5.0]
//The ratio of the Flashlight Head to Lamp Height
outer_height_ratio   = 2.50;          // [0.5:5.0]
//The ratio of the Flashlight Head to Inner Diffuser Height
inner_height_ratio   = 1.75;          // [0.5:5.0]

// --- Parameters (editable via Customizer) ---

//Angle of the Lamp Shade and Diffuser Cone
cone_angle = 8;                       // [1:25]
//How many arms connect the shade to the diffuser
arm_count = 3;                        // [1:16]
//Arm Width
arm_width = 3;                        // [0.1:10]
//Arm Thickness
arm_thickness = 4;                    // [0.1:10]
//How tall the cylinder below the diffuser cone is
straight_h = 8;                       // [0.1:20]

outer_diameter = flashlight_head_diameter * outer_diameter_ratio;
outer_height   = flashlight_head_diameter * outer_height_ratio;
inner_height   = flashlight_head_diameter * inner_height_ratio;

// --- Fin settings ---
// Set to -1 for auto
fin_count_input = -1;  // [-1:1:200]  // -1 = Auto
//How far the fins protrude from the shade
fin_height = 1.25;                    // [0.1:10]
//How wide the fins are
fin_width = 0.8;                      // [0.1:10]
//Ratio of the distance between the fins and their thickness
gap_multiplier = 1.0;                 // [0.1:10]
fin_depth = outer_height + 2;


// --- Cutout dimensions ---
cutout_width = arm_width;
cutout_height = straight_h / 1.75;
cutout_depth = wall_thickness + 1.5;

// --- Helpers ---
function cone_top_dia(d, h) = d - 2 * h * tan(cone_angle);
function cone_radius_at_z(base_radius, height, z) =
    base_radius - z * tan(cone_angle);

// --- Cutouts between arms ---
module inner_cutouts() {
    radius = (flashlight_head_diameter + wall_thickness) / 2;

    for (i = [0 : 360 / arm_count : 360 - 360 / arm_count]) {
        rotate([0, 0, i + (180 / arm_count)])
            translate([(radius - (wall_thickness / 1.125)), -cutout_width / 2, 0])
                cube([cutout_depth, cutout_width, cutout_height], center = false);
    }
}

// --- Inner cone with 7mm straight base + cutouts in base ---
module inner_cone() {
    outer_dia = flashlight_head_diameter + 2 * wall_thickness;
    top_outer = cone_top_dia(outer_dia, inner_height);
    top_inner = cone_top_dia(flashlight_head_diameter, inner_height);
    taper_h = inner_height - straight_h;

    difference() {
        union() {
            // Bottom straight section
            difference() {
                cylinder(h = straight_h, r = outer_dia / 2);
                cylinder(h = straight_h, r = flashlight_head_diameter / 2);
            }

            // Conical taper above
            difference() {
                translate([0, 0, straight_h])
                    cylinder(h = taper_h,
                             r1 = outer_dia / 2,
                             r2 = top_outer / 2);
                translate([0, 0, straight_h])
                    cylinder(h = taper_h,
                             r1 = flashlight_head_diameter / 2,
                             r2 = top_inner / 2);
            }
        }
        inner_cutouts();
    }

    // Flat cap ring at the top
    translate([0, 0, inner_height - wall_thickness])
        cylinder(d = top_outer, h = wall_thickness);
}


// --- Outer cone ---
module outer_cone() {
    top_outer = cone_top_dia(outer_diameter, outer_height);
    top_inner = cone_top_dia(outer_diameter - 2 * wall_thickness, outer_height);

    difference() {
        cylinder(h = outer_height,
                 r1 = outer_diameter / 2,
                 r2 = top_outer / 2);
        cylinder(h = outer_height,
                 r1 = (outer_diameter - 2 * wall_thickness) / 2,
                 r2 = top_inner / 2);
    }
}

// --- Outer cone vertical fins (dual-trimmed, always embedded in outer cone) ---
module outer_fins() {
    base_radius = outer_diameter / 2;
    embed_depth = wall_thickness / 2;

    desired_gap = gap_multiplier * (fin_width * 1.5);
    desired_arc = fin_width + desired_gap;
    desired_angle = (desired_arc / base_radius) * (180 / PI);

    // Choose fin count: automatic or manual
    auto_count = floor(360 / desired_angle);
    fin_count = (fin_count_input == -1) ? auto_count : fin_count_input;

    angle_step = 360 / fin_count;
    fin_angle = (fin_width / base_radius) * (180 / PI);
    actual_gap_angle = angle_step - fin_angle;

    echo("fin_count = ", fin_count);
    echo("angle_step = ", angle_step);
    echo("fin_angle = ", fin_angle);
    echo("actual_gap_angle = ", actual_gap_angle);

    difference() {
        union() {
            for (i = [0 : fin_count - 1]) {
                angle = i * angle_step - fin_angle / 2;

                rotate([0, 0, angle])
                    translate([base_radius - embed_depth, 0, -1])
                        rotate([0, -cone_angle, 0])
                            cube([fin_height + embed_depth, fin_width, fin_depth + 2], center = false);
            }
        }

        // Trim above and below
        translate([0, 0, outer_height])
            cylinder(h = 10, r = outer_diameter + 5);
        translate([0, 0, -10])
            cylinder(h = 10, r = outer_diameter + 5);
    }
}

// --- Arms ---
module raw_arms() {
    inner_attach_r = (flashlight_head_diameter / 2);
    outer_attach_r = (outer_diameter / 2) - wall_thickness;
    arm_len = outer_attach_r - inner_attach_r;

    union() {
        for (i = [0 : 360 / arm_count : 360 - 360 / arm_count]) {
            rotate([0, 0, i])
                translate([inner_attach_r, -arm_width / 2, 0])
                    cube([arm_len, arm_width, arm_thickness], center = false);
        }
    }
}

module connecting_arms() {
    difference() {
        raw_arms();

        translate([0, 0, -1])
            cylinder(h = arm_thickness + 2,
                     r = flashlight_head_diameter / 2);
    }
}

// --- Final assembly ---
union() {
    inner_cone();
    outer_cone();
    connecting_arms();
    outer_fins();
}
