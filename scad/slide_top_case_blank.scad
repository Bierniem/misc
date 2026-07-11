/*
modify the design so the top can slide into the bottom upside down too? so that it will stay together while open

*/



module slot_with_catch_bump(length,width,height,with_bump=true)
{
    overhang_droop = width/5;
    difference(){
        linear_extrude(length)hull(){
            square([.01,height]);
            translate([width,overhang_droop,0])square([.01,height-overhang_droop]);
        }      
        if(with_bump)
        {
            translate([width*1.5,height,length/1.2])rotate([90,0,0])linear_extrude(height)circle(r=width);
        }
    }
}

module slide_top_case_blank(top,bottom,length,width,depth,minkowski_diameter,top_thickness,top_looseness=.1,stiff_rib_len=0,stiff_rib_thickness=0){
    if(bottom){
        difference(){
            linear_extrude(length)minkowski(){
                // square([width-minkowski_diameter,depth-minkowski_diameter]);
                polygon([
                    [top_thickness+top_looseness,top_thickness+top_looseness],
                    [-top_thickness-top_looseness+width-minkowski_diameter,top_thickness+top_looseness],
                    [-top_thickness-top_looseness+width-minkowski_diameter,depth-top_thickness*2-minkowski_diameter],
                    [width-minkowski_diameter,depth-minkowski_diameter],
                    [0,depth-minkowski_diameter],
                    [top_thickness+top_looseness,depth-top_thickness*2-minkowski_diameter],
                    ]);
                circle(d=minkowski_diameter);
            }
            union(){
                // slots for slide 
                translate([-minkowski_diameter/2,depth-top_thickness*3-minkowski_diameter,0])slot_with_catch_bump(length+1,top_thickness*2,top_thickness*2);
                translate([width-minkowski_diameter/2,depth-top_thickness*3-minkowski_diameter,0])mirror([1,0,0])slot_with_catch_bump(length+1,top_thickness*2,top_thickness*2);
                // space for end
                translate([-minkowski_diameter/2,-minkowski_diameter*2,length-top_thickness])linear_extrude(top_thickness)square([width,depth]);
            };
        }
    }
    if(top){
        difference(){
            union(){
                linear_extrude(length){
                    minkowski(){
                        // square([width-minkowski_diameter,depth-minkowski_diameter]);
                        polygon([
                            [0,0],
                            [width-minkowski_diameter,0],
                            [width-minkowski_diameter,depth-minkowski_diameter*2],
                            [0,depth-minkowski_diameter*2],,
                            ]);
                        circle(d=minkowski_diameter);
                    }
                }
                //stiffening rib
                linear_extrude(stiff_rib_len){
                    minkowski(){
                        // square([width-minkowski_diameter,depth-minkowski_diameter]);
                        polygon([
                            [0,0],
                            [width-minkowski_diameter,0],
                            [width-minkowski_diameter,depth-minkowski_diameter*2],
                            [0,depth-minkowski_diameter*2],,
                            ]);
                        circle(d=minkowski_diameter+stiff_rib_thickness);
                    }
                }
                //mirror the rib on the other end
                translate([0,0,length-stiff_rib_len])linear_extrude(stiff_rib_len){
                    minkowski(){
                        // square([width-minkowski_diameter,depth-minkowski_diameter]);
                        polygon([
                            [0,0],
                            [width-minkowski_diameter,0],
                            [width-minkowski_diameter,depth-minkowski_diameter*2],
                            [0,depth-minkowski_diameter*2],,
                            ]);
                        circle(d=minkowski_diameter+stiff_rib_thickness);
                    }
                }
            }
        slide_top_case_blank(bottom=true,top=false,length=length,width=width,depth=depth,minkowski_diameter=minkowski_diameter+top_looseness,top_thickness=top_thickness-top_looseness,top_looseness=0);
        }
    }
}
$fn=100;
color("yellow",.1)slide_top_case_blank(bottom=false,top=false,length=25,width=20,depth=15,minkowski_diameter=2,top_thickness=1,top_looseness=.1);
color("red",.1)slide_top_case_blank(bottom=true,top=false,length=25,width=20,depth=15,minkowski_diameter=2,top_thickness=1,top_looseness=.1);