module solidFan(squareSize,cornerRad,depth){
    union(){
        translate([(-squareSize+cornerRad)/2,(-squareSize+cornerRad)/2,0])cube([squareSize-cornerRad,squareSize-cornerRad,depth]);
        //make rounded corners
        hull(){
            translate([squareSize/2,squareSize/2,0])cylinder(h=depth,r=cornerRad,$fn=100);
            translate([-squareSize/2,squareSize/2,0])cylinder(h=depth,r=cornerRad,$fn=100);
            translate([-squareSize/2,-squareSize/2,0])cylinder(h=depth,r=cornerRad,$fn=100);
            translate([squareSize/2,-squareSize/2,0])cylinder(h=depth,r=cornerRad,$fn=100);
        }
    }
}

module fan(diameter){
    depth = 25;
    cornerRad = 6;
    squareSize = diameter-cornerRad*2;
    holeInset = 6;
    holeRad = 2;
    difference(){
        solidFan(squareSize,cornerRad,depth);
        union(){
            cylinder(h = depth+1, r = (diameter-2)/2);
            translate([squareSize/2,squareSize/2,0])cylinder(h=depth+1,r=holeRad);
            translate([-squareSize/2,squareSize/2,0])cylinder(h=depth+1,r=holeRad);
            translate([-squareSize/2,-squareSize/2,0])cylinder(h=depth+1,r=holeRad);
            translate([squareSize/2,-squareSize/2,0])cylinder(h=depth+1,r=holeRad);
        }
    }
}



module funnelThing(diameterFan,diameterHose,depth,cornerRad,squareSize,thickness=4){
    difference(){
        union(){
            hull(){
                cylinder(h=diameterHose/2,r=diameterHose/2);
                translate([0,0,depth/2+5])solidFan(squareSize+thickness*2,cornerRad,depth/2);
            }
            translate([0,0,depth/2])solidFan(squareSize+thickness*2,cornerRad,depth/2+1);
        cylinder(h=diameterHose,r=diameterHose/2);
        //rebate the edge so the halves can slip inside eachother
        //translate([0,0,depth/2-thickness/2])difference(){
        //    solidFan(squareSize+thickness*2,cornerRad,thickness/2);
        //   solidFan(squareSize+thickness+.2,cornerRad,thickness/2);
        //}
        }
        union(){
            hull(){
                cylinder(h=diameterHose/2,r=diameterHose/2);
                solidFan(squareSize,cornerRad,depth);
            }
        cylinder(h=diameterHose+1,r=diameterHose/2-thickness);
        translate([diameterFan/2+thickness,diameterFan/2-6-25,depth/2])cube([thickness*2,4,4]);
        }
    }
}

//translate([120*1.5,0,0])fan(120);
funnelThing(diameterFan = 120, diameterHose = 4*21.5-4, depth=25,cornerRad=6,squareSize=120);