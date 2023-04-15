//treadmill roller fitting
module connector(ir,or,lenFactor){
    linear_extrude(height = lenFactor*ir)
    circle(or,$fn = 100);

}
module hollow_connector(ir,or,lenFactor){
    union(){
        //full length hollowness
        linear_extrude(height = 4*ir)
        circle(ir - (or-ir),$fn = 100);
        //shoulder cutback for improving overhang print
        translate([0,0,ir+(or-ir)/2])
            cylinder((or-ir)/2,ir-(or-ir),ir,$fn=100);
        //hollow for pipe
        translate([0,0,or]){
            linear_extrude(height =4*ir)
           circle(ir,$fn = 100);
            }
        //trim top edge
        translate([0,0,lenFactor*ir])
            linear_extrude(height=ir)
            circle(or,$fn=100);
        }
}
module sphere_middle(ir,or){
    difference(){
    sphere(or,$fn = 100);
    sphere(ir-(or-ir),$fn = 100);
    }
}
    

module old(){
difference(){
union(){
linear_extrude(height = .1*25.4)
circle(1.18*25.4/2,$fn=100);
linear_extrude(height = .75*25.4)
difference(){
circle(1.035*25.4/2,$fn=100);
circle(.33*25.4/2,$fn=100);
}
}
linear_extrude(height = 25.4*.23)
translate([0,0,0])
circle((.5*25.4/2)/cos(180/6), $fn=6);
}
}
module 2_fitting(ir,or,angle,lenFactor){
difference(){
    union(){
        connector(ir,or,lenFactor);
        sphere_middle(ir,or);
        rotate([angle,0,0]) connector(ir,or,lenFactor);
    }
    union(){
        hollow_connector(ir,or,lenFactor);
        rotate([angle,0,0]) hollow_connector(ir,or,lenFactor);
    }
}
}

module 3_fitting_inline(ir,or,angle,angle2,lenFactor){
difference(){
    union(){
        connector(ir,or,lenFactor);
        sphere_middle(ir,or);
        rotate([angle,0,0]) connector(ir,or,lenFactor);
        rotate([angle2,0,0]) connector(ir,or,lenFactor);
    }
    union(){
        hollow_connector(ir,or,lenFactor);
        rotate([angle,0,0]) hollow_connector(ir,or,lenFactor);
        rotate([angle2,0,0]) hollow_connector(ir,or,lenFactor);
    }
}
}    
ir = 21.5/2;
or = ir+2.5;
lenFactor = 2.5;
//2_fitting(ir,or,50,2.5);
//translate([3*or,0,0])
//    3_fitting_inline(ir,or,40,180,2.5);
//translate([6*or,0,0])
//    2_fitting(ir,or,90,2.5);
//hollow_connector(ir,or);


difference(){
    union(){
        connector(ir,or,3.5);
        sphere_middle(ir,or);
        rotate([40,0,0]) connector(ir,or,3.5);
        rotate([180,0,0]) connector(ir,or,lenFactor);
    }
    union(){
        hollow_connector(ir,or,3.5);
        rotate([40,0,0]) hollow_connector(ir,or,3.5);
        rotate([180,0,0]) hollow_connector(ir,or,lenFactor);
    }
}
translate([100,0,0]){
    2_fitting(30,35,75,1);
}

    
