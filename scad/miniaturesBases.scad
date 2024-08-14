// all dimensions in mm
bottomRadius = 12.5;
topRadius = bottomRadius-1;
depth = 3;
magnetRadius = 2.5;
magnetDepth = 2;


difference(){
cylinder(h = depth, r1 = bottomRadius, r2= topRadius, $fn = 100);
cylinder(h=magnetDepth,r=magnetRadius, $fn = 100);
};