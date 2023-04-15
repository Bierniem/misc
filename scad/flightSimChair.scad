
#rotate(40,[1,0,0]) secondRing();
outerRing();

base();
//caster();

module caster(){
    color("black") linear_extrude(1) circle($fs = .5, $fa = 1,1);
    color("grey") difference(){
    translate([0,0,-.25]) linear_extrude(1.5) polygon([[-.5,0],[1.5,1],[1.5,-1]],$fs = .5, $fa = 1);
    translate([-.25,0,0]) linear_extrude(1) polygon([[0,0],[1.5,1],[1.5,-1]],$fs = .5, $fa = 1);
    }
}
module base(){
    translate([0,0,-25.4])linear_extrude(.75)circle(20,$fs = .5, $fa = 1);
}

module pivot(){
    color("grey") rotate(90,[1,0,0]) translate([0,0,-17]) linear_extrude(17*2) circle(.5,$fs = .1, $fa = 1);
}
module outerRing(){
    difference(){
        union(){
            translate([-11/2 - .75,0,-17.5]) rotate(90,[0,1,0]) linear_extrude(.75) square([15,35],center=true);
            translate([11/2,0,-17.5]) rotate(90,[0,1,0]) linear_extrude(.75) square([15,35],center=true);
        }
        translate([-13/2,0,0])rotate(90,[1,0,0])rotate(90,[0,1,0]) linear_extrude(height = 13) circle(14.76,$fs = .5, $fa = 1); 
    }
    
    translate([2,3,-17]) rotate(13,[1,0,0]) rotate(90,[0,1,0]) caster();
    translate([-11/2,0,0])rotate(90,[1,0,0])rotate(90,[0,1,0]) linear_extrude(height = 11) 
    difference()
    {
        circle(20.5,$fs = 1, $fa =20); 
        circle(18.75,$fs = 1, $fa = 20);
        translate([0,12,0])square(center = true,[44,44],$fs = 1, $fa = 1);

    }
    
}

module secondRing(){
    #pivot();
    rotate(0,[0,1,0])translate([2,0,0])pitchObj();
    translate([-3,0,0])rotate(90,[1,0,0])rotate(90,[0,1,0]) linear_extrude(height = 6) 
    difference()
    {
        circle(16.25,$fs = .5, $fa = 1); 
        circle(14.75,$fs = .5, $fa = 1);
        translate([0,19,0])square(center = true,[33,33],$fs = .5, $fa = 1);

    }
    
}

module pitchObj(){
    translate([0,3,0])innerRing();
    seat();
}

module innerRing(){
    rotate(90,[1,0,0]) linear_extrude(height = 6) 
    difference()
    {
        circle(10,$fs = .5, $fa = 1); 
        polygon([[0,-10],[10/tan(35),0],[10,10],[-10,10],[-10/tan(35),0]],$fs = .5, $fa = 1);

    }
    
}
module seat(){
    //the butt
    translate([cos(35)*17/2,0,sin(35)*17/2 -10]) rotate(-35,[0,1,0]) linear_extrude(.5)square([17,20],true);
    //the back
    translate([-cos(35)*15,0,sin(35)*15 -10]) rotate(35,[0,1,0]) linear_extrude(.5)square([30,20],true);
    //the front butt
    translate([cos(35)*17 - .7,0,sin(35)*17 -9.3]) rotate(55,[0,1,0]) linear_extrude(.5)square([2,20],true);
    //the back stop
    translate([-cos(35)*35+5,0,sin(35)*35-12.3]) rotate(-55,[0,1,0]) linear_extrude(.5)square([2,20],true);
    //the sides           
    translate([0,20/2,-10]) rotate(-35,[0,1,0])rotate(90,[1,0,0])  linear_extrude(.5)polygon([[0,0],[17.3,0],[17.3,2],[-30*sin(20)+2*sin(110),30*cos(20)-2*cos(110)],[-30*sin(20),30*cos(20)]]);   
    translate([0,-20/2,-10]) rotate(-35,[0,1,0])rotate(90,[1,0,0])  linear_extrude(.5)polygon([[0,0],[17.3,0],[17.3,2],[-30*sin(20)+2*sin(110),30*cos(20)-2*cos(110)],[-30*sin(20),30*cos(20)]]);  
}


