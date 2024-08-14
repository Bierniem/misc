// all dimensions in mm
plugMinRadius = 18.5/2;
plugMaxRadius = 18.8/2;
plugDepth = 15;
topRadius = plugMaxRadius+2;
topDepth = 3.5;

union(){
    cylinder(h = topDepth, r = topRadius, $fn = 360);
    cylinder(h = plugDepth+topDepth, r1 = plugMaxRadius, r2 = plugMinRadius, $fn=360);
}
