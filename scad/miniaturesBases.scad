// all dimensions in mm
bottomRadius = 12.5;
topRadius = bottomRadius-1;
depth = 3;
thickness = depth/2;
magnetRadius = 2.5;
magnetDepth = 2;

// base
difference(){
    union(){
        difference(){
        cylinder(h = depth, r1 = bottomRadius, r2= topRadius, $fn = 100);
        cylinder(h = depth - thickness, r1 = bottomRadius-thickness, r2= topRadius-thickness, $fn = 100);
        }
            cylinder(h=magnetDepth,r=magnetRadius+thickness, $fn = 100);
        }
    cylinder(h=magnetDepth,r=magnetRadius, $fn = 100);
};