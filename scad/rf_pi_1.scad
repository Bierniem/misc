circle_res_high = 20;
circle_res_low = 10;



module rubber_band_hook(){
    thickness = 3.5;
    height = 3;
    union(){
        translate([0,0,(height+thickness)/2])cylinder(d=thickness, h=height+thickness, center=true, $fn=100);
        translate([0,(thickness+thickness/3)/2,height+thickness/2])rotate([90,0,0])cylinder(d=thickness, h=thickness+thickness/3, center=true, $fn=100);
    }
}

module ring(id,od,$fn){
    difference(){
        circle(r=od/2, center=true);
        circle(r=id/2, center=true);
    }
}

module pi_mount(){
    via_diameter = 2.6;
    via_pad_diameter = 3.5*2;
    via_dist_short = 23;
    via_dist_long = 58;
    lift = .5;
    pi_height = 10.6+2;
    pi_width = 30;
    pi_len = 65;
    width_plus_connector = 49;
    plate_thickness = 2;
    pi_xy_overhang = 1;
    usb_port_offset = 41.4;
    power_port_offset = 54;
    hdmi_port_offset = 12.4;

    post_0_pos = [via_pad_diameter/2+width_plus_connector-pi_width+pi_xy_overhang/2,via_pad_diameter/2+pi_xy_overhang/2,plate_thickness+lift/2];
    module lift_post(){
        cylinder(lift, d=via_pad_diameter-1, center=true, $fn=100);
    }
    module neg_lift_post(){
        cylinder(lift+10, d1=via_diameter, center=true, $fn=100);
    }
    difference(){
        union(){
            cube([width_plus_connector+pi_xy_overhang,pi_len+pi_xy_overhang,plate_thickness]);
            translate(post_0_pos)lift_post();
            translate(post_0_pos+[via_dist_short,0,0])lift_post();
            translate(post_0_pos+[0,via_dist_long,0])lift_post();
            translate(post_0_pos+[via_dist_short,via_dist_long,0])lift_post();
            // translate([post_0_pos[0]-via_diameter-4,4+pi_len-power_port_offset,plate_thickness])rotate([0,0,-90])rubber_band_hook();
        }
        union(){
            translate(post_0_pos)neg_lift_post();
            translate(post_0_pos+[via_dist_short,0,0])neg_lift_post();
            translate(post_0_pos+[0,via_dist_long,0])neg_lift_post();
            translate(post_0_pos+[via_dist_short,via_dist_long,0])neg_lift_post();
        }
    }
}
module pi_mount_glue_in_lift(){
    via_diameter = 2.6;
    via_pad_diameter = 3.5*2;
    via_dist_short = 23;
    via_dist_long = 58;
    lift = .5;
    pi_height = 10.6+2;
    pi_width = 30;
    pi_len = 65;
    width_plus_connector = 49;
    plate_thickness = 2;
    pi_xy_overhang = 1;
    usb_port_offset = 41.4;
    power_port_offset = 54;
    hdmi_port_offset = 12.4;

    post_0_pos = [via_pad_diameter/2+width_plus_connector-pi_width+pi_xy_overhang/2,via_pad_diameter/2+pi_xy_overhang/2,0];
    module lift_post_slot(){
        cube(size=[via_pad_diameter, via_pad_diameter, 10], center=true);
    }
    module neg_lift_post(){
        cylinder(lift+10, d1=via_diameter, center=true, $fn=100);
    }
    difference(){
        union(){
            cube([width_plus_connector+pi_xy_overhang,pi_len+pi_xy_overhang,plate_thickness]);
            // translate(post_0_pos)lift_post();
            // translate(post_0_pos+[via_dist_short,0,0])lift_post();
            // translate(post_0_pos+[0,via_dist_long,0])lift_post();
            // translate(post_0_pos+[via_dist_short,via_dist_long,0])lift_post();
            // translate([post_0_pos[0]-via_diameter-4,4+pi_len-power_port_offset,plate_thickness])rotate([0,0,-90])rubber_band_hook();
        }
        // union(){
        //     translate(post_0_pos)lift_post_slot();
        //     translate(post_0_pos+[via_dist_short,0,0])lift_post_slot();
        //     translate(post_0_pos+[0,via_dist_long,0])lift_post_slot();
        //     translate(post_0_pos+[via_dist_short,via_dist_long,0])lift_post_slot();
        // }
    }
}

module pi_mount_pin(){
    head_diameter = 3.5*2-1;
    head_thickness = 2;
    shaft_diameter = 2.6-.1;
    shaft_len = 2+1.5;
    union(){
        cylinder(h=head_thickness,d=head_diameter,center=true,$fn=6);
        translate([0,0,head_thickness/2+shaft_len/2])cylinder(h=shaft_len,d=shaft_diameter,center=true,$fn=100);
    }
}
module rtl_mount(){
    case_len=60;
    case_width=17;
    case_height=14.2;
    usb_height=4.5;
    usb_width=12;
    sma_diameter=8.5;
    looseness=.1;
    wall_thickness=2;
    difference(){
        cube([case_len+looseness+wall_thickness*2,case_width+looseness+wall_thickness*2,case_height+looseness+wall_thickness*2]);
        translate([0,wall_thickness+looseness,wall_thickness+looseness])union(){
            cube([case_len+looseness+wall_thickness,case_width+looseness,case_height+looseness]);
            translate([wall_thickness,(case_width+looseness)/2,(case_height+looseness)/2])rotate([0,90,0])cylinder(d=sma_diameter+looseness,h=case_len+wall_thickness*2,$fn=100);
        }
    }
}
module rtl_mount_retention(){
    translate([0,(case_width+looseness-usb_width)/2,(case_height-usb_height+looseness)/2])cube([wall_thickness*2,usb_width+looseness,usb_height+looseness]);
}
module battery_mount(){
    // a tube we can intersect with something else to stick them together,
    // include a modeled in end and retention ring
    batt_diameter = 22;
    batt_len = 106.9;
    wall_thickness = 2;
    looseness = .2;
    retention_ring_looseness=.1;
    // union(){
    //     translate([0,0,wall_thickness/2])ring(id=batt_diameter+looseness-wall_thickness,od=batt_diameter+looseness,height=wall_thickness,$fn=100);
    //     translate([0,0,(batt_len+looseness+wall_thickness*2)/2])ring(id=batt_diameter+looseness,od=batt_diameter+looseness+wall_thickness,height=batt_len+looseness*2+wall_thickness*2,%fn=100);
    // }
    union(){
        linear_extrude(wall_thickness)ring(id=batt_diameter+looseness-wall_thickness,od=batt_diameter+looseness+wall_thickness/2,$fn=100);
        linear_extrude(batt_len+looseness+wall_thickness*2)ring(id=batt_diameter+looseness,od=batt_diameter+looseness+wall_thickness,$fn=100);
    }
    // }
}
module battery_mount_retention_ring(){
    // maybe add a rubber band hook
    batt_diameter = 22;
    batt_len = 106.9;
    wall_thickness = 2;
    looseness = .1;
    retention_ring_looseness=.1;
    // union(){
    //     linear_extrude(wall_thickness)ring(id=batt_diameter+looseness,$fn=100);
    //     // maybe as a notch in the ring? or as a hook on the tube?
    // }
}
module battery_relief(){
    batt_diameter = 27;
    batt_len = 106.9;
    batt_face_inset = 2.5;
    batt_face_clear_dist = 75;
    looseness = 0.1;
    translate([0,0,-batt_face_clear_dist/2])linear_extrude(batt_face_clear_dist)circle(d=batt_diameter-batt_face_inset*2,$fn=circle_res_high);
    linear_extrude(batt_len+looseness*2)circle(d=batt_diameter+looseness*2,$fn=circle_res_high);
}
module rtl_relief(){
    rtl_height=14.5;
    rtl_width=17.3;
    rtl_len=60.6;
    looseness=0.1;
    sma_bare_threads_len=4.1;
    lock_washer=1;
    sma_bare_threads_diameter=6.2;
    sma_connector_diameter=7.8;
    bulkhead_thickness=3;
    rtl_to_bulkhead_external=34.3;
    rtl_to_bulkhead=rtl_to_bulkhead_external-bulkhead_thickness;
    rtl_to_connector=6.7;
    bulkhead_to_connector=10;
    linear_extrude(rtl_len+looseness*2+50)square(size=[rtl_height+looseness*2, rtl_width+looseness*2], center=true);
    translate([0,0,-sma_bare_threads_len])linear_extrude(sma_bare_threads_len)circle(d=sma_bare_threads_diameter+looseness,center=true,$fn=circle_res_high);
    // clear area to access sma connector
    translate([0,0,-rtl_to_bulkhead])linear_extrude(rtl_to_bulkhead-sma_bare_threads_len)hull(){
        circle(d=rtl_width,$fn=circle_res_low);
        translate([0,10,0])circle(d=rtl_width,$fn=circle_res_low);
    }
    //clear out usb area
    
    // translate([0,0,rtl_len+looseness])linear_extrude(50)hull(){
    //     circle(d=rtl_width,$fn=circle_res_low);
    //     translate([0,10,0])circle(d=rtl_width,$fn=circle_res_low);
    // }

}
module pi_board_shape(){
    minkowski_diameter=7;
    base_len=65;
    base_width=30;
    minkowski(){
        circle(d=minkowski_diameter,$fn=circle_res_high);
        square([base_len-minkowski_diameter,base_width-minkowski_diameter]);
    }
}
module pi_relief(){
    minkowski_diameter=6;
    base_len=65;
    base_width=30;
    hdmi_port_offset=12.4;
    usb_port_offset=41.4;
    power_port_offset=54;
    via_inset=3.5;
    lift_pad_radius=4.4;
    height=10;
    bottom_clear_height=.5;
    board_thickness=1.3;
    clear_height_above_board=13;
    looseness=.1;
    pin_len=3;
    pin_radius=1.3;
    ribbon_guard_width=20;
    ribbon_guard_overhang=2.5;
    cable_min_width = 48.4-base_width;
    usb_housing_standoff = 3;
    cable_channel_len=base_len+30;
    cable_channel_width = 20;
    cable_channel_height=10;
    cable_channel_height_extra=10;
    // area for stuff on bottom
    linear_extrude(bottom_clear_height)difference(){
        pi_board_shape();
        union(){
            circle(r=lift_pad_radius);
            translate([base_len-via_inset*2,0,0])circle(r=lift_pad_radius);
            translate([base_len-via_inset*2,base_width-via_inset*2,0])circle(r=lift_pad_radius);
            translate([0,base_width-via_inset*2,0])circle(r=lift_pad_radius);
        }
    }
    // area for board
    translate([0,0,bottom_clear_height])linear_extrude(board_thickness+clear_height_above_board)minkowski(){
        pi_board_shape();
        square(looseness);
    }
    // add holes for pins
    translate([0,0,-pin_len+bottom_clear_height])
    linear_extrude(pin_len)union(){
        circle(r=pin_radius,$fn=circle_res_low);
        translate([base_len-via_inset*2,0,0])circle(r=pin_radius,$fn=circle_res_low);
        translate([base_len-via_inset*2,base_width-via_inset*2,0])circle(r=pin_radius,$fn=circle_res_low);
        translate([0,base_width-via_inset*2,0])circle(r=pin_radius,$fn=circle_res_low);
    }
    // area for sd_card and ribbon protector
    translate([-ribbon_guard_overhang-via_inset,via_inset/2,bottom_clear_height+board_thickness])linear_extrude(board_thickness+cable_channel_height+cable_channel_height_extra)square([base_len+ribbon_guard_overhang*2,ribbon_guard_width]);
    // cable channel
    translate([base_len-cable_channel_len-via_inset-4,base_width+cable_channel_width+usb_housing_standoff-via_inset,bottom_clear_height+board_thickness-cable_channel_height/2+cable_channel_height_extra/2-4])rotate([0,0,270])linear_extrude(cable_channel_height+cable_channel_height_extra)square([cable_channel_width+usb_housing_standoff,cable_channel_len]);
}

module component_reliefs(){
    //line these up so they don't interfere with eachother
    translate([44.9,-10,14.5])pi_relief();
    translate([.4,.5,.5])rotate([0,90,0])battery_relief();
    translate([76.2,22,1])rotate([-90,0,180])rotate([0,90,0])rtl_relief();
}

module component_shadow(){
    hull(){
        linear_extrude(.1)projection()rotate([0,90,0])component_reliefs();
        translate([0,0,100])rotate([0,90,0])component_reliefs();
    }
    
}

module component_container(){
    linear_extrude(65)minkowski(){
        square([31,45]);
        circle(r=5,$fn=circle_res_high);
    }
    translate([10,10,0])linear_extrude(109)circle(d=30);
}

module component_assembly(){
    difference(){
        translate([-9,-9.5,0])component_container();
        translate([0,0,107.5])rotate([0,90,0])component_reliefs();
    }
}

module case(){
    // shroud + ports for sma bulkhead, usb bulkhead, led(s), button
}
component_assembly();
// battery_relief();
// rtl_relief();
// pi_relief();
// assembly_internals_case();
// pi_mount();
// translate([-10,-10,0])pi_mount_pin();
// rubber_band_hook();
//battery_mount();
// rtl_mount();