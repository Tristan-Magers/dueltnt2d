function gamestart(){
	global.timer = 3600;
	global.sc = 0;
	
	//map
	if (map_shape == 0) map = ds_grid_create(17, 4);
	if (map_shape == 1) map = ds_grid_create(17, 4);
	if (map_shape == 2) map = ds_grid_create(12, 6);

	tile_size = 64;

	xval = 0;
	yval = 0;

	xa = room_width/2 - (ds_grid_width(map)/2*tile_size) + tile_size/2;
	ya = 686 - ds_grid_height(map) * tile_size;

	xval = xa;
	yval = ya;

	for(var i=0;i<ds_grid_height(map);i++){
		for(var t=0;t<ds_grid_width(map);t++){
			tile = {
				xpos : 0,
				ypos : 0,
				h : 20,
				state : 4,
				col : 2,
				counter : 0,
				heal : 0,
				kill : 0
			}
		
			tile.xpos = xval;
			tile.ypos = yval;
		
			ds_grid_add(map,t,i,tile);
			xval += tile_size;
		}
		xval = xa;
		yval += tile_size;
	}

	mapshape();

	global.map = map;
	global.tile_size = tile_size;
	global.xa = xa;
	global.ya = ya;

	//boom manager
	global.booms = ds_list_create();
	
	//player manager
	global.players = ds_list_create();

	//create characters
	playert = instance_create_layer(0, 0, "game_layer", obj_char);

	instance_create_layer(0, 0, "game_layer", obj_dummy);
	instance_create_layer(0, 0, "game_layer", obj_dummy);
	instance_create_layer(0, 0, "game_layer", obj_dummy);
}

function mapshape() {
	if (map_shape == 0)	{
		ds_grid_add(map,0,0,-99);
		ds_grid_add(map,1,0,-99);
		ds_grid_add(map,2,0,-99);
		ds_grid_add(map,3,0,-99);
		ds_grid_add(map,4,0,-99);
		ds_grid_add(map,5,0,-99);
		ds_grid_add(map,6,0,-99);
	
		ds_grid_add(map,10,0,-99);
		ds_grid_add(map,11,0,-99);
		ds_grid_add(map,12,0,-99);
		ds_grid_add(map,13,0,-99);
		ds_grid_add(map,14,0,-99);
		ds_grid_add(map,15,0,-99);
		ds_grid_add(map,16,0,-99);
	
		ds_grid_add(map,0,1,-99);
		ds_grid_add(map,1,1,-99);
		ds_grid_add(map,2,1,-99);
		ds_grid_add(map,3,1,-99);
		ds_grid_add(map,4,1,-99);

		ds_grid_add(map,12,1,-99);
		ds_grid_add(map,13,1,-99);
		ds_grid_add(map,14,1,-99);
		ds_grid_add(map,15,1,-99);
		ds_grid_add(map,16,1,-99);
		
		//ds_grid_add(map,2,2,-99);
		//ds_grid_add(map,2,3,-99);
		//ds_grid_add(map,3,2,-99);
		//ds_grid_add(map,3,3,-99);
		//ds_grid_add(map,13,2,-99);
		//ds_grid_add(map,13,3,-99);
		
		//ds_grid_add(map,10,1,-99);
		//ds_grid_add(map,10,2,-99);
		//ds_grid_add(map,10,3,-99);
	}
	
	if (map_shape == 1)	{
		ds_grid_add(map,0,0,-99);
		ds_grid_add(map,1,0,-99);
		ds_grid_add(map,2,0,-99);

		ds_grid_add(map,6,0,-99);	
		ds_grid_add(map,7,0,-99);
		ds_grid_add(map,8,0,-99);
		ds_grid_add(map,9,0,-99);
		ds_grid_add(map,10,0,-99);

		ds_grid_add(map,14,0,-99);
		ds_grid_add(map,15,0,-99);
		ds_grid_add(map,16,0,-99);
	
		ds_grid_add(map,0,1,-99);
		ds_grid_add(map,1,1,-99);
		ds_grid_add(map,2,1,-99);
		ds_grid_add(map,3,1,-99);
		ds_grid_add(map,4,1,-99);

		ds_grid_add(map,5,1,-99);
		ds_grid_add(map,6,1,-99);
		ds_grid_add(map,7,1,-99);
		ds_grid_add(map,8,1,-99);
		ds_grid_add(map,9,1,-99);
		ds_grid_add(map,10,1,-99);
		ds_grid_add(map,11,1,-99);

		ds_grid_add(map,12,1,-99);
		ds_grid_add(map,13,1,-99);
		ds_grid_add(map,14,1,-99);
		ds_grid_add(map,15,1,-99);
		ds_grid_add(map,16,1,-99);
		
		ds_grid_get(map,3,0).col = 1;
		ds_grid_get(map,4,0).col = 1;
		ds_grid_get(map,5,0).col = 1;	
		
		ds_grid_get(map,11,0).col = 1;
		ds_grid_get(map,12,0).col = 1;
		ds_grid_get(map,13,0).col = 1;	
		
		ds_grid_get(map,3,2).state = 99;
		ds_grid_get(map,4,2).state = 99;
		ds_grid_get(map,5,2).state = 99;	
		
		ds_grid_get(map,11,2).state = 99;
		ds_grid_get(map,12,2).state = 99;
		ds_grid_get(map,13,2).state = 99;	
		
		ds_grid_get(map,3,3).state = 99;
		ds_grid_get(map,4,3).state = 99;
		ds_grid_get(map,5,3).state = 99;	
		
		ds_grid_get(map,11,3).state = 99;
		ds_grid_get(map,12,3).state = 99;
		ds_grid_get(map,13,3).state = 99;	
	}
	
	if (map_shape == 2)	{
		xval = xa;
		yval = ya;
		
		for(var i=0;i<ds_grid_height(map);i++){
		for(var t=0;t<ds_grid_width(map);t++){
				tile = {
					xpos : 0,
					ypos : 0,
					h : 1,
					state : 50,
					col : 2,
					counter : 0,
					heal : 0,
					kill : 0
				}
		
				tile.xpos = xval;
				tile.ypos = yval;
		
				ds_grid_add(map,t,i,tile);
				xval += tile_size;
			}
			xval = xa;
			yval += tile_size;
		}
		
		ds_grid_get(map,5,1).state = 99;
		ds_grid_get(map,6,1).state = 99;	
		
		ds_grid_get(map,5,2).state = 99;
		ds_grid_get(map,6,2).state = 99;
		
		ds_grid_get(map,1,3).state = 99;
		ds_grid_get(map,2,3).state = 99;	
		
		ds_grid_get(map,1,4).state = 99;
		ds_grid_get(map,2,4).state = 99;
		
		ds_grid_get(map,9,3).state = 99;
		ds_grid_get(map,10,3).state = 99;	
		
		ds_grid_get(map,9,4).state = 99;
		ds_grid_get(map,10,4).state = 99;
		
		ds_grid_add(map,0,0,-99);
		ds_grid_add(map,0,1,-99);
		
		ds_grid_add(map,1,0,-99);
		ds_grid_add(map,1,1,-99);
		
		ds_grid_add(map,2,0,-99);
		ds_grid_add(map,2,1,-99);
	
		ds_grid_add(map,3,0,-99);
		ds_grid_add(map,3,1,-99);

		
		ds_grid_add(map,11,0,-99);
		ds_grid_add(map,11,1,-99);
		
		ds_grid_add(map,10,0,-99);
		ds_grid_add(map,10,1,-99);
		
		ds_grid_add(map,9,0,-99);
		ds_grid_add(map,8,0,-99);
		ds_grid_add(map,9,1,-99);
		ds_grid_add(map,8,1,-99);
		
	}
	
	camera_set_view_pos(view_camera[0], 0, 100);
}