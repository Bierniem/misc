/*
shiratsuyu... yuudachi

// maybe try drawing hull lines and extruding them?
*/ 
use <rc_stuff.scad>;

$fn=50;
loa = 109.6;
beam = 9.9;
height = 3.5;

scale_paper = 109.6/261;
scale_1_200 = (109.6*1000/261)/(109.6*1000/545);
scale_1_144 = (109.6*1000/261)/(109.6*1000/757);
// 5mm > paper_scale
// 5 / 1000 


hull_roundover = 0;

module hull_station(width_top,width_breakover,width_wl,width_wl_half,width_wl_quarter,height_above_wl,height_below_wl,height_breakover,coaming=false){
    if(!coaming){
        polygon([
            // [width_top/2,height_above_wl],
            [width_breakover/2,height_breakover],
            [width_wl/2,0],
            [width_wl_half/2,-height_below_wl/2],
            [width_wl_quarter/2,-height_below_wl*3/4],
            [0,-height_below_wl],
            [-width_wl_quarter/2,-height_below_wl*3/4],
            [-width_wl_half/2,-height_below_wl/2],
            [-width_wl/2,0],
            [-width_breakover/2,height_breakover],
            // [-width_top/2,height_above_wl],
        ]);
    }
    if(coaming){
        polygon([
            [width_top/2,height_above_wl],
            [width_breakover/2,height_breakover],
            [-width_breakover/2,height_breakover],
            [-width_top/2,height_above_wl],
        ]);
    }
}

module hulls(n,coaming=false){
    if(n==0){
        len_station = 0;
        width_wl = 10;
        width_top = 10;
        width_wl_half = 10;
        width_wl_quarter = 10;
        height_above_wl = 6.5;
        height_below_wl = -.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([[-width_wl/2,-height_below_wl],[width_wl/2,-height_below_wl],[width_wl/2,height_above_wl],[-width_wl/2,height_above_wl]]);
        }
    }
    if(n==1){
        len_station = 4;
        width_wl = 10;
        height_above_wl = 6.5;
        height_below_wl = 0;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([[-width_wl/2,-height_below_wl],[width_wl/2,-height_below_wl],[width_wl/2,height_above_wl],[-width_wl/2,height_above_wl]]);
        }
    }
    if(n==2){
        len_station = 8;
        width_wl = 14;
        height_above_wl = 6.5;
        height_below_wl = .5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([[-width_wl/2,-height_below_wl],[width_wl/2,-height_below_wl],[width_wl/2,height_above_wl],[-width_wl/2,height_above_wl]]);
        }
    }
    if(n==3){
        len_station = 12;
        width_wl = 15.5;
        height_above_wl = 6.5;
        height_below_wl = .75;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([[-width_wl/2,-height_below_wl],[width_wl/2,-height_below_wl],[width_wl/2,height_above_wl],[-width_wl/2,height_above_wl]]);
        }
    }
    if(n==4){
        len_station = 16;
        width_wl = 16;
        height_above_wl = 6.5;
        height_below_wl = 1.5;
        translate([0,0,len_station])linear_extrude(.1)
        polygon([[-width_wl/2,-height_below_wl],[width_wl/2,-height_below_wl],[width_wl/2,height_above_wl],[-width_wl/2,height_above_wl]]);
    }
    if(n==5){
        len_station = 40;
        width_wl = 18;
        width_breakover = 20;
        width_top = 20;
        width_wl_half = 12;
        width_wl_quarter = 6;
        height_above_wl = 6.5;
        height_breakover = 6.5;
        height_below_wl = 5;
        translate([0,0,len_station])linear_extrude(.1)hull_station(width_top,width_breakover,width_wl,width_wl_half,width_wl_quarter,height_above_wl,height_below_wl,height_breakover,coaming);
    }
    if(n==6){
        len_station = 45;
        width_wl = 20;
        width_breakover = 20.1;
        width_top = 20.1;
        width_wl_half = 13;
        width_wl_quarter = 8;
        height_above_wl = 6.5;
        height_breakover = 6.5;
        height_below_wl = 8.5;
        translate([0,0,len_station])linear_extrude(.1)hull_station(width_top,width_breakover,width_wl,width_wl_half,width_wl_quarter,height_above_wl,height_below_wl,height_breakover,coaming);
    }
    if(n==7){
        len_station = 75;
        width_wl = 23;
        width_breakover = 23;
        width_top = 23;
        width_wl_half = 21;
        width_wl_quarter = 17;
        height_above_wl = 6.5;
        height_breakover = 6.5;
        height_below_wl = 8.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==8){
        len_station = 115;
        width_wl = 23;
        width_breakover = 23;
        width_top = 23;
        width_wl_half = 21;
        width_wl_quarter = 17;
        height_above_wl = 6.5;
        height_breakover = 6.5;
        height_below_wl = 8.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==9){
        len_station = 171.5;
        width_wl = 22;
        width_breakover = 22;
        width_top = 22;
        width_wl_half = 21;
        width_wl_quarter = 17;
        height_above_wl = 6.5;
        height_breakover = 6.5;
        height_below_wl = 8.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    //extra height at front starts here
    if(n==10){
        len_station = 174;
        width_wl = 22;
        width_breakover = 22;
        width_top = 21.5;
        width_wl_half = 21;
        width_wl_quarter = 17;
        height_above_wl = 10.5;
        height_breakover = 6.5;
        height_below_wl = 8.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==11){
        len_station = 195;
        width_wl = 20;
        width_breakover = 21;
        width_top = 21.5;
        width_wl_half = 19;
        width_wl_quarter = 17;
        height_above_wl = 10.5;
        height_breakover = 7;
        height_below_wl = 8.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==12){
        len_station = 233.5;
        width_wl = 10;
        width_breakover = 13;
        width_top = 15;
        width_wl_half = 10;
        width_wl_quarter = 8;
        height_above_wl = 10.5;
        height_breakover = 7;
        height_below_wl = 8.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==13){
        len_station = 243.5;
        width_wl = 10;
        width_breakover = 10;
        width_top = 11.5;
        width_wl_half = 10;
        width_wl_quarter = 8;
        height_above_wl = 11.5;
        height_breakover = 7;
        height_below_wl = 8.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==14){
        len_station = 247.5;
        width_wl = 7;
        width_breakover = 8;
        width_top = 10;
        width_wl_half = 7;
        width_wl_quarter = 6;
        height_above_wl = 12;
        height_breakover = 7;
        height_below_wl = 7.5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==15){
        len_station = 251.5;
        width_wl = 6;
        width_breakover = 6;
        width_top = 8;
        width_wl_half = 5;
        width_wl_quarter = 4;
        height_above_wl = 12.5;
        height_breakover = 7;
        height_below_wl = 5;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==16){
        len_station = 256.5;
        width_wl = 0;
        width_breakover = 4;
        width_top = 5;
        width_wl_half = 4;
        width_wl_quarter = 3;
        height_above_wl = 13;
        height_breakover = 7;
        height_below_wl = 0;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
                polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [-width_breakover/2,height_breakover],
                [-width_top/2,height_above_wl],
            ]);
        }
    }
    if(n==17){
        len_station = 258;
        width_wl = 0;
        width_breakover = 0;
        width_top = 4.5;
        width_wl_half = 0;
        width_wl_quarter = 0;
        height_above_wl = 13.25;
        height_breakover = 9;
        height_below_wl = -6;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
              [width_top/2,height_above_wl],
                [-width_top/2,height_above_wl],
                [0,-height_below_wl]
            ]);
        }
    }
    if(n==18){
        len_station = 259;
        width_wl = 0;
        width_breakover = 1;
        width_top = 3.5;
        width_wl_half = 0;
        width_wl_quarter = 0;
        height_above_wl = 13.3;
        height_breakover = 7;
        height_below_wl = -10;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                // [width_top/2,height_above_wl],
                [width_breakover/2,height_breakover],
                [width_wl/2,0],
                [width_wl_half/2,-height_below_wl/2],
                [width_wl_quarter/2,-height_below_wl*3/4],
                [0,-height_below_wl],
                [-width_wl_quarter/2,-height_below_wl*3/4],
                [-width_wl_half/2,-height_below_wl/2],
                [-width_wl/2,0],
                [-width_breakover/2,height_breakover],
                // [-width_top/2,height_above_wl],
            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
              [width_top/2,height_above_wl],
                [-width_top/2,height_above_wl],
                [0,-height_below_wl]
            ]);
        }
    }
    if(n==19){
        len_station = 261;
        width_wl = 0;
        width_breakover = 0;
        width_top = .1;
        width_wl_half = 0;
        width_wl_quarter = 0;
        height_above_wl = 13.5;
        height_breakover = 12;
        height_below_wl = -12;
        if(!coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([

            ]);
        }
        if(coaming){
            translate([0,0,len_station])linear_extrude(.1)
            polygon([
                [width_top/2,height_above_wl],
                [-width_top/2,height_above_wl],
                [0,-height_below_wl]
            ]);
        }
    }
}

module main_hull(){
    hull(){
        hulls(0);
        hulls(1);
    }
    hull(){
        hulls(1);
        hulls(2);
        hulls(3);
        hulls(4);
        hulls(5);
    }
    hull(){
        hulls(5);
        hulls(6);
    }
    hull(){
        hulls(6);
        hulls(7);
        hulls(8);
    }
    hull(){
        hulls(8);
        hulls(9);
    }
    hull(){
        hulls(9);
        hulls(10);
    }
    hull(){
        hulls(10);
        hulls(11);
        hulls(12);
        hulls(13);
    }
    hull(){
        hulls(9,coaming=false);
        hulls(10,coaming=true);
        hulls(11,coaming=true);
        hulls(12,coaming=true);
    }
    hull(){
        hulls(12,coaming=true);
        hulls(13,coaming=true);
    }
    hull(){
        // hulls(11);
        hulls(12);
        hulls(13);
    }
    hull(){
        hulls(13);
        hulls(14);
        hulls(15);
        hulls(16);
        hulls(17,coaming=true);
        // hulls(18);
    }
    hull(){
        hulls(13,coaming=true);
        hulls(14,coaming=true);
        hulls(15,coaming=true);
        hulls(16,coaming=true);
        hulls(17,coaming=true);
    }
    hull(){
        hulls(17,coaming=true);
        hulls(18,coaming=true);
    }
    hull(){
        hulls(18,coaming=true);
        hulls(19,coaming=true);
    }
    module strakes(){
        color("red")linear_extrude(.5)polygon([[0,0],[0,100],[2,90],[2,10]]);
    }
    translate([8,-6,70])rotate([90,0,-50])strakes();
    mirror([1,0,0])translate([8,-6,70])rotate([90,0,-50])strakes();
}

module turret_1(){
    ring_diameter = 8;
    ring_height = 1;
    length_base = 13.5;
    length_middle = 8;
    width_middle = 10;
    width_back = 7;
    height_middle = 5;
    height_back = 4;
    front_setback = 2;
    roundover = 1;
    // the ring
    linear_extrude(ring_height)circle(d=ring_diameter);
    // the shape from above
    module from_above(){
        union(){
            polygon([[0,0],[1.5,0],[5,1],[5.25,5],[4,12],[2,13],[0,13.1]]);
            mirror([1,0,0])polygon([[0,0],[1.5,0],[5,1],[5.25,5],[4,12],[2,13],[0,13.1]]);
        }
    }
    module from_side(){
        polygon([[0,0],[0,8],[1,13],[1.5,13.1],[5.5,13.1],[6,13],[7,10],[7,2],[5,2],[5,.5]]);
    }

    module from_front(){
        polygon([[0,0],[0,5.25],[6,5.25],[7,4.25],[7,0]]);
        mirror([0,1,0])polygon([[0,0],[0,5.25],[6,5.25],[7,4.25],[7,0]]);
    }

    // translate([0,-ring_diameter/2,ring_height])from_above();
    // translate([10,-ring_diameter/2,0])from_side();
    // translate([20,-ring_diameter/2,0])from_front();
    translate([0,-ring_diameter/2,ring_height])intersection(){
        rotate([-90,-90,0])linear_extrude(13.1)from_front();
        linear_extrude(7)from_above();
        translate([5.25,0,0])rotate([0,-90,0])linear_extrude(5.25*2)from_side();
    }
    translate([1,1,6])rotate([90,180,0])turret_gun(barrel=false);
    translate([-1,1,6])rotate([90,180,0])turret_gun(barrel=false);
}

module turret_gun(barrel=true){
    if(barrel){
        hull(){
            linear_extrude(.1)hull(){
                circle(d=1.5);
                translate([0,-1.5,0])circle(d=2);
            }
            translate([0,0,3])linear_extrude(.1)hull(){
                circle(d=1.5);
                translate([0,-1.5,0])circle(d=2);
            }
            translate([0,0,5])linear_extrude(.1)circle(d=1.5);
        }
        linear_extrude(17)circle(d=.75);
    }
    if(!barrel){
        // if the barrel is too fine to print, use a bit of wire?
        difference(){
            hull(){
                linear_extrude(.1)hull(){
                    circle(d=1.5);
                    translate([0,-1.5,0])circle(d=2);
                }
                translate([0,0,3])linear_extrude(.1)hull(){
                    circle(d=1.5);
                    translate([0,-1.5,0])circle(d=2);
                }
                translate([0,0,5])linear_extrude(.1)circle(d=1.5);
            }
            linear_extrude(17)circle(d=.75);
        }
    }
}

module tower_1(){
    module from_above(){
        polygon([[0,0],[18,0],[18,5],[11,5.5],[11,7],[6,7],[6,5.5],[3,5],[1,3.5]]);
        mirror([0,1,0])polygon([[0,0],[18,0],[18,5],[11,5.5],[11,7],[6,7],[6,5.5],[3,5],[1,3.5]]);
    }
    module from_front(){
        polygon([[0,0],[5,0],[5,7.9],[6.5,8],[6.5,13.5],[3,14],[3,17],[1,17],[1,18],[0,18]]);
        mirror([1,0,0])polygon([[0,0],[5,0],[5,7.9],[6.5,8],[6.5,13.5],[3,14],[3,17],[1,17],[1,18],[0,18]]);
    }
    module from_side(){
        polygon([[0,0],[14,0],[14.5,2.5],[12.5,3],[12.5,8.5],[22.5,8.5],[22.5,9],[12.5,9],[12.5,11.5],[13,11.6],[13,13.4],[12.5,13.5],[12.5,18],[12,18],[12,19.5],[10,19.5],[10,17.5],[8,17.5],[8,14.9],[-1,14],[-.5,8],[0,7.9]]);
    }
    intersection(){
        translate([-1,0,0])linear_extrude(30)from_above();
        translate([-1,0,0])rotate([90,0,90])linear_extrude(30)from_front();
        translate([0,10,0])rotate([90,0,0])linear_extrude(20)from_side();
    }
}

module stack_1(){
    // module from_above(){
    //     hull(){
    //         translate([0,-3,0])circle(d=6);
    //         translate([0,-5,0])circle(d=7);
    //     }
    // }
    module from_front(){
        // translate([-11.5/2,0,0])square([11.5,3.5]);
        polygon([[-11.5/2,0],[-11.5/2,3.5],[-6/2-1,3.75],[-6/2,4.5],//[-7/2,22],[7/2,22],
        [6/2,4.5],[6/2+1,3.75],[11.5/2,3.5],[11.5/2,0]]);
    }
    module from_side(){
        polygon([[0,0],[7,0],[7.1,1.3],[8.5,1.5],[10,19],[3,22],[1.7,6],[1,5],[-2,4.5],[-2,2],[-.5,1.5]]);
    }
    module tube(){
        difference(){
            linear_extrude(19)hull(){
                circle(d=6);
                translate([0,2,0])circle(d=6);
            }
        union(){
            translate([0,0,17.4])rotate([18,0,0])linear_extrude(10)square(12,center=true);
            // translate([0,0,16])linear_extrude(3)hull(){
            //     circle(d=5);
            //     translate([0,2,0])circle(d=5);
            // }
        }
        }

    }
    intersection(){
        // linear_extrude(22)translate([0,-3,0])from_above();   
        translate([11.5/2,0,0])rotate([90,0,-90])linear_extrude(22)from_side();
        translate([0,5,0])rotate([90,0,0])linear_extrude(22)from_front();
    }
    translate([0,-5.5,3])rotate([4,0,0])tube();
}

module building(){
    // the structure that runs along the ship from the step down to aft stack2
    module from_side(){
        translate([0,0,-4])linear_extrude(8)polygon([[0,0],[59,0],[59,2.5],[56,2.5],[41.5,5],[35,2.5],[20,2.5],[16.5,5],[15.5,5]]);
    }
    module from_above(){
        translate([-3,0,0])linear_extrude(5)square([6,59]);
    }
    intersection(){
        translate([0,59,0])rotate([-90,180,90])from_side();
        from_above();
    }
}

module stack_2(){
    module tube(){
        difference(){
            linear_extrude(19)hull(){
                circle(d=3);
                translate([0,2,0])circle(d=3);
            }
            union(){
                // translate([0,0,15])linear_extrude(5)hull(){
                //     circle(d=2);
                //     translate([0,2,0])circle(d=2);
                // }
                translate([0,0,18])rotate([8,0,0])linear_extrude(5)square(10,center=true);
            }
        }
    }
    module roof(){
        intersection(){
            linear_extrude(2)hull(){
                circle(d=5);
                translate([0,2,0])circle(d=5);
            }
            translate([-2.5,0,-.75])rotate([0,90,0])linear_extrude(5)hull(){
                circle(d=5);
                translate([0,2,0])circle(d=5);
            }
            translate([0,-3.5,-.75])rotate([0,90,90])linear_extrude(9)hull(){
                circle(d=5);
            }
        }
    }
    rotate([5,0,0])tube();
    translate([0,-.5,5])roof();
}

module torpedo_turret(){
    module ring(){
        linear_extrude(1.5)circle(d=6);
    }
    module torpedo(){
        linear_extrude(20)circle(d=1.5);
        translate([0,0,20])sphere(d=1.5);
    }
    
    module housing(){
        module from_above(){
            translate([0,-5,0])polygon([[0,5],[0,1.5],[5,0],[11,0],[11.75,2],[12,5]]);
            mirror([0,1,0])translate([0,-5,0])polygon([[0,5],[0,1.5],[5,0],[11,0],[11.75,2],[12,5]]);
        }
        module from_side(){
            polygon([[0,1],[1.5,1],[2,0],[8,0],[8.5,1],[11.5,1],[11,5],[2.5,5],[0,4]]);
        }
        module from_front(){
            hull(){
                translate([7/2,-4/2,0])circle(d=3);
                translate([-7/2,-4/2,0])circle(d=3);
                translate([-7/2,4/2,0])circle(d=3);
                translate([7/2,4/2,0])circle(d=3);
            }
        }
        intersection(){
            rotate([0,0,90])linear_extrude(10)from_above();
            translate([-5,0,0])rotate([90,0,90])linear_extrude(10)from_side();
            translate([0,0,1.7])rotate([-90,0,0])linear_extrude(12)from_front();
        }
    }
    translate([0,-5,1])housing();
    ring();
    translate([.75,-7,3])rotate([-90,0,0])torpedo();
    translate([-.75,-7,3])rotate([-90,0,0])torpedo();
    translate([-2.25,-7,3])rotate([-90,0,0])torpedo();
    translate([2.25,-7,3])rotate([-90,0,0])torpedo();
}

module catwalk_support(){
    translate([0,0,9.5])mirror([0,0,1])union(){
        rotate([8,0,0])linear_extrude(10)circle(d=.5);
        rotate([-8,0,0])linear_extrude(10)circle(d=.5);
        translate([0,.75,6])rotate([90,0,0])linear_extrude(1.5)circle(d=.25);
        translate([0,.75,4])rotate([90,0,0])linear_extrude(1.5)circle(d=.25);
        // the flat bit at the bottom
        difference(){
            hull(){
                rotate([8,0,0])linear_extrude(9.7)circle(d=.75);
                rotate([-8,0,0])linear_extrude(9.7)circle(d=.75);
            }
            translate([0,0,1])linear_extrude(7.5)square(5,center=true);
        }
    }
}

module tower_2(){
    // the tower attached to stack 2
    module building(){
        difference(){
            union(){
                linear_extrude(5)square([4,15],center=true);
                translate([0,-15/2,0])linear_extrude(5)circle(d=4);
            }
            translate([-2,-15/2-2.5,3])rotate([0,90,0])linear_extrude(4)circle(d=5);
        }
    }
    module gun_platform(){
        // two aa in between stack 2 and torpedo 1
        module from_above(){
            circle(d=6.5,$fn=8);
            translate([9,0,0])circle(d=6.5,$fn=8);
            square([9,2]);
        }
        module support(){
            linear_extrude(8)circle(d=.75);
        }
        translate([-4.5,0,8])linear_extrude(.5)from_above();
        translate([5,0,0])support();
        translate([-5,0,0])support();
    
    }
    module spot_light(){
        translate([0,-.1,2.5])rotate([-90,0,0])linear_extrude(1.5)circle(d=1.5);
        translate([0,.5,0])linear_extrude(2.5)circle(d=.75);
        translate([0,.5,0])linear_extrude(.5)circle(d=1);
    }
    module platform_1(){
        linear_extrude(.5)hull(){
            circle(d=8,$fn=8);
            translate([0,2,0])circle(d=8,$fn=8);
        }
        // the wings pointed backwards
        linear_extrude(.5)hull(){
            circle(d=5,$fn=8);
            translate([5,-7,0])circle(d=1);
        }
        linear_extrude(.5)hull(){
            circle(d=5,$fn=8);
            translate([-5,-7,0])circle(d=1);
        }
        // the sections under the catwalk
        linear_extrude(.5)hull(){
            circle(d=5,$fn=8);
            translate([-5,6,0])circle(d=6,$fn=8);
        }
        linear_extrude(.5)hull(){
            circle(d=5,$fn=8);
            translate([5,6,0])circle(d=6,$fn=8);
        }
    }
    module platform_2(){
        linear_extrude(4)circle(d=5);
        translate([0,1.5,4])spot_light();
        // translate([-2.2,-2.9,1])sphere(d=2);
        // translate([2.2,-2.9,1])sphere(d=2);
    }

    module catwalk(){
        translate([20/2-3,0,9.1])linear_extrude(1.5)square([5.8,2.8],center=true);
        translate([-20/2+3,0,9.1])linear_extrude(1.5)square([5.8,2.8],center=true);
        translate([0,0,9.1])linear_extrude(.5)square([20,3],center=true);
        translate([11,0,0])rotate([0,-8,0])catwalk_support();
        translate([-11,0,0])rotate([0,8,0])catwalk_support();
    }
    translate([0,2,-1])gun_platform();
    translate([0,-10,5])union(){
        platform_1();
        platform_2();
    }
    translate([0,-4,0])catwalk();
    translate([0,-.8,0])stack_2();
    translate([0,-4,0])building();
}

module tower_3(){
    // the reloader aft torpedo turret 2
    module building(){
        intersection(){
            linear_extrude(4.5)polygon([[0,0],[-12,0],[-19,5],[0,5]]);
            translate([0,4,0])rotate([90,0,0])linear_extrude(5)polygon([[0,0],[-19,0],[-19,2],[-15.5,4.5],[0,4.5]]);
        }
    }
    module crane(){
        linear_extrude(1.5)circle(d=2,$fn=8);
        translate([.5,0,1.5])rotate([0,0,45])linear_extrude(1)circle(d=1.25,$fn=4);
        translate([.75,-1,1.5+.75])rotate([-90,0,0])linear_extrude(17)square([.5,.75]);
        translate([.75,16.5,-4])rotate([0,-8,90])scale([.8,.8,.65])catwalk_support();

    }
    module box(){
        difference(){
            union(){
                linear_extrude(2)square([20,7]);
                for(i=[0:7/4:7]){
                    translate([0,i,0])linear_extrude(2.2)square([20,1]);
                }
            }
            translate([20,6,0])rotate([0,0,45])cube(3);
        }

    }
    building();
    translate([-12,2,4.5])crane();
    translate([-20,4,0])box();
    
}

module turret_2(){
    module body(){
        intersection(){
            rotate([90,0,180])hull(){
                translate([2.2,0])rotate([0,3])cylinder(d=2, h=11, center=true);
                translate([-2.2,0])rotate([0,-3])cylinder(d=2, h=11, center=true);
                translate([-2,3])rotate([0,-3])cylinder(d=2, h=11, center=true);
                translate([2,3])rotate([0,3])cylinder(d=2, h=11, center=true);
            }
            translate([-5,-6,.5])rotate([90,0,90])linear_extrude(10)polygon([[0,0],[11,0],[11,2],[9,4],[0,4]]);
        }
    }
    module sight(){
        translate([-2,3,2.7])rotate([90,50,90])linear_extrude(1.5)circle(d=4,$fn=6);
    }
    linear_extrude(.5)circle(d=6.5);
    body();
    translate([0,1.5,2])rotate([-90,0,0])turret_gun(barrel=false);
    sight();
}

module mushroom_vent(){

}

module door(){

}

module life_boats(){
    module life_boat(){
        module gunnels(out,in){
            linear_extrude(.5)difference(){
                if(out){
                hull(){
                    circle(d=1);
                    translate([0,-6,0])circle(d=4.5);
                    translate([0,-8,0])circle(d=5);
                    translate([0,-12,0])circle(d=4.5);
                    translate([0,-17,0])square([2.5,.1],center=true);
                }}
                if(in){
                hull(){
                    translate([0,-1,0])circle(d=1);
                    translate([0,-6,0])circle(d=4);
                    translate([0,-8,0])circle(d=4.5);
                    translate([0,-12,0])circle(d=4);
                    translate([0,-16.5,0])square([2.5,.1],center=true);
                }}
            }
        }
        module stem(out,in){
            linear_extrude(1)difference(){
                if(out){
                hull(){
                    circle(d=1);
                    translate([-.75,-1.5,0])circle(d=3);
                    translate([-.75,-8,0])circle(d=3);
                    translate([0,-17,0])square([2.5,.1],center=true);
                }}
                if(in){
                hull(){
                    // circle(d=1);
                    translate([-.25,-1.75,0])circle(d=3);
                    translate([-.25,-8,0])circle(d=3);
                    translate([.25,-16.5,0])square([2.5,.1],center=true);
                }}
                translate([0,-19,0])square(20);
            }
        }
        // hull
        difference(){
            hull(){
                translate([0,0,-.5])gunnels(out=true);
                translate([.5,0,0])rotate([0,-90,0])stem(out=true);
            }
            translate([0,0,.1])hull(){
                translate([0,0,-.5])gunnels(in=true);
                translate([.5,0,0])rotate([0,-90,0])stem(in=true);
            }
        }
        // cover
        // thwarts
        intersection(){
            hull(){
                translate([0,0,-.5])gunnels(out=true);
                translate([.5,0,0])rotate([0,-90,0])stem(out=true);
            }
            union(){
                for(i=[4:2:14]){
                    translate([0,-i,-2.5])linear_extrude(2)square([5,.75],center=true);
                }
            }
        }
    }
    module davit(){
        // probably too fine to print at 1/200
        linear_extrude(8)circle(d=.5);
        translate([0,-1,0])rotate([-90,0,0])translate([-1,0])rotate_extrude(angle=80)translate([1,1])circle(d=.5);
        translate([-.8,0,-1])rotate([180,80,0])linear_extrude(2)circle(d=.5);
        translate([-2,-1,-1.2])rotate([-90,70,0])translate([-1,0])rotate_extrude(angle=110)translate([1,1])circle(d=.5);
    }
    translate([8,0,6.5])life_boat();
    // davit();
    mirror([1,0,0])translate([8,0,6.5])life_boat();
}

module skiff_boat(){

}

module ladder(n){
    module rung(){
        linear_extrude(.5)circle(d=.1);
        translate([.25,0,0])linear_extrude(.5)circle(d=.1);
        linear_extrude(.1)hull(){
            circle(.10);
            translate([.25,0,0])circle(.10);
        }
        translate([0,0,.4])linear_extrude(.1)hull(){
            circle(.10);
            translate([.25,0,0])circle(.10);
        }
    }
    for(i=[0:n]){
        translate([.25*i,0,0])rung();
    }
}
// make cutouts under each turret for servos
// make cutouts for the rudder servos
// make cutouts for the motors
// ladder(5);

module hull_hollowed(a,b){
    // a = the hull
    // b = the removed from the hull. maybe with some schenanegains to make an insertable bit
    // remove a T kinda area from the hull
    top_width = 19;
    top_depth = 3;
    bottom_width = 14;
    bottom_depth = 8.5;
    module main_hollowed_cross_section(){
        linear_extrude(100){
            difference(){
                square([top_width,top_depth],center=true);
                translate([0,-top_depth/2,0])square([top_width-2,top_depth],center=true);
            }
            translate([0,-bottom_depth/2,0])minkowski(){
                square([bottom_width,bottom_depth],center=true);
                circle(2);
            }
        }
    }
    module stern_hollowed_section(){
        //need access to the propeller shafts and the rudders
        hull(){
            translate([0,-bottom_depth/2-1,60])linear_extrude(.1)minkowski(){
                square([bottom_width,bottom_depth-2],center=true);
                circle(2);
            }
            translate([0,-2,0])linear_extrude(.1)translate([0,0,0])square([bottom_width-4,bottom_depth-7],center=true);
        }
        translate([0,5,0])rotate([0,0,0])linear_extrude(10)square([12,15],center=true);
    }
    module bow_hollowed_section(){

    }
    module propeller_shafts(){
        linear_extrude(80)circle(d=4/scale_1_144);
        // a gear or maybe a motor...
        translate([10/scale_1_144,0,80])linear_extrude(2)circle(d=10/scale_1_144);
        translate([0,0,80])linear_extrude(2)circle(d=10/scale_1_144);
        translate([0,0,80])linear_extrude(2)circle(d=10/scale_1_144);
    }
    if(a){
        difference(){
            main_hull();
            union(){
                translate([0,5.5,70])main_hollowed_cross_section();
                translate([0,5.5,10])stern_hollowed_section();
                translate([5,-6,17])rotate([-2,0,0])propeller_shafts();
                translate([-5,-6,17])rotate([-2,0,0])propeller_shafts();
            }
        }
        
    }
    module rudder(){
        translate([0,0,-.25])linear_extrude(.5)scale(.8)minkowski(){
            polygon([[0,7],[2,0],[5,0],[6,2],[6,6]]);
            circle(d=2);
        }
        translate([3.5,5,0])rotate([-90,0,-7])linear_extrude(10)circle(d=.75);
    }
    color("red")translate([5,-6,17])rotate([-2,0,0])propeller_shafts();
    color("red")translate([-5,-6,17])rotate([-2,0,0])propeller_shafts();
    color("red")translate([4.5,-7.5,9])rotate([0,-90,0])rudder();
    color("red")translate([-4.5,-7.5,9])rotate([0,-90,0])rudder();
}

module gear_box(){
    // a gear/transfer case
    // 2 prop gears prop shafts
    // 2 middle gears between prop gears
    // 1 motor gear on one middle gear
    // this should probably be encased to reduce water exposure to the bearings gears and to the motor? maybe glue in metal plate through bottom for heat dump?
    // re-center on the drive gear but keep track of the center between the shafts too to line up to the hull
    // bearings are 3.2mm id 9.5mm od 4mm depth R2ZZ 10 PCS Deep Groove Ball Bearing
    // need to redesign for tooth mesh too...
    motor_gear_d = 6.2;
    prop_gear_d = 14.2;
    middle_gear_d = 7.6;
    translate([middle_gear_d/2-1,middle_gear_d/2+motor_gear_d/2-.6,0])linear_extrude(7)circle(d=motor_gear_d);
    translate([-prop_gear_d/2-middle_gear_d/2+.6,(prop_gear_d-middle_gear_d)/2,0]){
        linear_extrude(7)circle(d=prop_gear_d);
        linear_extrude(200)circle(d=3.175);
    }
    translate([prop_gear_d/2+middle_gear_d+middle_gear_d/2-.6,(prop_gear_d-middle_gear_d)/2,0]){
        linear_extrude(7)circle(d=prop_gear_d);
        linear_extrude(200)circle(d=3.175);
    }
    translate([0,0,0])linear_extrude(7)circle(d=middle_gear_d);
    translate([middle_gear_d,0,0])linear_extrude(7)circle(d=middle_gear_d);

    
}

module motor(){
    linear_extrude(19)circle(d=23);
    translate([0,0,19])linear_extrude(4.5)circle(d=8.5);
    translate([0,0,19+4.5])linear_extrude(10)circle(d=2.3);
}

// main_hull();
scale(scale_1_144)hull_hollowed(a=true);
servo_9g();
translate([2.5,56,-19-15+7])motor();
translate([0,50,0])gear_box();
// translate([0,10.5,226-8])rotate([-90,0,0])turret_1();
// translate([0,6.5,44])rotate([-90,180,0])turret_1();
// translate([0,10,195])rotate([-90,90,0])tower_1();
// translate([0,6.5,174])rotate([-90,0,0])building();
// translate([0,6.5,165])rotate([-90,180,0])stack_1();
// translate([0,9,141])rotate([-90,180,0])torpedo_turret();
// translate([0,6.5,129])rotate([-90,180,0])tower_2();
// translate([0,6.5,102])rotate([-90,180,0])torpedo_turret();
// translate([0,10.5,190])rotate([-90,180,0])life_boats();
// translate([0,6.5,169])rotate([-90,180,0])life_boats(); // these should be changed to ships boats
// color("red")translate([-7.5,6.5,92])rotate([0,-90,-90])tower_3();
// translate([0,6.5,60])rotate([90,0,180])turret_2();