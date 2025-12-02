use <BOSL2/std.scad>;

// ------------------------------------------------------------
// Complete bench dog
// ------------------------------------------------------------
module benchdog(
    size = undef, // "M5", "M6", "M8", or leave undefined for no hole
    benchHeight = 10,
    benchDiameter = 29.8,
    benchShankDiameter = 19.6, //19.9,
    benchShankDepth = 18,
    translate = [0, 0, 0]
) {

    // ------------------------------------------------------------
    // Nut dimensions – text only ("M5", "M6", "M8")
    // ------------------------------------------------------------
    function nutAcrossFlats(size) =
        size == "M5" ? 8
        : size == "M6" ? 10
        : size == "M8" ? 13
        : assert(false, str("Unsupported size: ", size));

    function nutThickness(size) =
        size == "M5" ? 4.0
        : size == "M6" ? 5.0
        : size == "M8" ? 6.5
        : assert(false, str("Unsupported size: ", size));

    // ------------------------------------------------------------
    // Main body (top + shank)
    // ------------------------------------------------------------
    module dog(height, width, diameter, depth) {
        up(height / 2)
            cyl(d=width, h=height, chamfer=1);
        translate([0, 0, -depth / 2])
            cyl(d=diameter, h=depth, chamfer1=1);
    }

    // ------------------------------------------------------------
    // Hex nut pocket
    // ------------------------------------------------------------
    module bolt(size = "M5", translate = [0, 0, 0], $fn = 6) {
        A = nutThickness(size) * 2;
        B = nutAcrossFlats(size);
        C = B / sqrt(3); // circumradius for BOSL2's hexagon

        translate(translate)
            down(A / 2)
                cyl(h=A, d=2 * C, $fn=6, chamfer1=C, chamfer2=-1);
    }

    // ------------------------------------------------------------
    // Through hole
    // ------------------------------------------------------------
    module hole(size, depth, chamfer = 1, translate = [0, 0, 0]) {
        A =
            size == "M5" ? 5.5
            : size == "M6" ? 6.6
            : size == "M8" ? 8.5
            : assert(false, str("Unsupported size: ", size));

        translate(translate)
            cyl(d1=A, d2=A, l=depth, chamfer1=-chamfer, chamfer2=-chamfer);
    }

    A = benchHeight;
    B = benchDiameter;
    C = benchShankDiameter;
    D = benchShankDepth;

    // Determine nut height; set to 0 if size is undefined
    E = is_undef(size) ? 0 : nutThickness(size);

    translate(translate) {
        rotate([180, 0, 0]) {
            difference() {
                dog(height=A, width=B, diameter=C, depth=D);
                if (E > 0) {
                    bolt(size=size, translate=[0, 0, A]);
                    hole(
                        size=size, depth=D + A - E,
                        translate=[0, 0, -(D + A - E) / 2 + A - E]
                    );
                }
            }
        }
    }
}

module ring(height = 5, width = 30, diameter = 20.5, translate = [0, 0, 0]) {
    A = height; // höjd på ringen
    B = width; // bredd på ringen
    C = diameter; // diameter på hål

    module hole(diameter = 9, depth = 15, chamfer = 1, translate = [0, 0, 0]) {
        down(0)
            translate(translate)
                cyl(d=diameter, l=depth, chamfer1=-chamfer, chamfer2=-chamfer);
    }

    translate(translate) {
        difference() {
            cyl(d=B, h=A, chamfer=1);
            hole(diameter=C, depth=A);
        }
    }
}

module make() {
    A = 3.5;
    B = 30;
    C = 7; // Höjd på ring
    D = 34;
    translate([0, 35, 0]) {
        benchdog(translate=[0, 0, 0], benchHeight=A, benchShankDepth=B);
        benchdog(translate=[D, 0, 0], benchHeight=A, benchShankDepth=B);
        benchdog(translate=[D*2, 0, 0], benchHeight=A, benchShankDepth=B);
        benchdog(translate=[D*3, 0, 0], benchHeight=A, benchShankDepth=B);
    }
    ring(height=C, translate=[0, 0, 0]);
    ring(height=C, translate=[D, 0, 0]);
    ring(height=C, translate=[D*2, 0, 0]);
    ring(height=C, translate=[D*3, 0, 0]);
}

make($fn=256);

// Example 1 – without any hole
//benchdog(size="M5", benchHeight=4, benchShankDepth=15);

// Example 2 – with an "M6" nut pocket and hole
// benchdog(size="M6", benchHeight=4, benchShankDepth=15);
