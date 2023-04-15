pitch = .25 * 25.4;
rollerWidth = .125 * 25.4;
rollerDiameter = .13 * 25.4;
overallWidth=.306 * 25.4;
plateHeight = .228 * 25.4;
plateThickness = .029 * 25.4;
pinDiameter = .091 * 25.4;
toothWiggle = .5;
extraThickness = 8;
toothFineness = .1;
tolerance = .5;

//make the male pin thick such that the cross section is == to female pin not including tolerance
pinCs = 3.14159*pow(rollerDiameter/2,2);
malePinDiameter = (sqrt(pinCs/2)/3.14159)*2;


module malePin(d){
    translate([0,0,-tolerance])
    cylinder(h = tolerance*2+rollerWidth+plateThickness*2,r1 = d/2,r2=d/2,$fn=36);
}

module femalePin(){
    translate([0,0,plateThickness*2])
    difference(){
    cylinder(h = rollerWidth,r1=rollerDiameter/2,r2=rollerDiameter/2,$fn=36);
    malePin(malePinDiameter+tolerance);
}
}
module platePart(){
    
    linear_extrude(plateThickness)
    union(){
    polygon(points=[[0,-plateHeight/2],[0,plateHeight/2],[pitch/2,plateHeight/2-plateThickness],[pitch/2,-plateHeight/2+plateThickness]]);
    translate([pitch/2-tolerance,0,0])
    circle(plateHeight/2 - plateThickness,$fn=36);
    }
}

module plate(){
    union(){
    //bottom female
    translate([0,0,plateThickness])
    difference(){
    platePart();
    translate([pitch/2,0,0])
    malePin(malePinDiameter+tolerance);
    }
    //top female
    translate([0,0,plateThickness*2+rollerWidth])
    difference(){
    platePart();
    translate([pitch/2,0,0])
    malePin(malePinDiameter+tolerance);
    }
    
    //bottom male
    rotate(180)
    translate([0,0,-tolerance])
    platePart();
    
    //top male
    translate([0,0,plateThickness*3+rollerWidth+tolerance])
    rotate(180)
    platePart();
    
    //weld
    translate([0,plateHeight/2,plateThickness-tolerance/2])
    rotate([90,0,0])
    cylinder(h=plateHeight,r=(plateThickness*2+tolerance)/2,$fn=36);
    
    translate([0,plateHeight/2,plateThickness*3+rollerWidth+tolerance/2])
    rotate([90,0,0])
    cylinder(h=plateHeight,r=(plateThickness*2+tolerance)/2,$fn=36);
}
}

module link(){
    plate();
    translate([pitch/2,0,0])
    femalePin();
    translate([-pitch/2,0,plateThickness])
    malePin(malePinDiameter);
}

module linkSnap(){
    difference(){
    link();
    translate([pitch/2-malePinDiameter/2,0,0])
    linear_extrude([0,0,overallWidth])
    polygon(points=[[0,0],[malePinDiameter,0],[malePinDiameter,plateHeight/2],[0,plateHeight/2]]);
    }
}
rotate([0,0,180])linkSnap();
for(i = [1:16])
translate([pitch*i,0,0])rotate([0,0,180])link();