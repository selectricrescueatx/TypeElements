
// Usage: copy this commented code to a separate file, customize as needed for each typeface. Everything below in this file will be common to all projects.

/* --------- START ---------

// SelectricElement96.scad contains all the low-level stuff that's common to all balls
include <SelectricElement96.scad>

// enable to skip slow rendering of letters on the ball
PREVIEW_LABEL = true;

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
LETTER_HEIGHT = 2.75;

// Keyboard layout

// Note: the characters ²³§¶ are on the ball but
// not accessible via the S3 keyboard

LOWER_CASE = str(
    "±1234567890-=",
    "qwertyuiop½]",
    "asdfghjkl;'",
    "zxcvbnm,./",
    "²§"
);

UPPER_CASE = str(
    "°!@#$%¢&*()_+",
    "QWERTYUIOP¼[",
    "ASDFGHJKL:\"",
    "ZXCVBNM,.?",
    "³¶"
);

// Offset each glyph by this amount, making the characters heavier or lighter
CHARACTER_WEIGHT_ADJUSTMENT = 0;

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

// Modifications by Dave Hayden (dave@selectricrescue.org), last update 2023.11.10

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

// See SelectricElementExample.scad for parameters expected to be defined before including this one. 

// ---------------------------------------------------
// Typeball dimensions
// ---------------------------------------------------

// How far the type's contact face projects outwards above the ball surface
LETTER_ALTITUDE = 1.7;

// overrideable function for adjusting altitude of individual characters. c is the printing character, e.g. '&', x and y are the position on the ball
function AdjustAltitude(c,x,y) = 0;

// Tweak tilt of characters per row for better descenders/balance. Ordered top row to bottom. Amount is backwards rotation: top goes back and bottom goes forward
ROW_TILT_ADJUST = [ -0.4, -1.1, -0.8, 0.3 ];

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

// Parameters have been tuned for printing on a Creality Halot Mage resin printer, using Sunlu ABS-Like resin

// latitudes of the four rows of type, top to bottom
LATITUDES = [ 31.0, 15.7, 0, -15.7 ];

// overrideable function for adjusting position of individual characters, added to CHARACTER_WEIGHT_ADJUSTMENT

function AdjustPosition(c,x,y) = [0,0];

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
BOSS_INNER_RAD = 4.35;
BOSS_OUTER_RAD = 5.8;
BOSS_HEIGHT = 8.07;

// inside curve doesn't start until it clears the tape guide on the front of the tilt ring on the S3 and Personal Typewriter
INSIDE_CURVE_START = TYPEBALL_TOP_ABOVE_CENTRE - BOSS_HEIGHT + 1.5;

BOSS_FILLET_RAD = 3;
BOSS_SLEEVE_WIDTH = 1;
BOSS_SLEEVE_BOTTOM_CLEARANCE = 1.6;

SLOT_ANGLE = 137;
SLOT_WIDTHS = [ 1.15, 1.15, 2.15, 1.15 ];
SLOT_DEPTHS = [ 1.0, 0.75, 0.75, 0.75 ];

// Inside reinforcement ribs
RIBS = 12;
RIB_LENGTH = 10;
RIB_WIDTH = 8;
RIB_HEIGHT = 2.5;

// Character layout
COLUMN_ALIGNMENT = 15.5;
CHARACTERS_PER_LATITUDE = 24;   // For Selectric III. 4 x 24 = 96 characters total.
CHARACTER_LONGITUDE = 360 / CHARACTERS_PER_LATITUDE;

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
            SelectricLayout96();
            TrimTop();
            
            // trim any bits that extended into the detent teeth
            translate([0,0, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - SKIRT_HEIGHT-EPSILON])
            DetentTeeth();
        }
    }

    difference()
    {
        HollowBall();

        Slots();
        rotate([0,0,3]) TopMarkings();
    }
    
    BossSleeve();
}


// Keyboard location of each letter on the ball
/*
/398460257²z
=§ukbcetsi';
±½hxanrodwmv
,]glfypqj.1-
*/

charmap96 =
  [ 45,  3,  9,  8,  4,  6, 10,  2,  5,  7, 46, 36,
    12, 47, 19, 32, 40, 38, 15, 17, 26, 20, 35, 34,
     0, 23, 30, 37, 25, 41, 16, 21, 27, 14, 42, 39,
    43, 24, 29, 33, 28, 18, 22, 13, 31, 44,  1, 11 ];

module SelectricLayout96()
{
    ROWCHARS = CHARACTERS_PER_LATITUDE/2;
    
    for ( l=[0:3] )
    {
        latitude = LATITUDES[l];
        rowweight = CHARACTER_WEIGHT_ADJUSTMENT;

         for ( x=[0:2*ROWCHARS-1] )
        {
            p = x % ROWCHARS;
            pos = charmap96[ROWCHARS*l+p];
            
            c = x < ROWCHARS ? LOWER_CASE[pos] : UPPER_CASE[pos];
            weightAdjust = rowweight + AdjustWeight(c,x+1,l+1);
            xyAdjust = AdjustPosition(c,x+1,l+1);
            
            GlobalPosition(
              TYPEBALL_RAD,
              latitude+xyAdjust[1],
              (5-x)*CHARACTER_LONGITUDE+COLUMN_ALIGNMENT+xyAdjust[0],
              ROW_TILT_ADJUST[l] + AdjustTilt(c,x+1,l+1)
            )
            LetterText(LETTER_HEIGHT, LETTER_ALTITUDE + AdjustAltitude(c,x+1,l+1), TYPEBALL_FONT, weightAdjust, c);
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
module LetterText(someTypeSize, someHeight, typeballFont, weightAdjustment, someLetter, platenDiameter=40)
{
    $fn = $preview ? 12 : 24;
    faceScale = 2.25;
 
    rotate([0,180,90])
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
 
        translate([-15,-15, TYPEBALL_TOP_ABOVE_CENTRE-EPSILON])
            cube([30,30,6]);
        
        translate([-15,-15, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - 12])   // ball/skirt fudge factor
            cube([30,30,12]);
        
        intersection()
        {
            sphere(r=sqrt(INSIDE_RAD^2+INSIDE_CURVE_START^2), $fn=$preview ? 60 : 160);
            translate([-15,-15,INSIDE_CURVE_START-EPSILON])
                cube([30,30,7]);
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
        scale([1.0,88/96,1.0])
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
        cylinder(h=RIB_HEIGHT/2, r1=r+2, r2=0);
            
        translate([0, 0, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - RIB_HEIGHT - EPSILON])
        cylinder(r=BOSS_INNER_RAD,h=TYPEBALL_TOP_THICKNESS*2+RIB_HEIGHT);
    }   
}

module TopMarkings()
{
    // Alignment marker triangle on top face
    translate([DEL_BASE_FROM_CENTRE, 0, TYPEBALL_TOP_ABOVE_CENTRE - DEL_DEPTH + EPSILON])
    linear_extrude(DEL_DEPTH)
    polygon(points=[[3.4,0],[1.3,1.1],[0.4,0.6],[0.4,-0.6],[1.3,-1.1]]);

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

module Slots()
{
    for ( i=[0:3] )
    {
        rotate([0, 0, SLOT_ANGLE + 90*i])
        translate([0, -SLOT_WIDTHS[i]/2, 0])
        cube([SLOT_DEPTHS[i] + BOSS_INNER_RAD, SLOT_WIDTHS[i], 40]);
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