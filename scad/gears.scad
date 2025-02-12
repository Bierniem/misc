module gearTooth(toothBase,toothHeight,toothCut,toothTolerance){
    //make a trangle tooth and cut the top off
    translate([-toothBase/2,0,0]){ 
        difference(){ 
            polygon(points = [[0,0],[toothBase-toothTolerance,0],[(toothBase-toothTolerance)/2,toothHeight-toothTolerance]]);
            translate([0,toothCut*toothHeight]){  
                polygon(points = [[0,0],[toothBase-toothTolerance,0],[(toothBase-toothTolerance)/2,toothHeight-toothTolerance]]);
            }
        }
    }
}

module gear2d(toothBase,toothHeight,toothCut,toothTolerance,nteeth) {
    gearRadius = (toothBase * nteeth)/(2 * PI);
    for (t=[0:nteeth-1]) {
        rotate(t*360/nteeth){ 
            translate([0,gearRadius,0]){
                gearTooth(toothBase = toothBase, toothHeight = toothHeight, toothCut = toothCut, toothTolerance = toothTolerance);
            } 
        }
    }
}

//gear2d(toothBase = 2, toothHeight = 2, toothCut = .8, toothTolerance = .1, nteeth = 10);


module drawLine(point1,point2,thickness){
    hull(){
        radius=thickness/2;
        translate(point1)circle(radius,$fn=10);
        translate(point2)circle(radius,$fn=10);
    }
}

module window(){
    union(){
        linear_extrude(height = 2){ 
            //roundpart 
            union(){
                difference(){
                    difference(){
                        circle(r = 7,$fn=100);
                        circle(5.5,$fn=100);
                    }
                    translate([0,7,0]){ 
                        square([11,14],center=true);
                    }
                }
                //squarepart
                translate([0,7,0]){ 
                    difference(){
                        square(14,center=true);
                        translate([0,-1.5,0]){ 
                            square([11,14],center=true);
                        }
                    }
                }
            }
        }
        linear_extrude(height = 1){ 
            //bars
            drawLine(point1 = [0,-6.5], point2 = [0,13.5], thickness = 1);
            drawLine(point1 = [-6.5,0], point2 = [6.5,0], thickness = 1);
            drawLine(point1 = [-6.5,6.5], point2 = [6.5,6.5], thickness = 1);
        }
    }
}

module sideWindow(){
    union(){
        linear_extrude(height = 2){ 
            //roundpart 
            union(){
                difference(){
                    difference(){
                        circle(r = 7,$fn=100);
                        circle(5.5,$fn=100);
                    }
                    translate([0,7,0]){ 
                        square([11,14],center=true);
                    }
                }
                //sqare part
                drawLine(point1 = [6.3,0], point2 = [6.3,11.5], thickness = 1.5);
                drawLine(point1 = [6.3,11.5], point2 = [-6.3,13.5], thickness = 1.5);
                drawLine(point1 = [-6.3,13.5], point2 = [-6.3,0], thickness = 1.5);
            }
        }
        linear_extrude(height = 1){ 
            //bars
            drawLine(point1 = [0,-6.5], point2 = [0,12.5], thickness = 1);
            drawLine(point1 = [-6.5,0], point2 = [6.5,0], thickness = 1);
            drawLine(point1 = [-6.5,6.5], point2 = [6.5,6.5], thickness = 1);
        }
    }
}


module block(pulleyRadius,pulleyDepth,pulleyPinRadius){
    //ellipse
    scale([1.5,5])cylinder(h = 1.5, r=pulleyRadius,$fn=120);
}




//translate(v = [20,0,0])yolk(bore=.9,radius1=1.6,radius2=1.1);
//swivelGun(bore = 1, radius1 = 2, radius2=1.5, length = 15);
//translate([10,0,0])swivelGun(bore=.9,radius1=1.6,radius2=1.1,length=15); 
//translate([30,0,0])swivelGun(bore=.5,radius1=.8,radius2=.6,length=12); 
//translate(v = [40,0,0])yolk(bore=.5,radius1=.8,radius2=.6);
//rotate_extrude()translate([10,0,0])circle(10);
//block(pulleyRadius=3, pulleyDepth = 2.2, pulleyPinRadius = .6);

//deadeye(radius = 1.7, depth = 2, holeRadius = .4, nholes = 3);
//translate([10,0,0]){deadeye(radius = 1.7, depth = 2, holeRadius = .4, nholes = 2);}
//translate([20,0,0]){deadeye(radius = 1.7, depth = 2, holeRadius = .6, nholes = 1);}

//translate([20,0,0]){
//    sideWindow();
//} 
//window();
