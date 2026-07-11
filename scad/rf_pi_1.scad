circle_res_high = 20;
circle_res_low = 10;

bulkhead_thickness = 3;
/*
Print1
* try to add the minimum retention to the individual objects. 
like the tube should be part of the battery so it gets moved together.
    * did the battery.. kinda, added the mount and just copy the transformations
* reduce the cutouts around the pi for wiring so the pi is retained better. 
* add more room for the headers on the pi so I can route wires out for leds/etc
* consider making the wire space for the pi have a bridge over it to help retain 
the sled in the case
* the cable/usb adapter relief is wider than it needs to be, and so the sled is
> 5mm wider than it needs to be
* 2" thin walled pvc might still fit it if I wanted to make a waterproof version 
but I need to consider how to access the sma
* make the sma access area slightly conical/sloped/self supported to not need supports
    *done
* make the battery retention lip slightly conical to not need supports
    * done
* it's still a lot higher layer resolution than it probably needs to be printed at
Print 2
resize a bunch so stuff fits...
Print 3
* open up the cable channel more to allow better access to the button for assembly
maybe by reducing the width of the usb bridge
* reduce the bulkhead thickness at the cable channel, its like 5mm currently
* open up the access to the sma adapter assembly consider turning the rtl flat 
if there's space(width) to get the sma closer to the bottom
* increase the diameter of the sma connecter max for the barrel to pass through
    * done
* move the led towards the face to get it out from under the button
    * done moved up 2mm
* add grippy texture to the outside surface
    * maybe later it's difficult
* design around 90 degree usbc adapter instead
    * done
* add spring button to hold shell to assembly
After first petg print... 
* reduce the depth of the grips 
    * done 2mm->1mm
* make the usb 90degree holder tight against the aluminum part male part for better retention and no tiny bridge
    * done
* widen the usb access through the case
    * done 8.3->8.5mm
* shorten the case when I know how much shorter the custom usb will allow
* add ziptie holddown for the usb 90 and make it slightly looser
    # 1 ziptie for both!
* add ziptie holddown for the battery and make it slightly looser
    * 1 ziptie for both!
*/




module pi_mount_pin(){
    head_diameter = 3.5*2-1;
    head_thickness = 2;
    // shaft_diameter = 2.6-.1;
    shaft_len = 2+1.5;
    union(){
        cylinder(h=head_thickness,d=head_diameter,center=true,$fn=6);
        translate([0,0,head_thickness/2+shaft_len/2])cylinder(h=shaft_len,d=shaft_diameter,center=true,$fn=100);
    }
}

module battery_mount(){

    // a tube we can intersect with something else to stick them together,

    batt_diameter = 27;
    batt_len = 106.9;
    wall_thickness = 2.5;
    batt_face_clear_dist = 75;
 
    union(){
        translate([0,0,-wall_thickness])linear_extrude(batt_len+wall_thickness)circle(d=batt_diameter+wall_thickness*2,$fn=circle_res_high);
    }

}

module battery_relief(){
    batt_diameter = 27+.5;
    batt_len = 106.9+1;
    batt_face_inset = 2.5;
    batt_face_clear_dist = 75;
    //minimum clear area of face
    translate([0,0,-batt_face_clear_dist/2])linear_extrude(batt_face_clear_dist)circle(d=batt_diameter-batt_face_inset*2,$fn=circle_res_high);
    // body of battery
    linear_extrude(batt_len)circle(d=batt_diameter,$fn=circle_res_high*2);
    //chamfer for print overhang
    translate([0,0,-1])cylinder(h=1,d1=batt_diameter-batt_face_inset*2,d2=batt_diameter,$fn=circle_res_high);
}

module rtl_relief(){
    rtl_height=14.5;
    rtl_width=17.3;
    rtl_len=60.6;
    looseness=0.1;
    sma_bare_threads_len=4.1;
    lock_washer=1;
    sma_bare_threads_diameter=6.5;
    sma_connector_diameter=7.8;
    sma_connector_max_diameter=9+0.75;
    rtl_to_bulkhead_external=34.3;
    rtl_to_bulkhead=rtl_to_bulkhead_external-bulkhead_thickness;
    rtl_to_connector=6.7;
    bulkhead_to_connector=10;
    overhang_z=1.5;
    bulkhead_dist_play=1.5; // makes the square area for the rtl a little closer to the bulkhead
    translate([0,0,-bulkhead_dist_play])linear_extrude(rtl_len+looseness*2+50)square(size=[rtl_height+looseness*2, rtl_width+looseness*2], center=true);
    // sma via
    translate([0,0,-sma_bare_threads_len])linear_extrude(sma_bare_threads_len)circle(d=sma_connector_max_diameter,,$fn=circle_res_high);
    // clear area to access sma connector, add slope to help printer overhang
    rotate([0,0,-90]){
        translate([0,0,-rtl_to_bulkhead])linear_extrude(rtl_to_bulkhead-overhang_z-sma_bare_threads_len)hull(){    
        circle(d=rtl_width,$fn=circle_res_low);
        translate([0,20,0])circle(d=rtl_width,$fn=circle_res_low);
        }
        for(i=[0:1:20])translate([0,i,-sma_bare_threads_len-overhang_z])cylinder(h=overhang_z,d1=rtl_width,d2=sma_connector_max_diameter,$fn=circle_res_low); 
    }
    // translate([0,i,-sma_bare_threads_len-overhang_z])linear_extrude(overhang_z,scale=[1,.1,1])hull(){    
    //         circle(d=rtl_width,$fn=circle_res_low);
    //         translate([0,20,0])circle(d=rtl_width,$fn=circle_res_low);
    // }
    
    // sma through bulkhead
    translate([0,0,-rtl_to_bulkhead_external])linear_extrude(bulkhead_thickness)circle(d=sma_bare_threads_diameter+looseness,,$fn=circle_res_high);
    
    //clear out usb area
    
    // translate([0,0,rtl_len+looseness])linear_extrude(50)hull(){
    //     circle(d=rtl_width,$fn=circle_res_low);
    //     translate([0,10,0])circle(d=rtl_width,$fn=circle_res_low);
    // }

}
module pi_board_shape(){
    minkowski_diameter=7+0.3;
    base_len=65+1.75;//z compression :C
    base_width=30+1;
    minkowski(){
        circle(d=minkowski_diameter,$fn=circle_res_high);
        square([base_len-minkowski_diameter,base_width-minkowski_diameter]);
    }
}
module pi_relief(){

    base_len=65+1.75;
    base_width=30+1;
    hdmi_port_offset=12.4;
    usb_port_offset=41.4;
    power_port_offset=54;
    via_inset=(7+0.3)/2;
    lift_pad_radius=4.4;
    height=10;
    bottom_clear_height=.5;
    board_thickness=1.3;
    clear_height_above_board=12;
    looseness=.1;
    pin_len=3;
    pin_radius=1.3;
    ribbon_guard_width=20;
    ribbon_guard_overhang=2.5;
    cable_min_width = 50-base_width;
    usb_housing_standoff = 2;
    cable_channel_len=base_len+18+7;
    cable_channel_width = cable_min_width-usb_housing_standoff;
    cable_channel_height=30;
    cable_channel_offset_down = 5;
    usb_access_height = 7;
    usb_access_width = 12.6;
    hdmi_access_width = 16;
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
    translate([-ribbon_guard_overhang-via_inset,via_inset/2,bottom_clear_height+board_thickness])linear_extrude(clear_height_above_board)square([base_len+ribbon_guard_overhang*2,ribbon_guard_width]);
    // cable channel
    // translate([base_len-cable_channel_len-via_inset-4,base_width+cable_channel_width+usb_housing_standoff-via_inset,bottom_clear_height+board_thickness-cable_channel_height/2+cable_channel_height_extra/2-4])rotate([0,0,270])linear_extrude(cable_channel_height+cable_channel_height_extra)square([cable_channel_width+usb_housing_standoff,cable_channel_len]);
    translate([2.5-cable_channel_len+base_len-via_inset,base_width+usb_housing_standoff-via_inset,-usb_access_height/2+board_thickness-cable_channel_offset_down])linear_extrude(cable_channel_height)square([cable_channel_len,cable_channel_width]);
    // slope so it's easier to print overhangs
    translate([-5+2.5-cable_channel_len+base_len-via_inset,base_width+usb_housing_standoff-via_inset,-usb_access_height/2+board_thickness-cable_channel_offset_down])linear_extrude(cable_channel_height)polygon([[5,0],[5,cable_channel_width],[0,cable_channel_width]]);
    // usb access
    translate([-via_inset+base_len-usb_port_offset-usb_access_width/2,base_width-via_inset,-usb_access_height/2+board_thickness])linear_extrude(usb_access_height+5)square(size=[usb_access_width,usb_housing_standoff]);
    // power access
    translate([-via_inset+base_len-power_port_offset-usb_access_width/2,base_width-via_inset,-usb_access_height/2+board_thickness])linear_extrude(usb_access_height+5)square(size=[usb_access_width,usb_housing_standoff]);
    // hdmi access
    translate([-via_inset+base_len-hdmi_access_width-usb_access_width/2,base_width-via_inset,-usb_access_height/2+board_thickness])linear_extrude(usb_access_height+5)square(size=[hdmi_access_width,usb_housing_standoff]);
    // button through bulkhead lines up with cable channel
    button_stem_diameter = 13.2+.3;
    button_stem_len = 14; //includes some space for the wires... but this isn't really lined up with the bulkhead...:C
    translate([base_len-via_inset,-1.5+base_width+usb_housing_standoff-via_inset+button_stem_diameter/2+(cable_channel_width-button_stem_diameter),-usb_access_height/2+board_thickness+button_stem_diameter/2-cable_channel_offset_down+1])rotate([0,90,0])linear_extrude(button_stem_len*2)circle(d=button_stem_diameter,$fn=circle_res_high);
    // led through bulkhead lines up with cable channel
    led_diameter = 5.3;
    led_collar_diameter = 5.5;
    translate([base_len-via_inset,base_width/3-via_inset+led_diameter/2+1,board_thickness+led_diameter+1])rotate([0,90,0])linear_extrude(button_stem_len*2)circle(d=led_diameter,$fn=circle_res_high);
}

module usb_90_degree(){
    len_a = 22.5 +.6;
    width_a = 12.6 +.6;
    height_a = 6.6 +.6;
    gap_to_connector=1.5;
    len_b = 8 + height_a/2 -.1;
    width_b = 10.5 +.6;
    height_b = 5.3 +.6;
    usbc_height = 2.5 +.6;
    usbc_width = 8.5 +.6;
    connector_height = 7.2 +.6;
    connector_len = 35;


    //the aluminum part a
    
    linear_extrude(len_a)hull(){
        translate([-(width_a-height_a)/2,0,0])circle(d=height_a,$fn=circle_res_high);
        translate([(width_a-height_a)/2,0,0])circle(d=height_a,$fn=circle_res_high);
    }
    //the plastic part b
    translate([0,0,2+height_b/2])rotate([90,0,0]){
        linear_extrude(len_b)hull(){
            translate([-(width_b-height_b)/2,0,0])circle(d=height_b,$fn=circle_res_high);
            translate([(width_b-height_b)/2,0,0])circle(d=height_b,$fn=circle_res_high);
        }
        //the connector plugged into b

        translate([0,0,len_b])linear_extrude(connector_len)hull(){
            translate([-(width_a-connector_height)/2,0,0])circle(d=connector_height,$fn=circle_res_high);
            translate([(width_a-connector_height)/2,0,0])circle(d=connector_height,$fn=circle_res_high);
        }
    }
    //the connector plugged into a
    translate([0,0,len_a])linear_extrude(gap_to_connector)hull(){
        translate([-(usbc_width-usbc_height)/2,0,0])circle(d=usbc_height,$fn=circle_res_high);
        translate([(usbc_width-usbc_height)/2,0,0])circle(d=usbc_height,$fn=circle_res_high);
    }
    translate([0,0,len_a+gap_to_connector])linear_extrude(connector_len)hull(){
        translate([-(width_a-connector_height)/2,0,0])circle(d=connector_height,$fn=circle_res_high);
        translate([(width_a-connector_height)/2,0,0])circle(d=connector_height,$fn=circle_res_high);
    }

}

module spring_button(){
    length = 25;
    thickness = 1.5;
    button_diameter = 5;
    difference(){
        sphere(d=button_diameter,$fn=circle_res_high);
        translate([button_diameter/2,0,0])cube([button_diameter,button_diameter,button_diameter],center=true);
    }
    rotate([0,90,0])hull(){
        circle(d=button_diameter);
        translate([0,length,0])circle(d=button_diameter);
        translate([length/10,length,0])circle(d=button_diameter);
    }
}

module screw_and_nut(){
    nut_size = 6.3+.3; //point to point
    nut_depth = 2.3+.7;
    screw_diameter = 3+.3;
    linear_extrude(nut_depth)circle(d=nut_size,$fn=6);
    translate([0,0,-3])linear_extrude(12)circle(d=screw_diameter,$fn=circle_res_high);
}

module usb_90_degree_container(part,container,relief){
    len_a = 22.5 +.6;
    width_a = 12.6 +.6;
    height_a = 6.6 +.6;
    gap_to_connector=1.5;
    full_len_b = 14.5;
    len_b = 8 + height_a/2 +.5;
    width_b = 10.5 +.6;
    height_b = 5.3 +.6;
    usbc_height = 2.5 +.6;
    usbc_width = 8.5 +.6;
    connector_height = 7.2 +.6;
    connector_len = 35;
    minkowski_diameter = 2.5;

    if(container){
        difference(){
            difference(){
                translate([0,-height_a/2,-2]){
                    linear_extrude(len_a+2+gap_to_connector)minkowski(){
                        circle(d=minkowski_diameter,$fn=circle_res_high);
                        square([width_a,full_len_b-minkowski_diameter/2],center=true);
                    }
                }
                linear_extrude(len_a)hull(){
                    hull(){
                        translate([-(width_a-height_a)/2,0,0])circle(d=height_a,$fn=circle_res_high);
                        translate([(width_a-height_a)/2,0,0])circle(d=height_a,$fn=circle_res_high);
                        translate([-(width_a-height_a)/2,height_a,0])circle(d=height_a,$fn=circle_res_high);
                        translate([(width_a-height_a)/2,height_a,0])circle(d=height_a,$fn=circle_res_high);
                    }
                }
            }
        usb_90_degree();
        // ziptie
        if(!relief){
            translate([0,-9,16])linear_extrude(5)
            difference(){
                square([16,6],center=true);
                minkowski(){
                    // translate([0,2])square([10,2],center=true);
                    polygon(points=[[-5,1],[5,1],[7,3],[-7,3]]);
                    circle(d=minkowski_diameter,$fn=circle_res_high);
                }
                
            }
        //    translate([0,-11.5+3+.3,16])rotate([90,0,0])linear_extrude(3.3+.3)square([16,5],center=true); 
        }
        //magnet
        // translate([0,-11.5+1.7+.3+1.8,18])rotate([90,0,0])linear_extrude(3.3+.3)circle(d=8+0.5);
        // cutout so the case thick section comes up higher?
        // translate([0,-11.5+1.7+.3,18])rotate([90,0,0])linear_extrude(3.3+.3)square(16,center=true);
        // screw and nut
        // translate([0,-8.5,17])rotate([90,0,0])screw_and_nut();
        }
        // a connector since I had to move it to clear the wires
        translate([0,-height_a/2,-20]){
            linear_extrude(20)minkowski(){
                circle(d=minkowski_diameter,$fn=circle_res_high);
                square([width_a,full_len_b-minkowski_diameter/2],center=true);
            }
        }
    }
    if(part){
        color("red",.1)usb_90_degree();
        //magnet and step
        // translate([0,-11.5+1.7+1.8,18])rotate([90,0,0])linear_extrude(3.3+.3)circle(d=8+0.5);
        // translate([0,-8,18])rotate([90,0,0])linear_extrude(3.3+.3)square(16,center=true);
        // translate([0,-8.5,17])rotate([90,0,0])color("red",.1)screw_and_nut();
    }
} 

module component_reliefs(){
    //line these up so they don't interfere with eachother
    translate([42.5,-8,14])pi_relief();
    translate([.5,1.6,1])rotate([0,90,0])battery_relief();
    translate([76.3,29,-4])rotate([0,0,180])rotate([0,90,0])rtl_relief();
}
module component_min_container(){
    // translate([.5,1.6,2])rotate([0,90,0])battery_mount();
}

module component_shadow(){
    hull(){
        linear_extrude(.1)projection()rotate([0,90,0])component_reliefs();
        translate([0,0,100])rotate([0,90,0])component_reliefs();
    }
    
}

module component_container(){
    linear_extrude(73)minkowski(){
        square([29.5,45]);
        circle(r=5,$fn=circle_res_high);
    }
    // translate([10,10,0])linear_extrude(109)circle(d=30);
}
module bulkhead_plate(){
    linear_extrude(bulkhead_thickness)minkowski(){
        square([29.5,45]);
        circle(r=5,$fn=circle_res_high);        
    }
}
module component_assembly(parts,containers){
    
    translate([9,9.5,bulkhead_thickness])difference(){
        union(){
            
            translate([-9,-9.5,0])component_container();
            translate([-9,-9.5,-bulkhead_thickness])bulkhead_plate();
            translate([0,0,107.5])rotate([0,90,0])component_min_container();    
            translate([14.08,19,93])rotate([0,0,90])usb_90_degree_container(parts,containers);

        }
        translate([0,0,107.5])rotate([0,90,0])component_reliefs();
        // dimples for the case to hold
        translate([5,42.9-2,5])sphere(d=5,$fn=circle_res_high);
        translate([5,-16.9+2,5])sphere(d=5,$fn=circle_res_high);
    }
    // a little insert to support the usb thing
    //translate([9,9.5,bulkhead_thickness])translate([10,18.8,73.2])rotate([0,90,0])linear_extrude(15)polygon([[0,0],[0,8],[1,8],[3,0]]);
    

}


module case(negatives,positives){
    internal_case_len = 160;
    bottom_thickness = 2;
    component_assembly_len = 73;
    usb_bulkhead_diameter = 23.8+.5;
    case_square_size = [29.5,45];
    case_outer_minkowski_diameter = 6.65;
    if(positives){
        color("yellow",.1)
        difference(){
            union(){
                // the normal case, will add features for grippyness
                translate([6.65,6.65,0])linear_extrude(internal_case_len+bottom_thickness)minkowski(){
                    square(case_square_size);
                    circle(r=6.65,$fn=circle_res_high);
                }

            }
            union(){
                //hollow inside for assembly
                translate([6.65,6.65,0])linear_extrude(internal_case_len)minkowski(){
                    square(case_square_size);

                    circle(r=5.15-1.5,$fn=circle_res_high);        
                }
                translate([6.65,6.65,-internal_case_len+component_assembly_len+13.2+35])linear_extrude(internal_case_len)minkowski(){
                    // square([29.5,45]);
                    // let the short sides touch the component assembly in the middle
                    polygon([
                        [0,0],
                        [case_square_size[0]/2-6,0],
                        [case_square_size[0]/2-5,1],
                        [case_square_size[0]/2+5,1],
                        [case_square_size[0]/2+6,0],
                        [29.5,0],
                        [29.5,45],
                        // [case_square_size[0]/2+6,45],
                        // [case_square_size[0]/2+5,43.5],
                        // [case_square_size[0]/2-5,43.5],
                        // [case_square_size[0]/2-6,45],
                        [0,45]
                        ]);
                    circle(r=5.15,$fn=circle_res_high);        
                }
                translate([6.65,6.65,0])component_assembly(parts=true,containers=true);
                // grippyness

                total_case_x = case_square_size[0]+case_outer_minkowski_diameter;

                for(i = [total_case_x/5:total_case_x/5:total_case_x]){
                    echo(str("i", i));
                    translate([i,0,3])linear_extrude(internal_case_len-5)square([2,1],center=true);
                }
                for(i = [total_case_x/5:total_case_x/5:total_case_x]){
                    echo(str("i", i));
                    translate([i,case_square_size[1]+case_outer_minkowski_diameter*2,3])linear_extrude(internal_case_len-5)square([2,1],center=true);
                }
                // for(i=[0:1:20])linear_extrude(internal_case_len-component_assembly_len)translate([6.65,3,0])square([1,3]);
                // translate([-10,-10,142])rotate([5,0,0])linear_extrude(10)square([70,70]);
            }
        }  

    }
    if(negatives){
        color("red",.2)translate([6.65,6.65,0])component_assembly(parts=true,containers=false);
    }
    // bottom with port for usb bulkhead offset to open side
    // shroud + ports for sma bulkhead, usb bulkhead, led(s), button
}

// translate([6.65,6.65,-5])component_assembly(parts=false,containers=true);
// translate([0,0,100])usb_90_degree();
// difference(){
// usb_90_degree_container(part=true,container=true);
//     union(){
//         usb_90_degree();
//     }
// }
//spring_button();
// component_reliefs();
translate([70,0,0])component_assembly(parts=false,containers=true);
// translate([0,0,component_assembly_len])linear_extrude(internal_case_len-component_assembly_len)square([1,3]);
case(negatives=false,positives=true);


                
     
// difference(){
//     battery_mount();
//     battery_relief();
// }
// rtl_relief();
// pi_relief();
// assembly_internals_case();
// pi_mount();
// translate([-10,-10,0])pi_mount_pin();
//battery_mount();
// rtl_mount();