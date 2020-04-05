function card_size_by_type(type) =
    // units in mm
    (type=="mini_usa")?      [41,63]:   (type=="41x63")?   [41,63]:
    (type=="mini_chimera")?  [43,65]:   (type=="43x65")?   [43,65]:
    (type=="mini_euro")?     [45,68]:   (type=="45x68")?   [45,68]:   (type=="TTR")?         [45,68]:
    (type=="std_usa")?       [56,87]:   (type=="56x87")?   [56,87]:   (type=="Bang!")?       [56,87]:
    (type=="chimera")?       [57.5,89]: (type=="57.5x89")? [57.5,89]: (type=="FFG")?         [57.5,89]:
    (type=="euro")?          [59,92]:   (type=="59x92")?   [59,92]:   (type=="Dominion")?    [59,92]:
    (type=="std")?           [63.5,88]: (type=="63.5x88")? [63.5,88]: (type=="MTG")?         [63.5,88]:
    (type=="magnum_copper")? [65,100]:  (type=="65x100")?  [65,100]:  (type=="7 Wonders")?   [65,100]:
    (type=="magnum_space")?  [61,103]:  (type=="61x103")?  [61,103]:  (type=="Space Alert")? [61,103]:
    (type=="magnum_silver")? [70,110]:  (type=="70x110")?  [70,110]:  (type=="Lost Cities")? [70,110]:
    (type=="magnum_gold")?   [80,120]:  (type=="80x120")?  [80,120]:  (type=="Dixit")?       [80,120]:
    (type=="french_tarot")?  [61,112]:  (type=="61x112")?  [61,112]:
    (type=="small_square")?  [70,70]:   (type=="70x70")?   [70,70]:
    (type=="medium_square")? [80,80]:   (type=="80x80")?   [80,80]:
    (type=="large_square")?  [90,90]:   (type=="90x90")?   [90,90]:
    [undef, undef];

all_types= [
    "mini_usa",
    "mini_chimera",
    "mini_euro",
    "std_usa",
    "chimera",
    "euro",
    "std",
    "magnum_copper",
    "magnum_space",
    "magnum_silver",
    "magnum_gold",
    "french_tarot",
    "small_square",
    "medium_square",
    "large_square"
];

module cards_holder_by_size(sleeve_width, sleeve_length, deck_depth, center=true) {
    // deck_depth: taking into account sleeves!
    space = 2;
    walls = 2;
    rounding = 3;
    minko_height = 1;
    eps = 1;

    module rounded_cube(x, y, z, center=true) {
        $fn = 15;
        cube_width = x-2*rounding;
        cube_length = y-2*rounding;
        cube_depth = z-minko_height;
        dx = center?0:x/2;
        dy = center?0:y/2;
        dz = center?0:z/2;
        translate([dx, dy, dz]) minkowski() {
            cube([cube_width, cube_length, cube_depth], center=true);
            cylinder(minko_height, rounding, rounding, center=true);
        }
    }

    hole_width = sleeve_width+2*space;
    hole_length = sleeve_length+2*space;
    hole_depth = deck_depth+space;
    outer_width = hole_width+2*walls;
    outer_length = hole_length+2*walls;
    outer_depth = hole_depth+walls;
    dx = center?0:outer_width/2;
    dy = center?0:outer_length/2;
    dz = center?0:outer_depth/2;
    translate([dx, dy, dz]) difference() {
        rounded_cube(outer_width, outer_length, outer_depth, center=true);
        translate([0, 0, (walls+eps)/2]) rounded_cube(hole_width, hole_length, hole_depth+eps, center=true);
    }
}

module cards_holder_by_type(type, count=52, card_thickness=0.1, center=true) {
    sleeve_extra = 2;
    sleeve_thickness = 0.2;
    card_size = card_size_by_type(type);
    cards_holder_by_size(card_size[0]+sleeve_extra, card_size[1]+sleeve_extra, count*(card_thickness+sleeve_thickness), center=center);
}

!cards_holder_by_type("euro");

for (i = [1-1:len(all_types)-1]) {
    translate([100*i, 0, 0]) {
        cards_holder_by_type(all_types[i], center=false);
        translate([5, -15, 0]) text(all_types[i], size=8);
    }
}
