// Parametric Connect Four game lasercutting template.

// Width of the general material.
MAT_W = 4;

ATTACH_W = MAT_W*3;

// Diameter of a piece.
PIECE_D = 30;

// The number of cells on the board.
BOARD_GRID_X = 7;
BOARD_GRID_Y = 6;

// The amount of material that overlaps pieces in the board.
BOARD_PADDING = 5;

BOARD_SPACING = MAT_W+2;
BOARD_W = PIECE_D*BOARD_GRID_X + (2+MAT_W)*(BOARD_GRID_X-1);
BOARD_H = PIECE_D*BOARD_GRID_Y;

SIDE_EXTEND = PIECE_D + PIECE_D/2;
SIDE_W      = 160;
SIDE_H      = BOARD_H + SIDE_EXTEND;

module board() {
	union() {
		difference() {
			square([BOARD_W, BOARD_H]);

			// Cut holes to be able to  see the pieces.
			for (x = [0 : BOARD_GRID_X-1]) {
				for (y = [0 : BOARD_GRID_Y-1]) {
					translate([x * PIECE_D + x*(MAT_W+2), y * PIECE_D])
					translate([PIECE_D / 2, PIECE_D / 2])
						circle(d=PIECE_D - BOARD_PADDING);
				}
			}

			// Cut holes for the column separators.
			for (x = [1 : BOARD_GRID_X-1]) {
				projection(cut=true)
				translate([x*(PIECE_D+MAT_W+2) - MAT_W, 0, -1])
				rotate(a=90, v=[0, 1, 0])
				linear_extrude(height=MAT_W)
					board_spacer();
			}
		}

		// Notches to attach the board to the sides.
		for (y = [0 : BOARD_GRID_X-1]) {
			translate([0, y*PIECE_D - ATTACH_W * y/(BOARD_GRID_X-1)]) {
				translate([-MAT_W, 0])
					square([MAT_W, ATTACH_W]);
				translate([BOARD_W, 0])
					square([MAT_W, ATTACH_W]);
			}
		}
	}
}

module board_spacer() {
	union() {
		square([BOARD_SPACING, PIECE_D*BOARD_GRID_Y]);
		for (y = [0 : BOARD_GRID_X-1]) {
			translate([0, y*PIECE_D - ATTACH_W * y/(BOARD_GRID_X-1)]) {
				translate([-MAT_W, 0])
					square([MAT_W, ATTACH_W]);
				translate([BOARD_SPACING, 0])
					square([MAT_W, ATTACH_W]);
			}
		}
	}
}

module side() {
	difference() {
		// Just use a square for now.
		square([SIDE_W, BOARD_H + SIDE_EXTEND]);

		for (x = [0 : 1]) {
			projection(cut=true)
			translate([SIDE_W/2 - MAT_W, SIDE_EXTEND])
			translate([-BOARD_SPACING/2 + (BOARD_SPACING+MAT_W)*x, 0, -1])
			rotate(a=90, v=[0, 1, 0])
			linear_extrude(height=MAT_W)
				board();
		}

		CUT_W = SIDE_W/2 - BOARD_SPACING - MAT_W;
		polygon([
			[CUT_W, SIDE_H],
			[0, 0],
			[0, SIDE_H],
		]);
		translate([SIDE_W - CUT_W, 0])
			polygon([
				[CUT_W, SIDE_H],
				[CUT_W, 0],
				[0, SIDE_H],
			]);
	}
}

module bottom() {
	// The bottom is just a panel that closes all columns. It could be improved
	// by making it movable.
	square([BOARD_W, BOARD_SPACING + MAT_W*2]);
}

module pieces() {
	for (x = [0 : BOARD_GRID_X-1]) {
		for (y = [0 : BOARD_GRID_Y-1]) {
			translate([PIECE_D/2, PIECE_D/2])
			translate([x * (PIECE_D+1), y * (PIECE_D+0.2)])
				circle(d=PIECE_D);
		}
	}
}

translate([MAT_W, 0])
	board();
translate([MAT_W, 6.05*PIECE_D])
	board();

for (x = [0 : BOARD_GRID_X-2]) {
	translate([8.65*PIECE_D + x*BOARD_SPACING*2.5, 0])
		board_spacer();
}

translate([8.5*PIECE_D + 0*(SIDE_W+10), 6.1*PIECE_D])
	side();
translate([8.5*PIECE_D + 1.5*(SIDE_W+10), 13.6*PIECE_D])
rotate(180)
	side();

translate([0, 12.1*PIECE_D])
	bottom();

translate([11.5*PIECE_D, 0])
	pieces();
