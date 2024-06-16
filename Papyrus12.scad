
include <SelectricElement88.scad>

PREVIEW_LABEL = false;
TYPEBALL_FONT = "Papyrus";
LETTER_HEIGHT = 2.2;
CHARACTER_WEIGHT_ADJUSTMENT = 0;
HORIZONTAL_WEIGHT_ADJUSTMENT = 0.2;

module Labels()
{
    offset(r=0.2)
    translate([0,14,0])
    text("1 2", size=2.5, font=TYPEBALL_FONT, halign="center");

    offset(r=0.15)
    {
       translate([0,0.4,0])
       text("Papyrus", size=3, font=TYPEBALL_FONT, halign="center");
    }
}

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

// These three optional adjustment functions allow for tweaking letters.
// The c argument is the letter, x and y are the coordinates on the ball.

// Here we tilt these bottom row letters with descenders back 1 degree
// for better printing
function AdjustTilt(c,x,y) =
    (c == "j" || c == "g" || c == "p" || c == "q" || c == "y") ? 1 : 0;

// The top or bottom of a tall letter sometimes gets printed below or
// above their neighbor. Changing the altitude (distance from the center
// of the ball) of the offending letter can help with this.
// function AdjustAltitude(c,x,y);

// This adds an offset or inset to make certain letters heavier or lighter
// function AdjustWeight(c,x,y);

// Finally, we generate the model:
TypeBall();
