// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function gettileinfo(){
	tile_size = global.tile_size;
	xa = global.xa;
	ya = global.ya;
}

function getmap(){
	map = global.map;	
}

function touchblock(size_x, size_y, t_x, t_y){
	var tile = ds_grid_get(map,t_x,t_y);
	if(tile == -99) return false;
	if(tile.h < 1) return false;
	var tiledifx = (tile_size - size_x)/2
	var tiledify = (tile_size - size_y)/2
	
	var testb = ya + (t_y*tile_size) + size_y + tiledify;
	var testh = ya + (t_y*tile_size) - size_y - tiledify;
	
	var testr = xa + (t_x*tile_size) + size_x+ tiledifx;
	var testl = xa + (t_x*tile_size) - size_x - tiledifx;
	
	if (ypos < testb && ypos > testh && xpos < testr && xpos > testl) {
		return true;
	}
	return false;
}

function hitblock(size_x, size_y, t_x, t_y){
	var tile = ds_grid_get(map,t_x,t_y);
	
	var isground = false;
	
	var tiledifx = (tile_size - size_x)/2
	var tiledify = (tile_size - size_y)/2
	
	var testb = ya + (i*tile_size) - size_y - tiledify;
	var testh = ya + (i*tile_size) + size_y + tiledify;
		
	var testr = xa + (t*tile_size) + size_x + tiledifx;
	var testl = xa + (t*tile_size) - size_x - tiledifx;
	
	var testb_2 = ya + (i*tile_size) + size_y/6 - tile_size/2;
	var testh_2 = ya + (i*tile_size) - size_y/6 + tile_size/2;
		
	var testr_2 = xa + (t*tile_size) + size_x/6 + tile_size/2;
	var testl_2 = xa + (t*tile_size) - size_x/6 - tile_size/2;
	
	if(tile.col >= 1 && ((ypos > testb) && !(prev_y > testb) && vy > 0)) {
		if (checkfloor == 0) checkfloor = 1;
		myfloor = testb;
		isground = true;
		
		if((xpos > testl_2) && (xpos < testr_2)) checkfloor = 2;
	}
	
	if(tile.col == 2 && ((ypos < testh) && !(prev_y < testh) && vy < 0)) {
		isground = true;
		
		if (checkceil == 0) checkceil = 1;
		myceil = testh;
		
		if((xpos > testl_2) && (xpos < testr_2)) checkceil = 2;
	}
	
	if(checkceil) {
		ypos = myceil;
	}
	
	if(tile.col == 2 && ((xpos < testr) && !(prev_x < testr) && vx < 0 && !isground)) {
		if (checkwall == 0) checkwall = 1;
		mywall = testr;
		
		if((ypos > testb_2) && (ypos < testh_2)) checkwall = 2;
	}
	
	if(tile.col == 2 && ((xpos > testl) && !(prev_x > testl) && vx > 0 && !isground)) {
		if (checkwall == 0) checkwall = 1;
		mywall = testl;
		
		if((ypos > testb_2) && (ypos < testh_2)) checkwall = 2;
	}
	
    if(checkwall) {
		xpos = mywall;
	}
	
	tiledifx = (tile_size - size_x)/2
	tiledify = (tile_size - size_y)/2
	
	testb = ya + (t_y*tile_size) + size_y + tiledify;
	testh = ya + (t_y*tile_size) - size_y - tiledify;
	
	testr = xa + (t_x*tile_size) + size_x+ tiledifx;
	testl = xa + (t_x*tile_size) - size_x - tiledifx;
	
	if (ypos < testb && ypos > testh && xpos < testr && xpos > testl) {
		if(tile.kill == 1 && (ypos < testb - 1 && ypos > testh + 1 && xpos < testr - 1 && xpos > testl + 1)) {
			dead = true;
		}
	}
}