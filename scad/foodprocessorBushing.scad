spindleDiameter = 5;
widestDiameter = 9.9;
height = 6;

difference() {
    cylinder(h = height, r = widestDiameter/2,$fn = 360);
    cylinder(h = height, r = spindleDiameter/2,$fn = 360);
}