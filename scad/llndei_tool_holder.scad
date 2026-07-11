use <slide_top_case_blank.scad>;
circle_resolution_high = 36;
circle_resolution_low = 12;
touch_tolerance = .5;
$fn = circle_resolution_high;
/* 
from print 1
* add bumps to the slide channels
    * done
* widen the ratchet holder
    * done
* widen the box body for the ratchet
    * done
* lengthen the extension socket
    * done 12 -> 15
* reduce the height of the extension holder it will be hard to get out
    * done
* add bit holders where they fit? -- some smaller allen keys might be in order
    * done
* check bikes / manuals make sure I wont want the smaller sockets
    * added 2 more slots for smaller sockets
from print 2
* consider reducing box top thickness

*/

// llndei tool holder
screwdriver_length = 128;

ratchet_len = 137.5+touch_tolerance;
ratchet_handle_diameter = 13 + touch_tolerance;
ratchet_head_width = 31 + touch_tolerance;
ratchet_head_wide_len = 25;
ratchet_head_len = 37;
ratchet_head_narrow_width = 11;
ratchet_head_depth = 13.3 + touch_tolerance;    
ratchet_head_depth_with_selector = 14.5 + touch_tolerance;
ratchet_head_depth_with_button = 15.6+touch_tolerance;
ratchet_head_depth_with_button_and_square = 24.5+touch_tolerance;
ratchet_selector_channel_width = 14;
ratchet_handle_to_button = 120;
ratchet_handle_to_selector = 108;
ratchet_handle_to_drive = 119.5;
ratchet_button_diameter = 8+touch_tolerance;

socket_len = 25.5;
stacked_socket_len = 40.4;
sockets_diameters = [
    19.8+touch_tolerance,
    17.9+touch_tolerance,
    16.9+touch_tolerance,
    15.7+touch_tolerance,
    14.8+touch_tolerance,
    13.2+touch_tolerance, //stackable
    11.9+touch_tolerance, //stackable
    ];
num_sockets = len(sockets_diameters);

extension_len = 75+touch_tolerance;
extension_socket_diameter = 12.4+touch_tolerance;
extension_socket_len = 15+touch_tolerance;
extension_body_diameter = 8.2+touch_tolerance;
extension_square_diameter = 8.5+touch_tolerance;
extension_square_len = 8;

bit_len = 25.6;
bit_top_len = 11;
bit_diameter = 7.2+touch_tolerance;

// Sums all elements in array 'v'
function sum_array(v, end=len(v), i=0, acc=0) = 
    i < end ? sum_array(v, i+1, acc + v[i]) : acc;

module ratchet(positive,negative){
    if(positive){
        color("red",.2){
            //handle
            linear_extrude(ratchet_len)circle(d=ratchet_handle_diameter);
            //head
            translate([0,ratchet_head_depth/2,ratchet_head_width/2])rotate([90,0,0])
            linear_extrude(ratchet_head_depth)hull(){
                circle(d=ratchet_head_width);
                translate([0,-ratchet_head_wide_len+ratchet_head_width,0])circle(d=ratchet_head_width);
                translate([0,ratchet_head_len-ratchet_head_narrow_width,0])circle(d=ratchet_head_narrow_width);
            }
            //selector
            translate([0,ratchet_head_depth/2+ratchet_head_depth_with_selector-ratchet_head_depth,ratchet_len-ratchet_handle_to_selector])rotate([90,0,0])
            linear_extrude(ratchet_head_depth_with_selector-ratchet_head_depth)hull(){
                circle(d=ratchet_selector_channel_width);
                translate([0,ratchet_selector_channel_width/2,0])circle(d=ratchet_selector_channel_width);
            }
            // button
            translate([0,ratchet_head_depth/2+ratchet_head_depth_with_button-ratchet_head_depth,ratchet_len-ratchet_handle_to_button-ratchet_button_diameter/2])rotate([90,0,0])
            linear_extrude(ratchet_head_depth_with_button-ratchet_head_depth){
                circle(d=ratchet_button_diameter);
            }
            // square bit/drive
            translate([0,-ratchet_head_depth/2,ratchet_len-ratchet_handle_to_drive-extension_square_diameter/2])rotate([90,0,0])
            linear_extrude(ratchet_head_depth_with_button_and_square-ratchet_head_depth_with_button)hull(){
                circle(d=extension_square_diameter);
            }
        }
    }
}

module socketsA(positive,negative){
    if(positive)
    {
        color("red",.2){
            // start at 8mm
            translate([0,0,0])linear_extrude(socket_len)circle(d=sockets_diameters[0]);
            translate([0,0,socket_len])linear_extrude(53.1-socket_len)circle(d=sockets_diameters[1]);
            translate([0,0,53.1])linear_extrude(socket_len)circle(d=sockets_diameters[2]);
            translate([0,0,53.1+socket_len])linear_extrude(stacked_socket_len-socket_len)circle(d=sockets_diameters[5]);
            // translate([0,0,53.1+stacked_socket_len+socket_len])linear_extrude(socket_len)circle(d=sockets_diameters[4]);

        }
    }
}

module socketsB(positive,negative){
    if(positive){
        color("red",.2){
            translate([0,0,0])linear_extrude(socket_len)circle(d=sockets_diameters[3]);
            translate([0,0,socket_len])linear_extrude(socket_len)circle(d=sockets_diameters[4]);
            translate([0,0,socket_len*2])linear_extrude(socket_len)circle(d=sockets_diameters[5]);
            //adding the 8mm bit to the bit holder socket
            translate([0,0,socket_len*3])linear_extrude(40.8-socket_len)circle(d=9+touch_tolerance,$fn=6);
        }
    }
}

module sockets(i){
    color("red",.2){
        linear_extrude(socket_len)circle(d=sockets_diameters[i]);
    }
}
module extension(positive,negative){
    if(positive){
        color("red",.2){
            translate([0,0,0])linear_extrude(extension_socket_len)circle(d=extension_socket_diameter);
            translate([0,0,extension_socket_len])linear_extrude(extension_len-extension_socket_len-extension_square_len)circle(d=extension_body_diameter);
            translate([0,0,extension_len-extension_square_len])linear_extrude(extension_square_len)circle(d=extension_square_diameter);
        }
    }
}


module sockets_lined_up(){
    translate([0,0,sockets_diameters[0]/2])rotate([90,0,0])sockets(0);
    translate([0,0,sockets_diameters[0]+2+sockets_diameters[1]/2])rotate([90,0,0])sockets(1);
    translate([0,0,sockets_diameters[0]+sockets_diameters[1]+4+sockets_diameters[2]/2])rotate([90,0,0])sockets(2);
    translate([0,0,sockets_diameters[0]+sockets_diameters[1]+sockets_diameters[2]+6+sockets_diameters[3]/2])rotate([90,0,0])sockets(3);
    translate([0,0,sockets_diameters[0]+sockets_diameters[1]+sockets_diameters[2]+sockets_diameters[3]+8+sockets_diameters[4]/2])rotate([90,0,0])sockets(4);
    translate([0,0,sockets_diameters[0]+sockets_diameters[1]+sockets_diameters[2]+sockets_diameters[3]+sockets_diameters[4]+10+sockets_diameters[5]/2])rotate([90,0,0])sockets(5);
    translate([0,0,sockets_diameters[0]+sockets_diameters[1]+sockets_diameters[2]+sockets_diameters[3]+sockets_diameters[4]+sockets_diameters[5]+12+sockets_diameters[6]/2])rotate([90,0,0])sockets(6);
    translate([0,0,sockets_diameters[0]+sockets_diameters[1]+sockets_diameters[2]+sockets_diameters[3]+sockets_diameters[4]+sockets_diameters[5]+sockets_diameters[6]+14+sockets_diameters[6]/2])rotate([90,0,0])sockets(6);
    translate([-2-sockets_diameters[6],0,sockets_diameters[0]+sockets_diameters[1]+sockets_diameters[2]+sockets_diameters[3]+sockets_diameters[4]+sockets_diameters[5]+sockets_diameters[6]+14+sockets_diameters[6]/2])rotate([90,0,0])sockets(6);
    translate([-2-sockets_diameters[6],0,-2-sockets_diameters[6]+sockets_diameters[0]+sockets_diameters[1]+sockets_diameters[2]+sockets_diameters[3]+sockets_diameters[4]+sockets_diameters[5]+sockets_diameters[6]+14+sockets_diameters[6]/2])rotate([90,0,0])sockets(6);

}

module bits_lined_up(){
    color("red",.2)for(i = [0:11]){
        translate([0,0,(bit_diameter+1.5)*i-1+bit_diameter/2])rotate([90,30,0])linear_extrude(bit_len)circle(d=bit_diameter,$fn=6);
    }
}

module stuff_arranged(parts,clearance,container,container_top){
    sockets_pos = [-13,socket_len,1.8];
    bits_pos = [-28,bit_len,3];
    ratchet_pos = [18,ratchet_head_width/2+2,ratchet_len];
    extension_pos = [2,extension_socket_diameter/2,40+extension_len];
    part_base_pos = [-32,0,5];
    if(parts){
        translate(part_base_pos){
            translate(sockets_pos)sockets_lined_up();
            translate(bits_pos)bits_lined_up();
            translate(ratchet_pos)rotate([180,3.7,90])ratchet(positive=true,negative=false);
            translate(extension_pos)rotate([180,0,0])extension(positive=true,negative=false);
        }
    }
    if(clearance){
        // space to slide the parts down
        translate(part_base_pos){
            translate(sockets_pos)sockets_lined_up();
            translate(bits_pos)bits_lined_up();
            translate(ratchet_pos)rotate([180,3.7,90])union(){
                rotate([0,-90,0])linear_extrude(20)projection()rotate([0,90,0])ratchet(positive=true,negative=false);
                ratchet(positive=true,negative=false);
            }
            translate(extension_pos)rotate([180,0,0])union(){
                rotate([-90,0,0])linear_extrude(10)projection()rotate([90,0,])extension(positive=true,negative=false);
                extension(positive=true,negative=false);
            }
        }
    }
    if(container){
            // add volumes to hold the parts
        difference(){
            intersection()
            {
                // the part holders
                translate(part_base_pos)color("green",.2){
                    // baseplate, holds sockets and bits .. what the top should slide into
                    translate([-45,ratchet_head_width+2,-3])rotate([90,0,0])linear_extrude(17)square([80,150]);
                    // extension holder
                    translate(extension_pos)translate([-10,30,-80])rotate([90,0,0])linear_extrude(30)square([extension_socket_diameter+10,extension_len+8]);
                    // ratchet handle holder
                    translate(ratchet_pos)translate([-12,0,-150])rotate([90,0,0])linear_extrude(30)square([30,30]);
                    // top of case
                    translate([-45,30,142])rotate([90,0,0])linear_extrude(31)square([80,5]);
                }
                // shape the outside of the case
                translate([-68,0,150])mirror([0,0,1])slide_top_case_blank(top=false,bottom=true,length=150,width=72,depth=36,minkowski_diameter=5,top_thickness=2,top_looseness=0,stiff_rib_len=5,stiff_rib_thickness=2);
                }
            stuff_arranged(parts=false,clearance=true,container=false);
        }
    }
    if(container_top){
        // add volumes to hold the parts
        difference(){
            translate([-68,0,150])mirror([0,0,1])slide_top_case_blank(top=true,bottom=false,length=150,width=72,depth=36,minkowski_diameter=5,top_thickness=2,top_looseness=0,stiff_rib_len=5,stiff_rib_thickness=1);
            stuff_arranged(parts=true,clearance=false,container=false);
        }
    }
}




// box_bottom();
// hull(){
// ratchet(true);
rotate([90,0,0]){
    stuff_arranged(parts=false,clearance=false,container=true,container_top=false);
    translate([0,-50,0])
    stuff_arranged(parts=false,clearance=false,container=false,container_top=true);
}
// slide_top_case_blank(top=true,bottom=false,length=150,width=72,depth=32.5,minkowski_diameter=5,top_thickness=2);
// translate([0,.3,0])slide_top_case_blank(top=true,bottom=false,length=150,width=72,depth=32.5,minkowski_diameter=5,top_thickness=2);

// slot_with_catch_bump(155,2,3,false);

// rotate([0,-90,0])linear_extrude(10)projection()rotate([0,90,0])ratchet(positive=true,negative=false);
// rotate([-90,0,0])linear_extrude(10)projection()rotate([90,0,0])stuff_arranged();  //do this for the parts separately also rotate the ratchet around before this and then back
// }

// socketsA(positive=true,negative=false);
// translate([-20,0,0])socketsB(positive=true,negative=false);
