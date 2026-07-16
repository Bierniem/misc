$fn=100;
// maybe for the allowance do a +- on the number and sum the parts that result?

module servo_9g(allowance=0,pins=0,horn=0,cable_exit_len=5){
    servo_horn_height=6;
    drive_shaft = 4.7;
    drive_shaft_round = 11.5;
    drive_shaft_round_inset = 15.1-14.8;
    drive_shaft_round_2 = 5.8;
    drive_shaft_round_plus_round_2 = 14.7;
    
    height_with_drive_shaft = 30.2;
    height_with_drive_shaft_round = 27.3;
    height_main_body = 23.2;
    depth_main_body = 12.1;
    width_main_body = 23;
     
    flange_thickness = 2.4;
    width_with_flange = 32.6;
    flange_height = 19.8;
    flange_mount_hole_distance = 25.9;
    flange_mount_hole_diameter = 2.1;

    // cable exit is big enough for connector
    cable_exit_height = 6;
    cable_exit_width = 7.9;
    cable_exit_thickness = 2.9; // *2 for the allowance taken up by height
    module servo_part(allowance){
        if(horn>0){
            linear_extrude(servo_horn_height)circle(d=max(horn,drive_shaft+allowance));
        }
        else{
            linear_extrude(height_with_drive_shaft-height_with_drive_shaft_round)circle(d=max(drive_shaft+allowance));
        }
        translate([0,0,-(height_with_drive_shaft_round-height_main_body)])linear_extrude(height_with_drive_shaft_round-height_main_body)circle(d=drive_shaft_round+allowance);
        translate([drive_shaft_round_plus_round_2-drive_shaft_round/2-drive_shaft_round_2/2,0,-(height_with_drive_shaft_round-height_main_body)])linear_extrude(height_with_drive_shaft_round-height_main_body)circle(d=drive_shaft_round_2+allowance);
        translate([width_main_body/2-drive_shaft_round/2-drive_shaft_round_inset,0,-height_with_drive_shaft_round])linear_extrude(height_main_body+allowance)square([width_main_body+allowance,depth_main_body+allowance],center=true);
        translate([width_main_body/2-drive_shaft_round/2-drive_shaft_round_inset,0,-height_with_drive_shaft_round+flange_height-flange_thickness])
        {
            difference(){
                linear_extrude(flange_thickness+allowance)square([width_with_flange+allowance,depth_main_body+allowance],center=true);
                union(){
                    translate([flange_mount_hole_distance/2,0,-.0005])linear_extrude(flange_thickness+.001+allowance)circle(d=flange_mount_hole_diameter+allowance);
                    translate([-flange_mount_hole_distance/2,0,-.0005])linear_extrude(flange_thickness+.001+allowance)circle(d=flange_mount_hole_diameter+allowance);
                }
            }
            if(pins!=0){
                color("red",.2)translate([flange_mount_hole_distance/2,0,-.0005-max(0,pins)])linear_extrude(flange_thickness+.001+allowance+abs(pins))circle(d=flange_mount_hole_diameter);
                color("red",.2)translate([-flange_mount_hole_distance/2,0,-.0005-max(0,pins)])linear_extrude(flange_thickness+.001+allowance+abs(pins))circle(d=flange_mount_hole_diameter);
            }
        }
            
    translate([-cable_exit_len/2-drive_shaft_round/2-drive_shaft_round_inset,0,-height_with_drive_shaft_round+cable_exit_height-cable_exit_thickness])linear_extrude(cable_exit_thickness+allowance)square([cable_exit_len,cable_exit_width+allowance],center=true);
    }
    servo_part(allowance);
    // servo_part(-1*allowance);
}


module gears_p5M(){
    // 0.5Mod Gear 13T-27T for HOBBYWING Motors
    bore_diameter = 3.175;
    height = 7;
    rad_per_t = 1.65888;
    diameter_13T = 6.2;
    diameter_14T = 7.6;
    diameter_15T = 8.3;
    diameter_16T = 8.6;
    diameter_17T = 9.3;
    diameter_18T = 9.6;
    diameter_19T = 9.6;
    // diameter
    diameter_21T = 11.1;
    diameter_22T = 11.6;
    diameter_25T = 13.2;
    diameter_26T = 13.7;
    diameter_27T = 14.2;
}


servo_9g(allowance=.5);

