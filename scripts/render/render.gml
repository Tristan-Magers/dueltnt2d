function rendermap(){
	for(var i=0;i<ds_grid_height(map);i++){
		for(var t=0;t<ds_grid_width(map);t++){
			var tile = ds_grid_get(map,t,i);
			
			var tile_spr = 0;
			var tile_op = 1;
			
			if (tile != -99) {	
				//color, shade, and sprite based on state
				if(tile.state == 4) {
					th = tile.h/20;
					h = th * 75 + 180;
					col = make_colour_hsv(135, 100, h);
				}
				if(tile.state == 3) {
					th = tile.h/18;
					h = th * 75 + 180;
					col = make_colour_hsv(120, 100, h);
				}
				if(tile.state == 2) {
					th = tile.h/16;
					h = th * 75 + 180;
					col = make_colour_hsv(60, 100, h);
				}
				if(tile.state == 1) {
					th = tile.h/10;
					h = th * 75 + 180;
					col = make_colour_hsv(20, 100, h);
				}
				if(tile.state == 50) {
					th = 1;
					tile_spr = 9;
					h = th * 75 + 180;
					col = make_colour_hsv(125, 20, h);
					tile_op = 0.5;
				}
				if(tile.state == 99) {
					th = 1;
					tile_spr = 5;
					h = th * 75 + 180;
					col = make_colour_hsv(140, 60, h);
				}
				if(tile.h > 0) {
					
					//bottom and top shading
					if(tile_spr == 0) {
						if(i==0) {
							tile_spr = 7;
						}
						else {
							var tile_above = ds_grid_get(map,t,i-1);
							if(tile_above == undefined || tile_above == -99 || tile_above.h < 1) tile_spr = 7;
						}						
					}
					if(tile_spr == 0) {
						if(i == ds_grid_height(map) - 1) {
							tile_spr = 6;
						}
						else {
							var tile_below = ds_grid_get(map,t,i+1);
							if(tile_below == undefined || tile_below == -99) tile_spr = 6;
						}
					}
					
					//hanging tile inner
					if(tile.col == 1) tile_spr = 11;
					
					draw_sprite_ext(spr_tile, tile_spr, tile.xpos, tile.ypos, 1, 1, 0, col, tile_op);
					
					if(tile.col == 2) {
						if(th >= 0.3 && th < 0.8) draw_sprite_ext(spr_tile, 8, tile.xpos, tile.ypos, 1, 1, 0, c_black, 0.55-(th/1.2));
						if(th < 0.3) draw_sprite_ext(spr_tile, 1, tile.xpos, tile.ypos, 1, 1, 0, c_black, 0.55-(th/1.2));	
					}
					if(tile.col == 1) {
						if(th >= 0.3 && th < 0.8) draw_sprite_ext(spr_tile, 11, tile.xpos, tile.ypos, 1, 1, 0, c_black, 0.55-(th/1.2));
						if(th < 0.3) draw_sprite_ext(spr_tile, 11, tile.xpos, tile.ypos, 1, 1, 0, c_black, 0.55-(th/1.2));	
					}
					
					//outline
					if(tile.col == 2) draw_sprite_ext(spr_tile, 4, tile.xpos, tile.ypos, 1, 1, 0, c_white, 1);
					if(tile.col == 1) draw_sprite_ext(spr_tile, 10, tile.xpos, tile.ypos, 1, 1, 0, c_white, 1);
				}
				//respawn
				if(tile.state > 1 && tile.h < 1 && tile.counter > 480) {
					var fade = ((tile.counter - 480) / 570) + 0.15;
					if(tile.counter < 570) draw_sprite_ext(spr_tile, 2, tile.xpos, tile.ypos, 1, 1, 0, c_purple, fade);
					else draw_sprite_ext(spr_tile, 3, tile.xpos, tile.ypos, 1, 1, 0, c_red, fade);
				}
			}
		}
	}
}

function renderbooms(){
	for(i=0;i<ds_list_size(global.booms);i++){
			tboom = ds_list_find_value(global.booms, i);
			
			if (tboom.draw) {
				scale = (10 - tboom.counter)/5;
				if (scale > 1) scale = 1;
				scale = (tboom.rm/64 * scale);
			
				draw_sprite_ext(spr_boom, 0, tboom.xpos, tboom.ypos, scale, scale, 0, c_white, 0.5);					
			}
	}
}