/*
gantry
common axis power shafts to move rotations in or out
arbitrary degree bevel gears
*/

module gear(n_teeth,tooth_width,tooth_height,gear_height,bevel_angle,wall_height)
{
    //wall height is for belt drives
}

module gantry_1_axis(x_size,y_size,z_size,clearances,arm_dimensions)
{

}

module gantry_2_axis(x_size,y_size,z_size,clearances,arm_dimensions)
{
    gantry_1_axis(x_size=x_size,y_size=y_size,z_size=z_size,clearances=clearances,arm_dimensions=arm_dimensions);
}

module gantry_3_axis(x_size,y_size,z_size,clearances,arm_dimensions)
{
    //sizes are of the object in the 3 axis gantry
    gantry_2_axis(x_size=x_size,y_size=y_size,z_size=z_size,clearances=clearances,arm_dimensions=arm_dimensions);
}