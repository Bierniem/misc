//treadmill roller fitting
difference(){
union(){
linear_extrude(height = .1*25.4)
circle(1.18*25.4/2,$fn=100);
linear_extrude(height = .75*25.4)
difference(){
circle(1.035*25.4/2,$fn=100);
circle(.33*25.4/2,$fn=100);
}
}
linear_extrude(height = 25.4*.23)
translate([0,0,0])
circle((.5*25.4/2)/cos(180/6), $fn=6);
}

