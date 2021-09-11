function runai(){	
	up_p = false;
	down_p = false;
	left_p = false;
	right_p = false;
	space_p = false;
	shift_p = false;
	lmouse_p = false;
	rmouse_p = false;
	
	tar_dist = 10000
	var tar_x = 0
	var tar_y = 0
	var tar_id = -1
	for(i=0;i<ds_list_size(global.players);i++){ 
		var tplayer = ds_list_find_value(global.players, i);
		var t_dist = power(power(tplayer.mx - xpos,2) + power(tplayer.my - ypos,2),0.5);
		if (tplayer.alive && t_dist < tar_dist && i != myid) {
			tar_dist = t_dist;
			tar_x = tplayer.mx;
			tar_y = tplayer.my;
			tar_id = i;
		}
		else {
			//tar_x = xpos;
			//tar_y = ypos;
		}
	}
	
	goal_x = tar_x;
	goal_y = tar_y;
	
	//goal_x = mouse_x;
	//goal_y = mouse_y;
	
	test = "none";
	
	var unit_t = (goal_x - xpos) / abs(goal_x - xpos)
	if (goal_x == xpos) unit_t = 1
	
	if (tar_dist < 90) goal_x += find_vul(tar_x) * 15;
	
	x_dist = abs(xpos - goal_x);
	y_dist = abs(ypos - goal_y);
	
	jtime = abs(10/0.8);
	jdist = (jtime + 1) * 10/2;
	
	if(!check_ground_y(get_tile_x(goal_x))) {
		go_to_safe(goal_x);
		test = "safe";
	}
	
	var tile_x = get_tile_x(goal_x);
	var tile_x_m = get_tile_x(xpos);
	
	target_x = goal_x - (30 * find_vul(tar_x));
	target_y = goal_y + 20;
	
	var safe = check_land();
	
	if (safe > -1) safe = true;
	else safe = false;
	
	if (safe && tile_x != tile_x_m) {
		var temp = tile_x_m
		var gap = false;
		
		for (var i = tile_x_m; i < 1000; i += unit_t) {   
			if (i < 0) i = 10000;
			if (i > xa-1) i = 10000;
			if (i < 1000) {
				if(!check_ground_y(i)) {
					//goal_x = global.tile_size * (temp) + xa;
					//goal_y = global.tile_size * check_ground_max(temp) + ya - global.tile_size ;
					gap = true;
				}
				else {
					if(!gap || (ground > 1 && abs(i-tile_x_m) < 5)) temp = i;
				}
			}
			
			if (i == tile_x) i = 10000;
		}
		if(temp != tile_x_m && gap && check_ground_y(temp)) {
			goal_x =  global.tile_size * (temp) + xa;
			goal_y = global.tile_size * check_ground_max(temp) + ya - global.tile_size ;
		}
		if (gap) test = "gap";
	}
	
	if(!check_ground_y(get_tile_x(goal_x))) {
		go_to_safe(goal_x);
		test = "safe";
	}
	
	movement_select();
	
	check_presses();
}

function movement_select() {	
	var safe = check_ground_y(get_tile_x(xpos));
	
	var safemove = check_land();
	
	var land_x = safemove % ds_grid_width(map);
	var goal_x_t = get_tile_x(goal_x);
	
	if (safemove > -1) safemove = true;
	else safemove = false;
	
	var tile_x_m = get_tile_x(xpos);
	var tile_y_m = get_tile_y(ypos);
	
	if(tile_x_m > -1 && tile_x_m < ds_grid_width(map) && tile_y_m > -1 && tile_y_m < ds_grid_height(map)) {
		var tile = ds_grid_get(map,tile_x_m, tile_y_m);
		if(tile != -99 && tile.h < 1 && tile.counter > 585) up_p = true;
	}
	
	if(!(safe && !safemove)) {
		if(x_dist > 5 && 12 < abs((xpos + vx*4) - goal_x) && (tar_dist > 30 || !safemove) && !(land_x == goal_x_t && ground < 1)) {
			if(xpos > goal_x) left_p = true;
			else right_p = true;
		}
		
		if(tar_dist < 140 && tar_dist > 50 && (abs(xpos - goal_x) > 50 || ground > 0) && rmouse == 0) rmouse_p = true;
		if(tar_dist < 51 && tar_dist > 10 && (ground > 0 || safemove) && space == 0) space_p = true;
		if(tar_dist < 11 && down == 0 && !attacking) down_p = true;
		
		test2 = "move";
		if !(tar_dist > 30) test2 = "dist";
	}
	else {
		test2 = tar_dist;
		if((!safe)) test2 = "not safe";
		if((safe && !safemove)) test2 = "not safe move";
	}
	
	//jump if wall
    if(checkwall > 0 && vy > -1 && (ground > 0 || !safe)) up_p = true;
	//stay jumping
	if(up > 0 && vy < 0 && (goal_y - 1000 < ypos || !safe || checkwall > 0)) up_p = true;
	//jump if close
	if(ground > 0 && y_dist < jdist && goal_y + 30 < ypos && (goal_x - xpos)/vx < jtime) up_p = true;	
		
	if(!(safemove && ground == 0) && vy > 5) up_p = true;
	if(attacking && !safemove && down == 0) down_p = true;
	if(!attacking && !safemove && down == 0 && ground == 0 && vy > 5 && djump < 1) down_p = true;
}

function go_to_safe(t_x) {
	var p_tile_x = get_tile_x(t_x);
	var side_t = (t_x - xa)/global.tile_size - floor((t_x - xa)/global.tile_size)
	var end_t = false;
	test3 = side_t;
	if (p_tile_x < xa) {
		for (var i = 0; i < 30; ++i) {
			if (p_tile_x + i < xa && check_ground_y(p_tile_x + i)) {
				goal_x = global.tile_size * (p_tile_x + i) + xa;	
				end_t = true;
			}
			if ((!end_t || side_t > 0.5) && p_tile_x - i >= 0 && check_ground_y(p_tile_x - i)) {
				goal_x = (global.tile_size * (p_tile_x - i)) + xa;
				end_t = true;
			}
			if (end_t) i = 100000;
		}
	}
}

function check_ground_max(p_x) {
	gettileinfo();

	if (p_x >= 0 && p_x < ds_grid_width(map)) {
		for (var i = 0; i < ds_grid_height(map); ++i) {
		    var tile = ds_grid_get(map,p_x,i);
			if (tile != undefined && tile != -99 && tile.h > 0) return i;
		}
	}	
	
	return -1;
}

function check_ground_y(t_x) {
	gettileinfo();
	if (t_x >= 0 && t_x < ds_grid_width(map)) {
		for (var i = 0; i < ds_grid_height(map); ++i) {
		    var tile = ds_grid_get(map,t_x,i);
			if (tile != undefined && tile != -99 && tile.h > 0) return true;
		}
	}	
	
	return false;
}

function find_vul(t_x) {
	var p_tile_x = get_tile_x(t_x);
	var side_t = (t_x - xa)/global.tile_size - floor((t_x - xa)/global.tile_size)
	var end_t = false;
	if (p_tile_x < xa) {
		for (var i = 0; i < 30; ++i) {
			if (p_tile_x + i < xa && !check_ground_y(p_tile_x + i)) {
				end_t = true;
			}
			if ((!end_t || side_t > 0.5) && p_tile_x - i >= 0 && !check_ground_y(p_tile_x - i)) {
				return -1;
				end_t = true;
			}
			if (end_t) return 1;;
		}
	}
}

function check_presses() {
	if(up_p) press_up(); 
	else up = 0;
	
	if(down_p) press_down(); 
	else down = 0;
	
	if(left_p) press_left(); 
	else left = 0;
	
	if(right_p) press_right(); 
	else right = 0;
	
	if(space_p) press_space(); 
	else space = 0;
	
	if(shift_p) press_shift(); 
	else shift = 0;
	
	if(lmouse_p) press_lmouse(); 
	else lmouse = 0;
	
	if(rmouse_p) press_rmouse(); 
	else rmouse = 0;
}

function press_up() {
	if(up == 0) up = 2;
	else up = 1;
}

function press_down() {
	if(down == 0) down = 2;
	else down = 1;
}

function press_left() {
	if(left == 0) left = 2;
	else left = 1;
}

function press_right() {
	if(right == 0) right = 2;
	else right = 1;
}

function press_space() {
	if(space == 0) space = 2;
	else space = 1;
}

function press_shift() {
	if(shift == 0) shift = 2;
	else shift = 1;
}

function press_lmouse() {
	if(lmouse == 0) lmouse = 2;
	else lmouse = 1;
}

function press_rmouse() {
	if(rmouse == 0) rmouse = 2;
	else rmouse = 1;
}