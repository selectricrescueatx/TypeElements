
// Usage: copy this commented code to a separate file, customize as needed for each typeface. Everything below in this file will be common to all projects.

/* --------- START ---------

// SelectricElement88.scad contains all the low-level stuff that's common to all balls
include <SelectricElement88.scad>

// enable to skip slow rendering of letters on the ball
PREVIEW_LABEL = false;

// The name of the font, as understood by the system.
// Note: if the system doesn't recognize the font it
// will silently fall back to a default!
TYPEBALL_FONT = "Vogue";

// Labels on the top of the ball, cosmetic
module Labels()
{
    offset(r=0.12)
    {
        translate([-0.1,14,0])
        text("1O", size=2, font=TYPEBALL_FONT, halign="center");

        translate([0,0.6,0])
        text(TYPEBALL_FONT, size=2, font=TYPEBALL_FONT, halign="center");
        
//        translate([0,-1.6,0])
//        text("Mono", size=2, font=TYPEBALL_FONT, halign="center");
    }
}

// The font height, adjusted for the desired pitch
// (Note that this is multiplied by faceScale=2.25 in LetterText(),
// so the scale is somewhat arbitrary)
LETTER_HEIGHT = 2.15;

// Keyboard layout

LOWER_CASE = str(
    "1234567890-=",
    "qwertyuiop½",
    "asdfghjkl;'",
    "zxcvbnm,./"
);

UPPER_CASE = str(
    "!@#$%¢&*()_+",
    "QWERTYUIOP¼",
    "ASDFGHJKL:\"",
    "ZXCVBNM,.?"
);

// Offset each glyph by this amount, making the characters heavier or lighter
CHARACTER_WEIGHT_ADJUSTMENT = -0.1;

// balance the vertical smear with extra horizontal weight
HORIZONTAL_WEIGHT_ADJUSTMENT = 0.2;


// -------------------
// Render
// -------------------

// preview a single letter
//LetterText(LETTER_HEIGHT, LETTER_ALTITUDE, TYPEBALL_FONT, "8");

// preview text at the given pitch
//TextGauge("This is example text at 12 pitch", 12);

// render the full type ball
TypeBall();

// ---------- END ----------
*/



// ############################### Selectric_II_typeball.scad ###############################
// Custom typeball ("golfball") type element for IBM Selectric II typewriters

// based on original project by Steve Malikoff
// https://www.thingiverse.com/thing:4126040

// Modifications by Dave Hayden (dave@selectricrescue.org), last update 2023.12.15

// Huge thanks to Sam Ettinger for his feedback and
// for proving that resin-printed Selectric balls
// actually work, to Stephen Cook for his expert
// advice, and of course to Steve Malikoff for
// bringing the dream to life

// Note: STL generation is *much* faster using the command line, with the --enable all flag

// This work is released under the CC BY 4.0 license:
// https://creativecommons.org/licenses/by/4.0/

// You are free to:
// Share — copy and redistribute the material in any medium or format
// Adapt — remix, transform, and build upon the material for any purpose, even commercially.

// Under the following terms:
// Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
// No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

// Original project notes:
// ----------------------------------------
//
// NOTE1:   USING A REGULAR FDM PRINTER MAY NOT ACHIEVE THE RESOLUTION REQUIRED, PERHAPS A RESIN PRINT 
//          WOULD WORK BETTER
// NOTE2:   THIS IS FOR AMUSEMENT PURPOSES ONLY, NOT INTENDED FOR SERIOUS USE. HAVE FUN!
// NOTE3:   I AM NOT RESPONSIBLE FOR ANY DAMAGE THIS PRINT MAY CAUSE TO YOUR TYPEWRITER, USE AT OWN RISK.
//
// In memory of John Thompson, an Australian IBM OPCE from whom I "inherited" his Selectric CE tool set:
//      http://qccaustralia.org/vale.htm
//
// Copyright (C) Steve Malikoff 2020 
// Written in Brisbane, Australia
// LAST UPDATE  20200125


// ---------------------------------------------------
// Font and cosmetic parameters
// ---------------------------------------------------

// See comment block above, between BEGIN and END, for parameters expected to be defined before including this one. 

// ---------------------------------------------------
// Typeball dimensions
// ---------------------------------------------------

// How far the type's contact face projects outwards above the ball surface
LETTER_ALTITUDE = 1.9;

// overrideable function for adjusting altitude of individual characters. c is the printing character, e.g. '&', x and y are the position on the ball
function AdjustAltitude(c,x,y) = 0;

// Tweak tilt of characters per row for better descenders/balance. Ordered top row to bottom. Amount is backwards rotation: top goes back and bottom goes forward
ROW_TILT_ADJUST = [ -0.4, -0.3, 0.3, 0.8 ];

// overrideable function for further adjustment to tilt of individual characters
function AdjustTilt(c,x,y) = 0;

// overrideable function for adjusting weight of individual characters, added to CHARACTER_WEIGHT_ADJUSTMENT
function AdjustWeight(c,x,y) = 0;

// amount of curvature on the letter faces. Using a value a bit larger than the actual platen seems to give a better print
PLATEN_DIA = 45;

// Rendering granularity for F5 preview and F6 render. Rendering takes a while.
PREVIEW_FACETS = 22;
RENDER_FACETS = 44;

FACETS = $preview ? PREVIEW_FACETS : RENDER_FACETS;
FONT_FACETS = FACETS;
$fn = FACETS;

// --- probably shouldn't mess with stuff below unless you're tuning for a specific printer ---

// Parameters have been tuned for printing on a Creality Halot One resin printer, using Sunlu ABS-Like resin

// angle between the four rows of type
TILT_ANGLE = 16.4;

// top row is just a bit high :-/
TOP_ROW_ADJUSTMENT = -0.9;

// center row is coming out a bit heavier than the others..
//CENTER_ROW_WEIGHT_ADJUSTMENT = -0.04;
CENTER_ROW_WEIGHT_ADJUSTMENT = 0;

TYPEBALL_RAD = 33.4 / 2;
INSIDE_RAD = 28.15 / 2;
TYPEBALL_HEIGHT = 21.5;
TYPEBALL_TOP_ABOVE_CENTRE = 11.4; // Flat top is this far above the sphere centre
TYPEBALL_TOP_THICKNESS = 1.65;

// Label params
DEL_BASE_FROM_CENTRE = 8.2;
DEL_DEPTH = 0.6;

// Detent teeth skirt parameters
TYPEBALL_SKIRT_TOP_RAD = 31.9 / 2;
TYPEBALL_SKIRT_BOTTOM_RAD = 30.5 / 2;
TYPEBALL_SKIRT_TOP_BELOW_CENTRE = -sqrt(TYPEBALL_RAD^2-TYPEBALL_SKIRT_TOP_RAD^2);  // Where the lower latitude of the sphere meets the top of the skirt
SKIRT_HEIGHT = TYPEBALL_HEIGHT - TYPEBALL_TOP_ABOVE_CENTRE+ TYPEBALL_SKIRT_TOP_BELOW_CENTRE;
TOOTH_PEAK_OFFSET_FROM_CENTRE = 6.1; // Lateral offset of the tilt ring detent pawl

// Parameters for the centre boss that goes onto tilt ring spigot (upper ball socket)
BOSS_INNER_RAD = 4.34;
BOSS_OUTER_RAD = 5.8;
BOSS_HEIGHT = 8.07;

// inside curve doesn't start until it clears the tape guide on the front of the tilt ring on the S3 and Personal Typewriter
INSIDE_CURVE_START = TYPEBALL_TOP_ABOVE_CENTRE - BOSS_HEIGHT + 1.5;

BOSS_FILLET_RAD = 3;
BOSS_SLEEVE_WIDTH = 1;
BOSS_SLEEVE_BOTTOM_CLEARANCE = 1.6;

NOTCH_ANGLE = 131.8; // Must be exact! If not, ball doesn't detent correctly
NOTCH_WIDTH = 1.15; // Should be no slop here, either
NOTCH_DEPTH = 2;
NOTCH_HEIGHT = 2.2;
NOTCH_MOUTH_X = 0.2;
NOTCH_MOUTH_Y = 0.5;

SLOT_ANGLE = NOTCH_ANGLE + 180;
SLOT_WIDTH = 1.9;
SLOT_DEPTH = 0.4;

// Inside reinforcement ribs
RIBS = 11;
RIB_LENGTH = 10;
RIB_WIDTH = 8;
RIB_HEIGHT = 2.5;

// Character layout
CHARACTERS_PER_LATITUDE = 22;   // For Selectric I and II. 4 x 22 = 88 characters total.
CHARACTER_LONGITUDE = 360 / CHARACTERS_PER_LATITUDE; // For Selectric I and II

EPSILON = 0.003; // to fix z-fighting in preview

// ---------------------------------------------------
// Rendering
// ---------------------------------------------------

// The entire typeball model proper.
module TypeBall()
{
    if ( is_undef(PREVIEW_LABEL) || !PREVIEW_LABEL )
    {
        difference()
        {
            SelectricLayout88();
            TrimTop();
            
            // trim any bits that extended into the detent teeth
            translate([0,0, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - SKIRT_HEIGHT-EPSILON])
            DetentTeeth();
        }
    }

    difference()
    {
        union()
        {   
            HollowBall();
            BossSleeve();
        }
        
        Slot();
        Notch();
        TopMarkings();
    }
}


// Keyboard location of each letter on the ball
charmap88 =
   [ 0,  2,  6,  7,  3, 34,  1,  4,  5,  9,  8,
    35, 18, 25, 36, 31, 16, 39, 14, 30, 28, 38,
    40, 37, 15, 23, 20, 22, 42, 33, 19, 24, 13,
    27, 26, 32, 41, 43, 29, 11, 21, 12, 17, 10 ];

module SelectricLayout88()
{
    ROWCHARS = CHARACTERS_PER_LATITUDE/2;
    
    for ( l=[0:3] )
    {
        tiltAngle = (2-l) * TILT_ANGLE + (l==0?TOP_ROW_ADJUSTMENT:0);
        rowweight = CHARACTER_WEIGHT_ADJUSTMENT + (l==2?CENTER_ROW_WEIGHT_ADJUSTMENT:0);
        
        for ( p=[0:ROWCHARS-1] )
        {
            c = LOWER_CASE[charmap88[ROWCHARS*l+p]];
            weightAdjustment = rowweight + AdjustWeight(c,p+1,l+1);

            GlobalPosition(
              TYPEBALL_RAD,
              tiltAngle,
              (5-p)*CHARACTER_LONGITUDE,
              ROW_TILT_ADJUST[l] + AdjustTilt(c,p+1,l+1)
            )
            LetterText(LETTER_HEIGHT, LETTER_ALTITUDE + AdjustAltitude(c,p+1,l+1), TYPEBALL_FONT, weightAdjustment, c);
        }

        for ( p=[0:ROWCHARS-1] )
        {
            c = UPPER_CASE[charmap88[ROWCHARS*l+p]];
            weightAdjustment = rowweight + AdjustWeight(c,p+ROWCHARS+1,l+1);

            GlobalPosition(
              TYPEBALL_RAD,
              tiltAngle,
              (ROWCHARS+5-p)*CHARACTER_LONGITUDE,
              ROW_TILT_ADJUST[l] + AdjustTilt(c,p+ROWCHARS+1,l+1)
            )
            LetterText(LETTER_HEIGHT, LETTER_ALTITUDE + AdjustAltitude(c,p+ROWCHARS+1,l+1), TYPEBALL_FONT, weightAdjustment, c);
        }
    }
}

// position child (a typeface letter) at global latitude and longitude on sphere of given radius
module GlobalPosition(r, latitude, longitude, tiltAdjust)
{
    x = r * cos(latitude);
    y = 0;
    z = r * sin(latitude); 
    
    rotate([0, 0, longitude])
    translate([x, y, z])
    rotate([0, 90 - latitude - tiltAdjust, 0])
    children();
}

//// generate reversed embossed text, tapered outwards to ball surface, face curved to match platen
module LetterText(someTypeSize, someHeight, typeballFont, weightAdjustment, someLetter, platenDiameter=PLATEN_DIA)
{
    $fn = $preview ? 12 : 24;
    faceScale = 2.25;
 
 render()
    rotate([0,180,90])
    difference()
    {
        minkowski()
        {
            intersection()
            {
                translate([0,-someTypeSize/2,-someHeight])
                scale([0.5,0.5,2.0])
                linear_extrude(height=1)
                offset(weightAdjustment)
                minkowski()
                {
                    text(size=someTypeSize * faceScale, font=typeballFont, halign="center", someLetter);
                    polygon([[-HORIZONTAL_WEIGHT_ADJUSTMENT/2,0],[HORIZONTAL_WEIGHT_ADJUSTMENT/2,0],[HORIZONTAL_WEIGHT_ADJUSTMENT/2,EPSILON],[-HORIZONTAL_WEIGHT_ADJUSTMENT/2,EPSILON]]);
                }

                translate([0,0,-platenDiameter/2-someHeight/2+0.121])
                rotate([0,90,0])
                difference()
                {
                    cylinder(h=100, r=platenDiameter/2+0.01, center=true, $fn=$preview ? 60 : 360);
                    cylinder(h=100, r=platenDiameter/2, center=true, $fn=$preview ? 60 : 360);
                }

            }
     
            cylinder(h=someHeight, r1=0, r2=0.75*someHeight);
        }
        translate([-3,-3,1])
          cube([6,6,6]);
    }
}

// The unadorned ball shell with internal ribs
module HollowBall()
{
    difference()
    {
        Ball();

        translate([0,0,-20+INSIDE_CURVE_START])
        cylinder(r=INSIDE_RAD, h=20, $fn=$preview ? 60 : 360); // needs to be smooth!
    }
    intersection()
    {
        Ribs();
        sphere(r=TYPEBALL_RAD, $fn=$preview ? 40 : 160);
    }
    CentreBoss();
}

module Ball()
{
    // Basic ball, trimmed flat top and bottom
    difference()
    {
        sphere(r=TYPEBALL_RAD, $fn=$preview ? 40 : 160);
 
        translate([-20,-20, TYPEBALL_TOP_ABOVE_CENTRE-EPSILON])
            cube([40,40,6]);
        
        translate([-20,-20, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - 12])   // ball/skirt fudge factor
            cube([40,40,12]);
        
        intersection()
        {
            sphere(r=sqrt(INSIDE_RAD^2+INSIDE_CURVE_START^2), $fn=$preview ? 60 : 160);
            translate([-20,-20,INSIDE_CURVE_START-EPSILON])
                cube([40,40,7]);
        }
    }

    // Fill top back in
    TopFace();

    // Add the skirt
    DetentTeethSkirt();
}

//////////////////////////////////////////////////////////////////////////
//// Detent teeth around bottom of ball
module DetentTeethSkirt()
{
    // Detent teeth skirt
    difference()
    {
        translate([0,0, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - SKIRT_HEIGHT])
        cylinder(r2=TYPEBALL_SKIRT_TOP_RAD, r1=TYPEBALL_SKIRT_BOTTOM_RAD, h=SKIRT_HEIGHT, $fn=160);
        
        translate([0,0, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - SKIRT_HEIGHT-EPSILON])
        DetentTeeth();
    }
}

// Ring of detent teeth in skirt
module DetentTeeth()
{
    for (i=[0:CHARACTERS_PER_LATITUDE - 1])
    {
        rotate([0, 0, i * CHARACTER_LONGITUDE])
        Tooth();
    }
}

module Tooth()
{
    translate([0, TOOTH_PEAK_OFFSET_FROM_CENTRE, 0])
    rotate([180, -90, 0])
    {
        // notch between teeth must be big enough to trap detent
        linear_extrude(30)
        polygon(points=[[0,1.9], [2.2,0.4], [3.2,0.14], [3.2, -0.14], [2.2, -0.4], [0,-1.9]]);
    }
}

// Flat top of typeball, punch tilt ring spigot hole through and subtract del triangle
module TopFace()
{
    r = sqrt(TYPEBALL_RAD^2-TYPEBALL_TOP_ABOVE_CENTRE^2);
    
    LOWER_EDGE_ADJUST = 0.5;

    // Fill top back in, after the inside sphere was subtracted before this fn was called
    difference()
    {
        translate([0, 0, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - RIB_HEIGHT - LOWER_EDGE_ADJUST])
        cylinder(r1=r+2, r2=r, h=TYPEBALL_TOP_THICKNESS+RIB_HEIGHT+LOWER_EDGE_ADJUST);

        translate([0, 0, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - RIB_HEIGHT - LOWER_EDGE_ADJUST - EPSILON])
        cylinder(h=RIB_HEIGHT/2+1.0, r1=r+2, r2=0);

        translate([0, 0, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - RIB_HEIGHT - EPSILON])
        cylinder(r=BOSS_INNER_RAD,h=TYPEBALL_TOP_THICKNESS*2+RIB_HEIGHT);
    }   
}

module TopMarkings()
{
    // Alignment marker triangle on top face
    translate([DEL_BASE_FROM_CENTRE, 0, TYPEBALL_TOP_ABOVE_CENTRE - DEL_DEPTH + EPSILON])
    linear_extrude(DEL_DEPTH)
    polygon(points=[[3.4,0],[0.4,1.3],[0.4,-1.3]]);
    
    // Emboss a label onto top face
    translate([-8.5, 0, TYPEBALL_TOP_ABOVE_CENTRE - DEL_DEPTH])
    rotate([0,0,270])
    linear_extrude(DEL_DEPTH+0.01)
    Labels();
}

// Clean up any base girth bits of T0-ring characters projecting above top face
module TrimTop()
{
    translate([-50,-50, TYPEBALL_TOP_ABOVE_CENTRE])
    cube([100,100,20]);
}

module BossSleeve()
{
    r = BOSS_OUTER_RAD+BOSS_FILLET_RAD+BOSS_SLEEVE_WIDTH;

    translate([0,0, TYPEBALL_TOP_ABOVE_CENTRE - BOSS_HEIGHT+BOSS_SLEEVE_BOTTOM_CLEARANCE])
    difference()
    {
        union()
        {
            // fillet
            translate([0,0,0.45]) // XXX - replace with computation
            difference()
            {
                cylinder(r=r, h=BOSS_FILLET_RAD);
            
                translate([0,0,0])
                rotate_extrude(convexity = 10)
            translate([r, 0, 0])
                circle(r = BOSS_FILLET_RAD);
            }

            cylinder(r=BOSS_OUTER_RAD+BOSS_SLEEVE_WIDTH, h=BOSS_HEIGHT-BOSS_SLEEVE_BOTTOM_CLEARANCE-TYPEBALL_TOP_THICKNESS);
        }
        
        
        translate([0,0,-EPSILON])
        cylinder(r=BOSS_OUTER_RAD-EPSILON, h=2*BOSS_HEIGHT);
    }
    
};

// Tilt ring boss assembly
module CentreBoss()
{
    translate([0,0, TYPEBALL_TOP_ABOVE_CENTRE - BOSS_HEIGHT])
    difference()
    {
        cylinder(r=BOSS_OUTER_RAD, h=BOSS_HEIGHT);
        
        translate([0,0,-EPSILON])
        cylinder(r=BOSS_INNER_RAD, h=BOSS_HEIGHT+2*EPSILON);
    }    
}

// The full-length slot in the tilt ring boss at the (not quite) half past one o'clock position, required for S1

module Slot()
{
    rotate([0, 0, SLOT_ANGLE])
    translate([0, -SLOT_WIDTH/2, 0])
    cube([SLOT_DEPTH + BOSS_INNER_RAD, SLOT_WIDTH, 40]);
}

// The partial-length slot in the tilt ring boss at the (not quite) half past seven o'clock position
module Notch()
{
    r = NOTCH_WIDTH/2;
    
    rotate([0, 0, NOTCH_ANGLE])
    translate([-0.4, -r, TYPEBALL_TOP_ABOVE_CENTRE - BOSS_HEIGHT - EPSILON])
    rotate([0,90,0])
    
    union()
    {
        h = NOTCH_HEIGHT - r + EPSILON;
        
        linear_extrude(NOTCH_DEPTH + BOSS_INNER_RAD)
        polygon(points=[[0,-NOTCH_MOUTH_X], [-NOTCH_MOUTH_Y,0], [-h,0], [-h,NOTCH_WIDTH], [-NOTCH_MOUTH_Y,NOTCH_WIDTH], [0,NOTCH_WIDTH+NOTCH_MOUTH_X]]);
        
        translate([r-NOTCH_HEIGHT,r,0])
        cylinder(h=NOTCH_DEPTH+BOSS_INNER_RAD, r=r);
    }
}

// The reinforcement spokes on the underside of the top face, from the tilt ring boss 
// to the inner sphere wall
module Ribs()
{
    segment = 360 / RIBS;
    
    for (i=[0:RIBS - 1])
    {
        rotate([0, 5, -360.0/44 + segment * i])
        translate([BOSS_OUTER_RAD - 1.5, -RIB_WIDTH/2, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - 0.8 * RIB_HEIGHT])
        cube([RIB_LENGTH, RIB_WIDTH, RIB_HEIGHT]);
    }
}

// tool for determining correct LETTER_HEIGHT
module TextGauge(str, pitch)
{
    for ( i = [0:len(str)] )
    {
        // scale factor from LetterText() function, must match!
        faceScale = 2.25;

        translate([8,8])
        translate([i*22/pitch,-LETTER_HEIGHT/2])
        scale([0.5,0.5,0.1])
        offset(CHARACTER_WEIGHT_ADJUSTMENT)
        text(size=LETTER_HEIGHT * faceScale, font=TYPEBALL_FONT, halign="center", str[i]);
    }
}