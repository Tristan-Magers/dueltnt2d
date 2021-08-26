if (global.state == 0) {
	draw_text(room_width/2 - 72, room_height/4, "press S to start");
}
	
if (global.state == 1) {
	draw_text(room_width/2 - 80, 20, "A/D - move, W - jump, S - pound, SPACE - explode, Mouse1 - boucer, Mouse2 - sticky");
	
	//var tile_x = floor((mouse_x - global.xa + global.tile_size/2)/global.tile_size);
	//var tile_y = floor((mouse_y - global.ya + global.tile_size/2)/global.tile_size);
	//var tile = ds_grid_get(map,tile_x,tile_y);
	//draw_text(50, 140, check_ground_y(tile_x));
}

draw_text(room_width/2 - 40, 40, "P - Exit Game, I - Switch Map, O - Toggle Fullscreen");	

text_time = "Timer: " + string(round(global.timer/60));
text_sc = "High Score: " + string(global.hsc);
text_hsc = "Score: " + string(global.sc);

draw_text(50, 50, text_time);
draw_text(50, 80, text_hsc);	
draw_text(50, 110, text_sc);