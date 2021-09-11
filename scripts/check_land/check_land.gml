function check_land(){
	//var unit_t = sqrt(power(vx,2) + power(vy,2));
	//var vx_t = vx/unit_t * global.tile_size/2;
	//var vy_t = vy/unit_t * global.tile_size/2;
	
	var vx_t = vx;
	var vy_t = vy;
	
	var px_t = xpos;
	var py_t = ypos;
	
	px_t += vx_t;
	py_t += vy_t;
	
	var ph = 1 - (1/fric_air);
	vx_t *= ph;
	
	for (var i = 0; i < 200; ++i) {
		var tile_t = tile_check_land(px_t + size_x/2,py_t + size_y/2);
		if (tile_t > -1) return tile_t;
		var tile_t = tile_check_land(px_t - size_x/2,py_t + size_y/2);
		if (tile_t > -1) return tile_t;
		var tile_t = tile_check_land(px_t + size_x/2,py_t - size_y/2);
		if (tile_t > -1) return tile_t;
		var tile_t = tile_check_land(px_t - size_x/2,py_t - size_y/2);
		if (tile_t > -1) return tile_t;
		
		draw_sprite_ext(spr_cross, 5, px_t, py_t, 0.2, 0.2, 0, c_yellow, 0.5);
		
		vy_t += g;
		var ph = 1 - (1/fric_air);
		vx_t *= ph;
		
		px_t += vx_t;
		py_t += vy_t;		
	}
	return -1;
}

function get_tile_y(p_y) {
	return floor((p_y - global.ya + global.tile_size/2)/global.tile_size);
}

function get_tile_x(p_x) {
	return floor((p_x - global.xa + global.tile_size/2)/global.tile_size);	
}

function tile_check_land(t_x,t_y) {
	var tile_x_t = get_tile_y(t_x + xa + global.tile_size * 1.5);
	var tile_y_t = get_tile_y(t_y);
	if (tile_x_t > -1 && tile_y_t > -1 && ds_grid_width(map) > tile_x_t && ds_grid_height(map) > tile_y_t) {
		var tile = ds_grid_get(map,tile_x_t,tile_y_t);
		if (tile != undefined && tile != -99 && tile.h > 0) {
			var will_land = tile_x_t + tile_y_t * ds_grid_width(map);
			var land_x = xa + ((will_land % ds_grid_width(map))) * global.tile_size;
			var land_y = ya + floor(will_land / ds_grid_width(map)) * global.tile_size;
			if (will_land > -1) draw_sprite_ext(spr_cross, 5, land_x, land_y, 1.2, 1.2, 0, c_yellow, 0.5);
			return will_land;
		}
	}
	return -1;
}