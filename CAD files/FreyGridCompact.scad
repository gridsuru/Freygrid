include <hardware.scad>     //from the MCAD library. I commented out instances of examples (whyweren'ttheyalready?).
include <cherry_mx.scad>    //from "https://www.thingiverse.com/thing:421524". Moved the switch to 12.2Z, original was -3Z.
//use <key.scad>
$fn = 20;                   //number of fragments variable, from cherry_mx.scad

k = 19.05;  //key unit size
screwsize = 2;  //screwthread diameter
platethickness = 1.5;
standoffheight = 8;
standoffdiameter = 3.2;
keyboardheight = platethickness*2+standoffheight;

gx = 54.4814; gy = 106.849;

/* -- Screws -- */
module drawscrews(screwsxy) {
    for (i = [0:len(screwsxy)-1])
        translate(screwsxy[i]) screw(5);
}

module drawscrewsbottom(screwsxy) {
    for (i = [0:len(screwsxy)-1])
        translate(screwsxy[i]) translate([0,0,-platethickness*2-standoffheight]) rotate([180,0,0]) screw(5);
}

/* -- Standoffs -- */
module drawstandoffs(standoffsxy) {
    for (i = [0:len(standoffsxy)-1]) {
        translate([standoffsxy[i].x,standoffsxy[i].y, -platethickness-standoffheight])
        cylinder(h = standoffheight, d = standoffdiameter);
    }
}

/* -- Switches -- */
module switchgrid(width = 1, height = 1, origin = [0,0,0]) {
    for (i = [origin[0] : k : origin[0]+ k * width-1])
        for (j = [origin[1] : -k : origin[1] - k*(height-1)])
            translate([i,j,origin[2]]) cherrysw();
}

module switch(xyz = [0,0,0]) switchgrid(origin = xyz);

module drawswitches(switchesxy) {
    for (i = [0:len(switchesxy)-1])
    {
        if (len(switchesxy[i][2]) > 1)
            switchgrid(switchesxy[i][0],switchesxy[i][1], switchesxy[i][2]);
        else
            switch(switchesxy[i]);
    }
}

/* -- Keycaps -- */
keydim = [17,17,10];
module keycap(keydim) {
    translate([0,0,keydim[2]/2])
        cube([keydim[0],keydim[1],keydim[2]], true);
}

module keygrid(width = 1, height = 1, origin = [0,0,0]) {
    for (i = [origin[0] : k : origin[0]+ k * width-1])
        for (j = [origin[1] : -k : origin[1] - k*(height-1)])
            translate([i,j,origin[2]]) keycap(keydim);
}

module key(xyz = [0,0,0]) keygrid(origin = xyz);

module drawkeycaps(switchesxy, simplified = true) {
        for (i = [0:len(switchesxy)-1])
        {
            if (len(switchesxy[i][2]) > 1)
                keygrid(switchesxy[i][0],switchesxy[i][1], switchesxy[i][2]);
            else
                key(switchesxy[i]);
        }
}


//screw coordinates
screwsxy = [
    [330.7, 11.5, 0],
    [44.96, 78.27, 0],
    [(114.3+44.96), 78.27, 0],
    [44.96+114.3/2, 78.27+19.05, 0],
    [44.96+114.3*1.5, 78.27+19.05, 0],
    [44.96+114.3/2, 78.27-19.05, 0],
    [44.96+114.3*1.5, 78.27-19.05, 0],
    [44.96+114.3, 78.27-19.05*2, 0],
    [44.96+114.3/2, 78.27-19.05*3, 0],
    [44.96+114.3*1.5, 11.5, 0],
    [44.96+114.3*1.5+19.05*6, 78.27+19.05, 0],
    [273.557, 97.234, 0],
    [275.938, 68.7483, 0],
    [264.031, 11.5, 0],
    [23.526, 106.85, 0],
    [41.3845, 40.1739, 0],
    [25.907, 11.599, 0]];

//switch coordinates
switchesxy = [
    //switch grid cooridnates
    [10,5,[gx,gy,0]],
    [2,3,[gx+k*10,gy,0]],
    [2,1,[gx+k*12,gy,0]],
    [2,3,[gx+k*14,gy,0]],
    [1,2,[gx-k,gy,0]],
    [3,1,[gx+k*13,gy-k*5,0]],

    //individual switch coordinates
    [gx+k*10,gy-k*3,0],
    [gx+k*14,gy-k*4,0],
    [gx+k*12.5,gy-k,0],
    [gx+k*12.25,gy-k*2,0],
    [275.938,gy-k*3,0],
    [261.65,30.6485,0],
    [14,11.6,0],
    [14+1.25*k,11.6,0],
    [11.6197,106.849],
    [30.6696,68.7485],
    [28.2876,49.6985],
    [23.5259,30.6485],
    [61.6258,11.6],
    [133.062,11.6],
    [204.501,11.6],
    [228.312,11.6],
    [228.312+k*1.25,11.6],
    [228.312+k*1.25*2,11.6]];
    
    
*union() {    
    translate([0,0,0+400]) color("silver") drawscrews(screwsxy);
    translate([0,0,0+300]) drawswitches(switchesxy);
    translate ([0,0,-platethickness+200]) {
        color("goldenrod")
        linear_extrude(height = platethickness, $fn = 20) import("FreyGridCompact.dxf");
    }
    translate([0,0,0+100]) color("silver") drawstandoffs(screwsxy);
    translate ([0,0,-platethickness*2-standoffheight]) {
        color("darkgoldenrod")
        linear_extrude(height = platethickness, $fn = 20) import("FreyGridCompactBottom.dxf");
    }
}

module drawkeyboard(explode = false, keycaps = false)
{
    if (!explode)
        rotate([0,0,0]) translate([0,0,keyboardheight]) union() {
            translate([0,0,0]) color("silver") drawscrews(screwsxy);
            translate([0,0,0]) drawswitches(switchesxy);
            translate ([0,0,-platethickness]) {
                color("goldenrod")
                linear_extrude(height = platethickness, $fn = 20) import("FreyGridCompact.dxf");
            }
            translate([0,0,0]) color("grey") drawstandoffs(screwsxy);
            translate ([0,0,-platethickness*2-standoffheight]) {
                color("darkgoldenrod")
                linear_extrude(height = platethickness, $fn = 20) import("FreyGridCompactBottom.dxf");
            }
            color("silver") drawscrewsbottom(screwsxy);
            if (keycaps)
                translate([0,0,6.5]) color("aliceblue") drawkeycaps(switchesxy);
        }
    else
        union() {    
            translate([0,0,0+400]) color("silver") drawscrews(screwsxy);
            translate([0,0,0+300]) drawswitches(switchesxy);
            translate ([0,0,-platethickness+200]) {
                color("goldenrod")
                linear_extrude(height = platethickness, $fn = 20) import("FreyGridCompact.dxf");
            }
            translate([0,0,0+100]) color("silver") drawstandoffs(screwsxy);
            translate ([0,0,-platethickness*2-standoffheight]) {
                color("darkgoldenrod")
                linear_extrude(height = platethickness, $fn = 20) import("FreyGridCompactBottom.dxf");
            }
        }
        
}
drawkeyboard(keycaps = true);