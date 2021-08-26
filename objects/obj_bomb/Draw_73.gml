spawn_scale += 0.07;
if (spawn_scale > 1) spawn_scale = 1;

sc_x = size_x/11 * spawn_scale;
sc_y = size_y/11 * spawn_scale;

//if (sc_x < 1) sc_x = 1;
//if (sc_y < 1) sc_y = 1;

y_shift = 16 * (1 - spawn_scale);

if(tset && bt == 0 && trigger < 2 && counter2 >= fuse) {
	draw_sprite_ext(spr_ball, 5, xpos, ypos + y_shift, sc_x * 0.8, sc_y * 0.8, 0, c_white, 1);
}
else {
	if(counter2 == 0) draw_sprite_ext(spr_ball, bt*2, xpos, ypos + y_shift, sc_x, sc_y, 0, c_white, 1);
	else draw_sprite_ext(spr_ball, bt*2+1, xpos, ypos + y_shift, sc_x, sc_y, 0, c_white, 1);
}

check_land();

