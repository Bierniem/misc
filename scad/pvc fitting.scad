resolutionScale = 20;

//treadmill roller fitting
module connector(ir,or,lenFactor){
    linear_extrude(height = lenFactor*ir)
    circle(or,$fn = resolutionScale);

}

module tube(ir,or,length){
    difference(){
        cylinder(length,or,or);
        cylinder(length,ir,ir);
    }
}

module long_circle(r,length){
    union(){
        translate([length/2-r,0,0])
            circle(r,$fn = resolutionScale);
        translate([-length/2+r,0,0])
            circle(r,$fn = resolutionScale);
        square([length-2*r,r*2],center=true);
    }
}

module flat_flare(ir,or,length,width,depth,resolution){
    ors = [for (i = [0:resolution]) or-(or-depth)/resolution*i];
    widths = [for (i = [0:resolution]) 2*or-(or-width)/resolution*i];
    wall_thickness = or-ir;
    union(){
    for(i=[0:resolution]){
        translate([0,0,length/resolution*i])
        linear_extrude(length/resolution) 
        difference(){
        long_circle(r = ors[i], length = widths[i]);
        long_circle(r = ors[i]-wall_thickness, length = widths[i]-wall_thickness);
        }
    }
    }
}

module terrarium_flare(ir,or,length,width,tubeLength){
    union(){
    //tube
    tube(ir = ir, or = or, length = tubeLength+1);
    //flare
    resolution = ceil(length);
    depth = (pow(or,2)*3.14/width);
    translate([0,0,tubeLength-1])
    flat_flare(ir = ir, or = or, length = length, width = width, depth = depth, resolution = resolution);
    //end
    }

}

module hollow_connector(ir,or,lenFactor){
    union(){
        //full length hollowness
        //translate([0,0,-.01]) //this clears a 0 thickness web that otherwise forms if the angle of the connector is <90... but the slicer usually deletes it
        linear_extrude(height = 4*ir)
        circle(ir - (or-ir),$fn = resolutionScale);
        //shoulder cutback for improving overhang print
        translate([0,0,ir+(or-ir)/2])
            cylinder((or-ir)/2,ir-(or-ir),ir,$fn = resolutionScale);
        //hollow for pipe
        translate([0,0,or]){
            linear_extrude(height =4*ir)
           circle(ir,$fn = resolutionScale);
            }
        //trim top edge
        translate([0,0,lenFactor*ir])
            linear_extrude(height=ir)
            circle(or,$fn = resolutionScale);
        }
}
module sphere_middle(ir,or){
    difference(){
    sphere(or,$fn = resolutionScale);
    sphere(ir-(or-ir),$fn = resolutionScale);
    }
}
    

module old(){
difference(){
union(){
linear_extrude(height = .1*25.4)
circle(1.18*25.4/2,$fn = resolutionScale);
linear_extrude(height = .75*25.4)
difference(){
circle(1.035*25.4/2,$fn = resolutionScale);
circle(.33*25.4/2,$fn = resolutionScale);
}
}
linear_extrude(height = 25.4*.23)
translate([0,0,0])
circle((.5*25.4/2)/cos(180/6), $fn = resolutionScale);
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

module plug(rad,thickness,resolution){
    linear_extrude(height = thickness){
        circle(r = rad,$fn=resolution);
    } 
}

module nipple(OR,length,thickness,resolution){
    difference(){
        linear_extrude(height = length){
            circle(r=OR,$fn=resolution);
        }
        linear_extrude(height = length){
            circle(r = OR-thickness,$fn=resolution);
        } 
    }
}

module aquarium_pump_plug(rad,thickness,nippleOR, nippleLen,resolution){
    union(){
        difference(){
            plug(rad,thickness,resolution);
            translate(v = [rad,0,0]) linear_extrude(height = thickness) circle(r = 6,$fn=resolution);//cutout for cables, fill with silicone
            linear_extrude(height = thickness) circle(r=nippleOR,$fn=resolution); 
        }
        nipple(OR=nippleOR,length=nippleLen+thickness,thickness=2,resolution=resolution);
    }

}
aquarium_pump_plug(rad=77/2,thickness = 7,nippleOR=8/2, nippleLen=10, resolution=100);

//terrarium_flare(ir = ir2, or = or2, length = 2.5*25.1, width = 6*25.1, tubeLength = 2.5*25.1);

//2_fitting(ir,or,75,lenFactor);
//translate([3*or,0,0])
//tube(ir = ir2, or = or2, length = 21.5*5);

//translate([3*or,0,0])
//    3_fitting_inline(ir,or,40,180,2.5);
//translate([6*or,0,0])
//    2_fitting(ir,or,90,2.5);
//hollow_connector(ir,or);



