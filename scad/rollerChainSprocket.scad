//sprockets
pitch = .25 * 25.4;
rollerWidth = .125 * 25.4;
rollerDiameter = .13 * 25.4;
overallWidth=.306 * 25.4;
plateHeight = .228 * 25.4;
plateThickness = .029 * 25.4;
pinDiameter = .091 * 25.4;
toothWiggle = .5;
extraThickness = 7.5;

bevel = 1;
bevelAngle = 30;
nteeth = 18;

sprocketRadius = nteeth*pitch/(2*3.14159);

module bevelTrapezoid(){
    translate([-.5*(rollerDiameter+toothWiggle),0
    ,0])
    polygon(points = [[0,0],[-bevel*sin(bevelAngle),bevel],[rollerWidth+toothWiggle+bevel*sin(bevelAngle),bevel],[rollerDiameter+toothWiggle,0]]);
}

//make the sprocket part
module sprocketPart(){
intersection(){
linear_extrude(rollerWidth-toothWiggle){
difference(){
circle(sprocketRadius+bevel,$fn=360);
for (i=[1:nteeth]){
translate([sprocketRadius*cos(i*360/nteeth),sprocketRadius*sin(i*360/nteeth),0])
union(){
circle((rollerDiameter+toothWiggle)/2,$fn=360);
rotate([0,0,i*360/nteeth-90]) bevelTrapezoid();
}}}}
//remove the face bevels
union(){
    cylinder(h = bevel*sin(bevelAngle),r1 = sprocketRadius,r2 = sprocketRadius+bevel);
    translate([0,0,rollerWidth-toothWiggle-bevel*sin(bevelAngle)])
    cylinder(h = bevel*sin(bevelAngle),r2 = sprocketRadius,r1 = sprocketRadius+bevel);
    translate([0,0,bevel*sin(bevelAngle)])
    cylinder(h = rollerWidth-toothWiggle-2*bevel*sin(bevelAngle),r1=sprocketRadius+bevel,r2=sprocketRadius+bevel);
}
}
}

module extraBody(size){
    linear_extrude(extraThickness){
    circle((.5*size)/cos(180/6)+2,$fn=6);
    }
}

module roundHole(size){
    linear_extrude(height = 25.4*.23){
        circle((.5*size), $fn = 360);
    }
}

module nutHole(){
    linear_extrude(height = 25.4*.23){
        circle((.5*25.4/2)/cos(180/6), $fn = 6);
    }
}

module shaftHole(){
    linear_extrude(height=100){
        circle(.33*25.4/2,$fn=100); 
    }
}



difference(){
union(){
sprocketPart();
extraBody(22.01);
}
union(){
//nutHole();
roundHole(22.01);
shaftHole();
}
}
//test();