resolutionScale = 20;
$fn = 20;

module slip_fitting(id,od,length,opposite_len=0,include=true,remove=false){
    // slip fitting include adds volume, remove clears space 

    if(include){
        difference(){
            translate([0,0,-opposite_len])linear_extrude(opposite_len+length)circle(d=od);
            slip_fitting(id=id,od=od,length=length,opposite_len=opposite_len,include=false,remove=true);
        }
    }
    if(remove){
        color("red",.2){
            translate([0,0,-.01]){
                // the pipe in the fitting
                linear_extrude(length+.03)
                    circle(d=id);
                // the stop at the bottom of the fitting + access to the rest of the connector
                translate([0,0,-opposite_len])linear_extrude(opposite_len)
                    circle(d=id-(od-id));
            }
        }
    }
}

module nipple_fitting(id,od,od2,length,opposite_len,include=true,remove=false){
    if(include){
        difference(){
            union(){
                translate([0,0,-opposite_len])linear_extrude(opposite_len+length+od-id-length/3)circle(d=od);
                translate([0,0,length+od-id])rotate([180,0,0])cylinder(d1=od-(od-id)/2,d2=od2,h=length/3);
                translate([0,0,length+od-id-length/3])rotate([180,0,0])cylinder(d1=od2,d2=od,h=(od2-od)/3);
            }
            nipple_fitting(id=id,od=od,od2=od2,length=length,opposite_len=opposite_len,include=false,remove=true);
        }
    }
    if(remove){
        color("red",.2){
            translate([0,0,-opposite_len-.01]){
                // the pipe in the fitting
                linear_extrude(length+.03+opposite_len+od-id)
                    circle(d=id);
            }
        }
    }
}



module swamp_cooler_flexible_hose_to_3pvc(pvc_id,pvc_od,pvc_length,nylon_id,nylon_od,nylon_length){
    difference(){
        union(){
            translate([0,0,pvc_od/2])slip_fitting(id=pvc_id,od=pvc_od,length=pvc_length,opposite_len=pvc_od/2,include=true,remove=false);
            mirror([0,0,1])translate([0,0,pvc_od/2])slip_fitting(id=pvc_id,od=pvc_od,length=pvc_length,opposite_len=pvc_od/2,include=true,remove=false);
            translate([0,-pvc_od/2,0])rotate([90,0,0])slip_fitting(id=pvc_id,od=pvc_od,length=pvc_length,opposite_len=pvc_od/2,include=true,remove=false);
            translate([nylon_od,0,0])rotate([90,0,90])nipple_fitting(id=nylon_id,od=nylon_od,od2=nylon_od+1.5,length=nylon_length,opposite_len=5,include=true,remove=false);

        }
        union(){
            translate([0,0,pvc_od/2])slip_fitting(id=pvc_id,od=pvc_od,length=pvc_length,opposite_len=pvc_od/2,include=false,remove=true);
            mirror([0,0,1])translate([0,0,pvc_od/2])slip_fitting(id=pvc_id,od=pvc_od,length=pvc_length,opposite_len=pvc_od/2,include=false,remove=true);
            translate([0,-pvc_od/2,0])rotate([90,0,0])slip_fitting(id=pvc_id,od=pvc_od,length=pvc_length,opposite_len=pvc_od/2,include=false,remove=true);
            translate([nylon_od,0,0])rotate([90,0,90])nipple_fitting(id=nylon_id,od=nylon_od,od2=nylon_od+1.5,length=nylon_length,opposite_len=5,include=false,remove=true);
        }
    }
}

swamp_cooler_flexible_hose_to_3pvc(pvc_id=21.5-6-.3,pvc_od=21.5,pvc_length=10,nylon_id=7,nylon_od=9,nylon_length=15);
// slip_fitting(21.5-6-.3,21.5,10,21.5/2,include=true,remove=true);
// nipple_fitting(10,14,15,15,5,true,true);



