winchDiameter = 25;
winchHeight = 10;
winchWallHeight = 5;
winchWallTolerance=.05;
winchWallThickness = 1.5;
clutchWallThickness = 1.5;
clutchXYTolerance = -.05;
clutchZThickness = 1;
clutchZTolerance = .05;

toothDiameter = 5;
toothOffsetRatio = .5;
nteeth = 5;
winchCoreDiameter=5;
springThickness=.9;
springTurns=0;
springResolution=360;

servoHeadHeight = 3;
servoHeadDiameter=4;
servoScrewDiameter=.7;
servoScrewHeadDiameter=4;
servoScrewShank = 1;


module drawLine(point1,point2,thickness){
    hull(){
        radius=thickness/2;
        translate(point1)circle(radius,$fn=10);
        translate(point2)circle(radius,$fn=10);
    }
}

module spiral(thickness,mmPerTurn,nTurns,resolution){
    for (i=[1:resolution*nTurns]){
        angle = (i-1)/resolution*360;
        r=angle/360*mmPerTurn;
        prevPoint = [r*cos(angle),r*sin(angle)];
        angle = i/resolution*360;
        r=angle/360*mmPerTurn;
        point = [r*cos(angle),r*sin(angle)];
        drawLine(prevPoint,point,springThickness);
    }
}

module straightSpring(thickness,distance,resolution){
    for (i=[1:resolution]){
        prevpoint = [(i-1)/resolution*distance,0];
        point = [i/resolution*distance,0];
        drawLine(prevpoint,point,springThickness);
    }
}

module winchWall(){
    difference(){
        cylinder(h=winchWallThickness,r=clutchWallThickness+winchDiameter/2+winchWallHeight,$fn=100);
        cylinder(h = winchWallThickness, r =clutchWallThickness+winchDiameter/2-winchWallTolerance, $fn=100);
    }
}

module clutchOuter(){
    // outside of clutch
    difference(){
        difference(){
            cylinder(h=winchHeight-.02, r = winchDiameter/2+clutchWallThickness, $fn=100);
            cylinder(h=winchHeight+1,r=(winchDiameter-clutchWallThickness-toothDiameter/2)/2 ,$fn=100);
        }
        nNegTeeth=2*PI*(winchDiameter-clutchWallThickness-(1+toothOffsetRatio)*(toothDiameter/2))/toothDiameter;
        for (i=[0:nNegTeeth]){
            rotate([0,0,i*360/nNegTeeth]){
                translate([(winchDiameter-clutchWallThickness-(1+toothOffsetRatio)*(toothDiameter/2))/2,0,clutchZThickness]){
                    cylinder(h = winchHeight-2*clutchZThickness,r=toothDiameter/2,$fn=100);
                }
            }
        }
    }
}

module clutchInner(){
    // inside of clutch
    cylinder(h=winchHeight-2*clutchZThickness-2*clutchZTolerance, r=winchCoreDiameter/2, $fn=100);
    for (i = [0:nteeth]){
        rotate([0,0,50+i*360/nteeth]){
            rotate([0,0,90]){
                //mmPerTurn = ((winchDiameter-clutchWallThickness-clutchXYTolerance-(1+toothOffsetRatio)*(toothDiameter/2))/2)/springTurns;
                linear_extrude(height = winchHeight-2*clutchZThickness-2*clutchZTolerance){ 
                    //spiral(thickness =springThickness, mmPerTurn = mmPerTurn, nTurns = springTurns, resolution = springResolution);
                    straightSpring(thickness=springThickness, distance=(winchDiameter-clutchWallThickness-clutchXYTolerance-(1+toothOffsetRatio)*(toothDiameter/2))/2, resolution = springResolution);
                }
                //add the tooth to the end of the spring
                //toothAngle = springTurns*360;
                toothAngle = 0;
                //toothR = toothAngle/360*mmPerTurn;
                toothR = (winchDiameter-clutchWallThickness-clutchXYTolerance-(1+toothOffsetRatio)*(toothDiameter/2))/2;
                translate([toothR*cos(toothAngle),toothR*sin(toothAngle),0]){
                    rotate([0,0,180]){
                        difference(){
                            cylinder(h = winchHeight-2*clutchZThickness-2*clutchZTolerance, r = toothDiameter/2,$fn=100);
                            translate([springThickness,-toothDiameter/2,0]){
                                cube([toothDiameter,toothDiameter,winchHeight]);
                            }
                        }
                    }
                }
            }
        }
    }
}

module servoScrewPocket(){
    union(){
        cylinder(h=servoHeadHeight, r=servoHeadDiameter/2,$fn=10);
        cylinder(h=winchHeight, r=servoScrewDiameter/2, $fn=10);
        translate([0,0,servoHeadHeight+servoScrewShank]){
            cylinder(h=winchHeight,r=servoScrewHeadDiameter/2, $fn=100);
        }
    }
}


module spinTest(){
    for (i=[1:nteeth]){
        rotate([0,0,(i*360/nteeth)]){
            translate([i,0,0]){
                cylinder(1,1);
            } 
        } 
    }
}

//spinTest();
clutchOuter();
translate([winchDiameter+clutchWallThickness,0,0]){
    difference(){ 
        clutchInner();
        servoScrewPocket();
    }
}
translate([2*(winchDiameter+clutchWallThickness),winchDiameter+clutchWallThickness,0]){
    winchWall();
}
//spiral(thickness = 1, mmPerTurn = 10, nTurns=3, resolution = 360);