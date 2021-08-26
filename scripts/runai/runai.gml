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
	
	goal_x = mouse_x;
	goal_y = mouse_y;
	
	var unit_t = (goal_x - xpos) / abs(goal_x - xpos)
	if (goal_x == xpos) unit_t = 1
	
	if (tar_dist < 30) goal_x -= unit_t * 20;
	
	x_dist = abs(xpos - goal_x);
	y_dist = abs(ypos - goal_y);
	
	jtime = abs(10/0.8);
	jdist = (jtime + 1) * 10/2;
	
	if(!check_ground_y(get_tile_x(goal_x))) go_to_safe(goal_x);
	
	var tile_x = get_tile_x(goal_x);
	var tile_x_m = get_tile_x(xpos);
	
	target_x = goal_x - (30 * unit_t);
	target_y = goal_y + 30;
	
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
					goal_x = global.tile_size * (temp) + xa;
					goal_y = global.tile_size * check_ground_max(temp) + ya - global.tile_size ;
					gap = true;
				}
				else {
					if(!gap || (ground > 1 && abs(i-tile_x_m) < 5)) temp = i;
				}
			}
			
			if (i == tile_x) i = 10000;
		}
		if(temp != tile_x_m) {
			goal_x =  global.tile_size * (temp) + xa;
			goal_y = global.tile_size * check_ground_max(temp) + ya - global.tile_size ;
		}
		temper = unit_t;
	}
	
	movement_select();
	
	check_presses();
}

function movement_select() {	
	var safe = check_ground_y(get_tile_x(xpos));
	
	var safemove = check_land();
	
	if (safemove > -1) safemove = true;
	else safemove = false;
	
	var tile_x_m = get_tile_x(xpos);
	var tile_y_m = get_tile_y(ypos);
	
	if(tile_x_m > -1 && tile_x_m < ds_grid_width(map) && tile_y_m > -1 && tile_y_m < ds_grid_height(map)) {
		var tile = ds_grid_get(map,tile_x_m, tile_y_m);
		if(tile != -99 && tile.h < 1 && tile.counter > 560) up_p = true;
	}
	
	if(!(safe && !safemove) && (tar_dist > 30 || !safe)) {
		if(x_dist > 5 && 12 < abs((xpos + vx*4) - goal_x)) {
			if(xpos > goal_x) left_p = true;
			else right_p = true;
		}	
	}
	
	//jump if wall
    if(checkwall > 0 && vy > -1) up_p = true;
	//stay jumping
	if(up > 0 && vy < 0 && (goal_y < ypos || !safe)) up_p = true;
	//jump if close
	if(ground > 0 && y_dist < jdist && goal_y + 30 < ypos && (goal_x - xpos)/vx < jtime) up_p = true;	
	
	//if(tar_dist < 90 && tar_dist > 30 && rmouse == 0) rmouse_p = true;
	//if(tar_dist < 25 && tar_dist > 10 && space == 0) space_p = true;
	//if(tar_dist < 10 && down == 0) down_p = true;
	
	if(!safe && !(safemove && ground == 0) && vy > 2) up_p = true;
}

function go_to_safe(t_x) {
	var change = false;
	var p_tile_x = get_tile_x(t_x);
	if (p_tile_x < xa) {
		for (var i = p_tile_x; i < xa; ++i) {
			if check_ground_y(i) {
				goal_x = global.tile_size * i + xa;
				i = 100000;	
				change = true;
			}
		}
	}
	if (!change) {
		for (var i = xa-1; i > -1; --i) {
			if check_ground_y(i) {
				goal_x = global.tile_size * i + xa;
				i = -100;	
				change = true;
			}
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