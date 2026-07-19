module threaded_rod(length=20,od=10,id=8,thread_thickness_base=.9,thread_thickness_edge=.9,pitch=2,chamfer=0,steps=5){
    module pie_slicer(diameter,angle){
        projection(){
            rotate_extrude(angle=angle)
            square([diameter/2,.1]);
        }
    }
    inner_angle = 360*thread_thickness_base/pitch;
    ca=inner_angle;
    cd=id;
    outer_angle = 360*thread_thickness_edge/pitch;
    a_stepper = (outer_angle-inner_angle)/steps; 
    d_stepper = (od-id)/steps;
    // points = [for(i=[-1:steps]) [(id+d_stepper*i)/2*cos(inner_angle+a_stepper*i),(id+d_stepper*i)/2*sin(inner_angle+a_stepper*i)]];
    // translate([-10,0,0]){
    //     polygon(points);
    //     mirror([0,1,0])polygon(points);
    //     // translate([0,0,0])circle(d=id);
    //     // color("red",.2)translate([-od/2*sin(inner_angle+a_stepper*steps),0,0])circle(d=od);
    // }
    // }
    // angles = [inner_angle:stepper:outer_angle];
    // angles = [i for i in angles];
    // diameters = [id:d_stepper:od];
    module threads(){
        linear_extrude(height=length,convexity=10,twist=-360*length/pitch){
            hull(){
                for(i=[0:steps]){
                    cd = id + i*d_stepper;
                    ca = inner_angle+i*a_stepper;
                    echo(i,cd,ca);
                    difference(){
                        rotate([0,0,(outer_angle-ca)/2])pie_slicer(cd,ca);
                        // pie_slicer(cd,ca);
                        circle(d=cd-d_stepper);
                    }
                    
                }
            }
        }
    }
    intersection(){
        union(){
            threads();
            cylinder(d=id,h=length);
        }
        union(){
            cylinder(d1=id,d2=od,h=chamfer);
            translate([0,0,chamfer])cylinder(d=od,h=length);
        }
    }
}


module threaded_nut(length=20,nut_diameter=14,od=10,id=8,thread_thickness_base=.9,thread_thickness_edge=.9,pitch=2,chamfer=2,inner_chamfer=2,steps=5){
    difference(){
        union(){
            translate([0,0,length-chamfer])cylinder(d1=nut_diameter,d2=nut_diameter-chamfer,h=chamfer,$fn=6);
            translate([0,0,chamfer])cylinder(d=nut_diameter,h=length-chamfer*2,$fn=6);
            cylinder(d1=nut_diameter-chamfer,d2=nut_diameter,h=chamfer,$fn=6);
        }
        union(){
            translate([0,0,length-inner_chamfer])cylinder(d1=id,d2=id+inner_chamfer,h=inner_chamfer+.01);
            threaded_rod(length,od,id,thread_thickness_base,thread_thickness_edge,pitch,chamfer=0,steps=steps);
            translate([0,0,-.01])cylinder(d1=id+inner_chamfer,d2=id,h=inner_chamfer+.01);
        }
    }
}