winchDiameter = 25;
winchHeight = 10;
winchWallHeight = 5;
winchWallTolerance=.05;
winchWallThickness = 1.5;
clutchWallThickness = 1.5;
clutchXYTolerance = -.05;
clutchZThickness = 1;
clutchZTolerance = .05;

toothDiameter = 3;
toothOffsetRatio = .5;
nteeth = 5;

springThickness=.8;
springTurns=0;
springResolution=360;

winchCoreDiameter=8;
servoHeadHeight = 3;
servoHeadDiameter=4.9;
servoScrewDiameter=1.8;
servoScrewHeadDiameter=5;
servoScrewShank = 1.5;


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
module sinSpring(thickness,mmPerTurn,distance,resolution,sinScaler){
    for (i=[1:resolution]){
        r=distance*(i-1)/resolution;
        prevPoint = [r,sinScaler*sin(r*360/mmPerTurn)];
        r=distance*i/resolution;
        point = [r,sinScaler*sin(r*360/mmPerTurn)];
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
                    //straightSpring(thickness=springThickness, distance=(winchDiameter-clutchWallThickness-clutchXYTolerance-(1+toothOffsetRatio)*(toothDiameter/2))/2, resolution = springResolution);
                    sinSpring(thickness=springThickness, mmPerTurn = 2, distance = (winchDiameter-clutchWallThickness-clutchXYTolerance-(1+toothOffsetRatio)*(toothDiameter/2))/2, resolution = springResolution, sinScaler = 2);
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

module vPulley(height,radius){
    // make a v pulley and run a line along the length of the boat, so that the clutch is the line against the pulley
    // could do multiple wraps on the pully if it is slipping too easily
    union(){
        //cone up
        cylinder(h = height, r1 = radius,r2=radius/2);
        cylinder(h = height, r1 = radius/2, r2=radius);
    }
}

module freeWheelInsert(){
    // make a bearing insert to have freeWheeling vPulley ie for the other end of the boat from the servo
    // intersection this with the vPulley to selective remove
}

difference(){
    vPulley();
    servoScrewPocket();
}

module nutSpace(nutSize,nutThickness,boltRad,tolerance){
    extraThickness = 1;
    union(){
        translate([nutSize+extraThickness/2,-nutThickness/2,nutSize+extraThickness/2])rotate([-90,0,0])cylinder(r=boltRad+tolerance,h=nutThickness*2+extraThickness,$fn=120);
        hull(){
            translate([nutSize+extraThickness/2,(nutThickness+extraThickness)/2-nutThickness/2,nutSize+extraThickness/2])rotate([-90,0,0])cylinder(r=nutSize+tolerance,h=nutThickness+tolerance,$fn=6);
            translate([0,(nutThickness+extraThickness)/2-nutThickness/2,nutSize+extraThickness/2])rotate([-90,0,0])cylinder(r=nutSize+tolerance,h=nutThickness+tolerance,$fn=6);
        }
    }
}

module nutBlock(nutSize,nutThickness,boltRad,tolerance) {
    extraThickness=1;
    difference() {
        cube([nutSize*2+extraThickness,nutThickness+extraThickness,nutSize*2+extraThickness]);
        nutSpace(nutSize = nutSize, nutThickness = nutThickness, boltRad = boltRad, tolerance = tolerance);
    }
}

module servoMount(){
    screwHolesDistance=27;
    screwHolesPlateMax = 32.5;
    bodyLong = 23;
    bodyWidth = 12;
    topRound = 11.5;
    topSmall = 5.8;
    topMax = 14.8;
    nutSize = 6.25/2;
    nutThickness = 2.35;
    boltRad = 3/2;
    //block around the servo
    linear_extrude(3){
        difference(){
            square(size=[screwHolesPlateMax,bodyWidth+5.5]);
            union(){
                translate([(screwHolesPlateMax-bodyLong-.5)/2,(bodyWidth+5.5-bodyWidth-.5)/2,0])square(size=[bodyLong+.5,bodyWidth+.5]);
                translate([(screwHolesPlateMax-screwHolesDistance)/2,(bodyWidth+5.5)/2,0])circle(r = .7);
                translate([screwHolesPlateMax-(screwHolesPlateMax-screwHolesDistance)/2,(bodyWidth+5.5)/2,0])circle(r = .7);
            }
        }
    }
    //block for a nut to adjust the winch
    //raise the blocks so that the screw is in line with the belt
    //translate([0,0,35])rotate([-90,0,0])rotate([0,0,90])nutSpace(nutSize,nutThickness,boltRad,tolerance=.1);

    // translate([8,bodyWidth+.5+5/2,0])difference(){
    //     cube(size=[nutThickness+2,nutSize*2+1,15]);
    //     translate([nutThickness+2,0,14])rotate([-90,0,0])rotate([0,0,90])nutSpace(nutSize = nutSize, nutThickness = nutThickness, boltRad = boltRad, tolerance = .1);
    // }
    // translate([8,-(nutThickness*2+1+3.8)/2,0])difference(){
    //     cube(size=[nutThickness+2,nutSize*2+1,15]);
    //     translate([nutThickness+2,0,14])rotate([-90,0,0])rotate([0,0,90])nutSpace(nutSize = nutSize, nutThickness = nutThickness, boltRad = boltRad, tolerance = .1);
    // }
}

module adjustableServoBeltClutch(winchAxelRadius){
    //make a screw adjustable belt clutch for servos
    difference(){
        union(){
            servoMount();
            translate([7.6,(12+5.5)/2,11.5])difference(){vPulley(4.4,5);servoScrewPocket();}
            translate([18.6,(12+5.5)/2,11.5])vPulley(4.4,5);
            translate([18.6,(12+5.5)/2,17])winch(winchRadius=10,winchHeight=7);
            translate([18.6,(12+5.5)/2,15.7])cylinder(r=5,h=2);

        }
        translate([18.6,(12+5.5)/2,11.5])cylinder(h=winchHeight+10+2+5,r=winchAxelRadius,$fn=360);
    }
   
}

module slidyPart(winchAxelRadius){
    difference(){
        translate([0,17.5/2-25/2,0]) cube([10,25,27]);
        union(){
            translate([0,0,3]) cube([10,17.75,3.2]);
            translate([10/2,17.5/2,-3])cylinder(h=30,r=winchAxelRadius,$fn=360);
            translate([0,2.5,-3])cube([23,12.5,11]);
            translate([0,2.5,11])cube([23,12.5,6]);
            translate([0,17.5/2-21/2,17])cube([23,21,7.5]);
            translate([5,-5,17+7/4])rotate([-90,0,0])cylinder(h=35,r=.7);
            translate([5,-5,17+7*3/4])rotate([-90,0,0])cylinder(h=35,r=.7);
        }
    }
}

module winch(winchRadius,winchHeight){
    difference(){
        rotate_extrude(){ 
            difference(){
                square(size = [winchRadius,winchHeight]);
                union(){
                    translate([winchRadius,winchHeight/4*1.02,0]) hull(){
                        circle(r=winchHeight/4*.85,$fn=120);
                        translate([-winchHeight/4*1.3,0,0])circle(r=winchHeight/4*.5,$fn=120);
                    }
                    translate([winchRadius,3*winchHeight/4*(1/1.02),0]) hull(){
                        circle(r=winchHeight/4*.85,$fn=120);
                        translate([-winchHeight/4*1.3,0,0])circle(r=winchHeight/4*.5,$fn=120);
                    }
                }
            }
        }
        translate([winchRadius/2,winchRadius,winchHeight/4])rotate([90,0,0]) cylinder(h = winchRadius*2, r = .7);
        translate([winchRadius/2,winchRadius,3*winchHeight/4]) rotate([90,0,0])cylinder(h = winchRadius*2, r = .7);
    }
}

module belayPin() {
  //main body
    hull() {
        translate([0,0,-2])sphere(1,$fn=36);
        translate([0,0,8.5])sphere(1.1,$fn=36);
    }
    hull(){
        translate([0,0,8.5])sphere(1.1,$fn=36);
        translate([0,0,10])sphere(1.5,$fn=36);
    }
    translate([0,0,6.5])cylinder(h=1,r=1.5);
}

module mastBelayPinBlock(){
    difference(){
        cylinder(2,r=25);
        union(){
            cylinder(h = 3, r = 13);
            translate([-25,5,0])cube(size=[50,50,3]);
            for (i=[0:6]) {
               translate([-20*cos(i*180/6),-20*sin(i*180/6),0])cylinder(h=3,r=1.1,$fn=36);
            }
        }
    }
    for(i=[0:5]){
        angle = i*180/6+180/12;
        translate([-15.2*cos(angle),-15.2*sin(angle),-23])cylinder(h=23,r=2.5);
    }
}

module torus(radius,thicknessRadius){
    rotate_extrude()translate([radius,0,0])circle(thicknessRadius,$fn=$fn);
}

module deadeye(radius,depth,holeRadius,nholes){
    difference(){
        cylinder(h=depth,r=radius,$fn=120);

        union(){
            translate([0,0,depth/2])torus(radius=radius,thicknessRadius=holeRadius,$fn=120);
            for (h=[0:nholes-1]){
                rotate(h*360/nholes){
                    if (nholes != 1){
                        translate([(radius-holeRadius)/2,0]){
                            cylinder(depth*2,r=holeRadius,$fn=120);
                        }
                    } 
                    else{
                        cylinder(depth*2,r=holeRadius,$fn=120);
                    }
                } 
            }
        }
    }
}

module block(r1,r2,h,ropeRadius){
    difference(){
        hull(){
            translate([0,-r1/2-r2,0])cylinder(h=h,r=r2);
            translate([0,r1/2-r2,0])cylinder(h=h,r=r2);
        }
        union(){
            translate([0,-r1/2-ropeRadius/2-r2,h/2])torus(r2,ropeRadius);
            translate([0,r1/2+ropeRadius/2-r2,h/2])torus(r2,ropeRadius);
        }
    }
    translate([0,-r1/2-ropeRadius/2-r2,-ropeRadius/2])cylinder(h = h+ropeRadius,r=ropeRadius);
    translate([0,r1/2+ropeRadius/2-r2,-ropeRadius/2])cylinder(h = h+ropeRadius,r=ropeRadius);
}

module bellMuzzle()
    translate([0,0,length+radius1+2*bore*.7]){ 
        rotate([180,0,0]){
            rotate_extrude(convexity=10,$fn=120){ 
                translate([radius2+bore,0,0]){
                    difference(){
                        circle(r=radius2,$fn=120);
                        translate([radius2,bore/2,0])circle(r=radius2+bore,$fn=120);
                    }
                }
            }
        }
    }

module swivelGun(bore,radius1,radius2,length){
    //barrel
    translate([0,0,radius1+2*bore*.7]){
        difference(){
            cylinder(h = length, r1 = radius1, r2=radius2,$fn=120);
            translate([0,0,length/2+.01]) cylinder(h = length/2, r = bore,$fn=120);
        }
    }
    //muzzle
    translate([0,0,length+radius1+2*bore*.7]){ 
        torus(radius = radius2, thicknessRadius = bore/2.5,$fn=12);
    }
    translate([0,0,length+radius1+2*bore*.7-bore/2]){
        torus(radius=radius2,thicknessRadius=bore/3.5,$fn=12);
    }
    //breech
    translate([0,0,radius1+radius1/2-.1])cylinder(h=radius1/2,r2=radius1,r1=bore/2,$fn=120);
    translate([0,0,radius1+radius1/2+.1])sphere(bore*.7,$fn=120);
    translate([0,0,radius1+radius1*.9])torus(radius1-bore/3,bore*.45,$fn=36);
    //handle
    hull(){
        translate([-bore,0,radius1+radius1/2])sphere(bore*.7,$fn=36);
        translate([-2*bore,0,radius1+radius1/2-3*bore])sphere(bore*.6,$fn=36);
    }
        hull(){
        
        translate([-2*bore,0,radius1+radius1/2-3*bore])sphere(bore*.6,$fn=36);
        translate([-bore,0,radius1+radius1/2-12*bore])sphere(bore*.6,$fn=36);
    }
    translate([-bore,0,radius1+radius1/2-12*bore])sphere(bore*.9,$fn=36);
    //touchhole
    translate([radius1-(2*bore/3),0,radius1+3.5*bore]){
        rotate([0,90,0]){
            difference(){
                cylinder(h=bore,r=bore/2);
                cylinder(h=bore,r=bore/4);
            }
        }
    }
    //mountpins
    translate([0,(radius1+bore*2),radius1+2*bore*.7+length/3])rotate([90,0,0])cylinder(h=(radius1+bore*2)*2,r=bore*.7,$fn=120);
    translate([0,0,radius1+2*bore*.7+length/3])torus(radius1*.7,bore*.7,$fn=36);
    //bands

}

module halfCircle(radius){
    difference(){
        circle(radius,$fn=120);
        translate([-radius,0,0]) 
        square(radius*2);
    }
}

module yolk(bore,radius1,radius2){
    //yolk
    difference(){
        union(){
            translate([radius1+bore,0,0]){ 
                rotate([0,90,0]){
                        cylinder(h = bore, r = bore*1.5,$fn=120);
                    }
                }

            rotate_extrude(angle=90,$fn=120){
                translate([radius1+bore,0,0]){ 
                    rotate([0,0,90]){
                        halfCircle(radius = bore);
                    }
                }
            }
            translate([0,radius1+bore,0]){
                rotate([-90,0,0]){
                    linear_extrude(25.4){
                        rotate([0,0,90]){
                            halfCircle(radius = bore);
                        }
                    } 
                }
            }
        }
        translate([radius1+bore,0,0]){ 
            rotate([0,90,0]){
                cylinder(h=bore,r=bore*.8,$fn=120);
            }
        }
    }
}

module sweep(bladeWidth,bladeThickness,bladeLen,shaftLen,shaftRadius,handleRadius,handleLen,$fn){
    hull(){
        translate([-bladeWidth/2,bladeWidth/2-bladeThickness,0])cylinder(h=bladeThickness,r=bladeThickness,center=true);
        translate([-bladeWidth/2,-bladeWidth/2+bladeThickness,0])cylinder(h=bladeThickness,r=bladeThickness,center=true);
    }
    hull(){
        cube(size=[bladeWidth,bladeWidth,bladeThickness],center=true);
        translate([bladeLen,0,0])cylinder(h=bladeThickness+shaftRadius/3,r=shaftRadius,center=true);
    }
    hull(){
        sphere(bladeThickness/2);
        translate([bladeLen,0,0])sphere(shaftRadius);
        translate([shaftLen+bladeLen,0,0])sphere(shaftRadius);
    }
    hull(){
        translate([shaftLen+bladeLen,0,0])sphere(handleRadius);
        translate([shaftLen+bladeLen+handleLen,0,0])sphere(handleRadius);
    }
}

module anchor(flukeWidth,flukeLength,flukeThickness,armLength,armRadius,shankLength,shankRadius,stockLength,stockThickness){
    //fluke
    translate([0,armLength/2,0]){
        for (i=[0:1]){

            rotate([0,0,i*180]){
            translate([0,i*armLength,0]){
                hull(){
                    translate([0,flukeLength/2,flukeThickness/3+flukeLength/2*sin(25)])sphere(flukeThickness/2,$fn=6);
                    translate([0,0,-armLength*.15*sin(0)])sphere(armRadius,$fn=6);
                }
                for (j=[0:30]){
                    hull(){
                        translate([0,-j*armLength/30/2,-armLength*.15*sin(j*180/30/2)])sphere(armRadius,$fn=6);
                        translate([0,-(j+1)*armLength/30/2,-armLength*.15*sin((j+1)*180/30/2)])sphere(armRadius,$fn=6);
                    }
                }
                rotate([25,-5,0])
                hull(){
                    translate([flukeWidth/2-flukeWidth/4,0,0])cylinder(h = flukeThickness*1.2, r = flukeWidth/4,$fn=12);
                    translate([0,flukeLength-flukeThickness,0])cylinder(flukeThickness,r=flukeThickness,$fn=12);
                }
                rotate([25,5,0])
                hull(){
                    translate([-flukeWidth/2+flukeWidth/4,0,0])cylinder(h = flukeThickness*1.2, r = flukeWidth/4,$fn=12);
                    translate([0,flukeLength-flukeThickness,0])cylinder(flukeThickness,r=flukeThickness,$fn=12);
                }
            }
            }
        }   
    }
    //shank
    difference(){
        hull(){
            translate([0,0,-armLength*.15*sin(30*180/30/2)])sphere(shankRadius,$fn=8);
            translate([0,0,shankLength-armLength*.15*sin(30*180/30/2)])sphere(shankRadius,$fn=8);
        }
        translate([-shankRadius*2,0,shankLength-shankRadius*1.1-armLength*.15*sin(30*180/30/2)])rotate([0,90,0])cylinder(h = shankRadius*3,r=shankRadius*.45,$fn=8);
    }
    //stock
    translate([0,0,shankLength-shankRadius*1.1-stockThickness-armLength*.15*sin(30*180/30/2)])
    rotate([0,0,90]){
        for (i=[0:1]){
            rotate([0,0,i*180]){
                hull(){
                    translate([0,stockLength/2,stockThickness*.1])cube(stockThickness*.65,center=true);
                    translate([0,0,0])cube(stockThickness,center=true);
                }
                translate([0,stockLength/6,stockThickness*(.05)])cube([stockThickness,stockThickness/5,stockThickness],center=true) ;
                translate([0,stockLength/3.5,stockThickness*.05])cube([stockThickness*.9,stockThickness/5,stockThickness*.9],center=true) ;
            }
        }
    }

}
module springHolderA(innerRadius){
cylinder(h = innerRadius*2.5, r = innerRadius);
translate([0,innerRadius,innerRadius]) rotate([90,0,0])cylinder(h = innerRadius*2.5, r = innerRadius); 
}

module servoPulleyWithTensioner(pulleyRadius,tensionerArmLen,){
    //servo pulley
    translate([0,0,15])
    difference(){
        cylinder(h = pulleyRadius, r = pulleyRadius);
        union(){
            translate([0,0,pulleyRadius/2])torus(radius = pulleyRadius*1.3, thicknessRadius = pulleyRadius/2,$fn=12);
            servoScrewPocket();
        }
    }

    //tensioner
    //spring mount
    difference(){ 
        union(){
            servoMount();
            translate([4,0,0])springHolderA(innerRadius = 2);
        }
        translate([4,0,0])cylinder(h=6,r=1);
    }
    //arm
    translate([4,0,2.5*2+.1]){
        rotate([0,180,190]){
            cylinder(h=2.5*2,r=.9);
            translate([0,30,-8])cylinder(h=6,r=.9);
            hull(){
                translate([0,0,-2])cylinder(h=2,r=2);
                translate([0,30,-2])cylinder(h=2,r=2);
            }
            translate([-2,12,3]){
                rotate([0,90,0])springHolderA(innerRadius=2);
                translate([2,0,-3])cylinder(h=4,r=2);
            }
            translate([0,30,-5]){
                difference(){
                    cylinder(h = pulleyRadius/2, r = pulleyRadius/2);
                    union(){
                        translate([0,0,pulleyRadius/2/2])torus(radius = pulleyRadius/2*1.3, thicknessRadius = pulleyRadius/2/2,$fn=12);
                        cylinder(h=10,r=1);
                    }
                }
            }
        }
    }


}

//belayPin();
//translate([0,0,10])mastBelayPinBlock();
//translate([50,0,0])deadeye(radius = 1.7, depth = 1.5, holeRadius = .44, nholes = 3);
servoPulleyWithTensioner(pulleyRadius = 5, tensionerArmLen = 15,$fn=36);
translate([60,0,0])block(r1=2,r2=1.7,h=1.5,ropeRadius=.55,$fn=36);
translate([-90,0,0])anchor(flukeWidth=300/48,flukeLength=300/48,flukeThickness=40/48,armLength=1600/48,armRadius=50/48,shankLength=2100/48,shankRadius=65/48,stockLength=2200/48,stockThickness=200/48);
//translate([-70,0,0])sweep(bladeWidth=200/48,bladeThickness=38/48,bladeLen=700/48,shaftLen=2500/48,shaftRadius=30/48,handleRadius=20/48,handleLen=330/48,$fn=12);
//translate([-70,-20,0])sweep(bladeWidth=250/48,bladeThickness=38/48,bladeLen=1000/48,shaftLen=5500/48,shaftRadius=38/48,handleRadius=20/48,handleLen=700/48,$fn=12);
//translate([-70,-40,0])sweep(bladeWidth=250/48,bladeThickness=38/48,bladeLen=1000/48,shaftLen=7000/48,shaftRadius=38/48,handleRadius=20/48,handleLen=700/48,$fn=12);
//translate([-50,20,0])swivelGun(bore=.8,radius1=1.7,radius2=1.2,length=20); 
//translate([0,0,9.5]){
//   translate([-50,20,0])rotate([0,0,90])yolk(bore=.9,radius1=1.7,radius2=1.2);
//    translate([-50,20,0])rotate([0,180,90])yolk(bore=.9,radius1=1.7,radius2=1.2);
//}
//winch thing
//adjustableServoBeltClutch(winchAxelRadius = 1);
//translate([40,0,0])slidyPart(winchAxelRadius=1);

//nutBlock(nutSize = 2, nutThickness = 2, boltRad = 1, tolerance = .1);
//spinTest();
//clutchOuter();
//translate([winchDiameter+clutchWallThickness,0,0]){
//    difference(){ 
//        clutchInner();
//        servoScrewPocket();
//    }
//}
//translate([2*(winchDiameter+clutchWallThickness),winchDiameter+clutchWallThickness,0]){
//    winchWall();
//}
//spiral(thickness = 1, mmPerTurn = 10, nTurns=3, resolution = 360);