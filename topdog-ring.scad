use <BOSL2/std.scad>;

module ring(height = 5, width = 29, diameter = 21) {
    A = height; // höjd på ringen
    B = width; // bredd på ringen
    C = diameter; // diameter på hål

    module hole(diameter = 9, depth = 15, chamfer = 1, translate = [0, 0, 0]) {
        down(0)
            translate(translate)
                cyl(d=diameter, l=depth, chamfer1=-chamfer, chamfer2=-chamfer);
    }

    difference() {
        cyl(d=B, h=A, chamfer=1);
        hole(diameter=C, depth=A);
    }
}

make($fn=256, height=10);
