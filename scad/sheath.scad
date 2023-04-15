chord = 43;
spinebase = 2.13;
spinetip = .82;
spineLen = 8 * 24.5;
thickness = 1.5;


linear_extrude([0,0,thickness*2 + spinebase])
{
polygon(points=[[0-thickness,0-thickness],[chord+thickness,0-thickness],[0-thickness,spineLen+thickness]]);
}

