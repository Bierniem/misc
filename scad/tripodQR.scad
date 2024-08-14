module base(x1,x2,z){
union(){    
    translate([0,0,2])
    rotate([0,0,45])
        cylinder(z-2,x1/2,x2/2,$fn=4);
    rotate([0,0,45])
        cylinder(2,x1/2,x1/2,$fn=4);
}
}
module top(r,z){
    difference(){
        cylinder(z,r,r,$fn=100);
        translate([r+r/10,r,z-.7/4*25.4-.5*25.4])
        rotate([90,0,0])
        cylinder(r*2,25.4*.7/2,25.4*.7/2,$fn=100);
    }
}
module between(r1,r2,z){
    cylinder(z,r1,r2,$fn=100);
}


base(60.1,60.1-60.1/5,10);
translate([0,0,10])
between((60.1-60.1/5)/2/sqrt(2),40/2,5);
translate([0,0,10+5]) 
top(40/2,1.5*25.4);

