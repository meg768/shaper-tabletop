use <BOSL2/std.scad>;

module hole(diameter = 9, depth = 15, chamfer = 1, translate = [0, 0, 0]) {
    down(0)
        translate(translate)
            cyl(d=diameter, l=depth, chamfer1=-chamfer, chamfer2=-chamfer);
}
module benchdog(height = 10, width = 30, diameter = 20, depth = 20) {

    up(height / 2) {
        cyl(d=width, h=height, chamfer=1);
    }
    translate([0, 0, -depth / 2])
        cyl(d=diameter, h=depth, chamfer1=1);
}

module make() {
    A = 4; // höjd på benchdog (ovan bord)
    B = 29.7; // 29.9; //29.5; // diameter på benchdog (ovan bord)
    C = 19.9; //19.8; //19.5; // diameter på benchdog i hålet
    D = 35; //40; // djup på benchdog i bordet
    E = 6; // Diameter på hål i mitten
    Z = 0;

    rotate([180, 0, 0]) {
        difference() {
            down(A) {
                benchdog(height=A, width=B, diameter=C, depth=D);
            }
            *down((A + D) / 2) {
                #hole(depth=A + D, diameter=E);
            }
        }
    }
}

make($fn = 256);
