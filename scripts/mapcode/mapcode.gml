function manmap(){ //manage tile states
	
	for(var i=0;i<ds_grid_height(map);i++){
		for(var t=0;t<ds_grid_width(map);t++){
			var tile = ds_grid_get(map,t,i);
			
			if (tile != -99) {
				//glass tile health cap
				if(tile.h > 0 && tile.state = 50) tile.h = 2;
				
				//action on break
				if(tile.h < 1) {
					switch(tile.state) {			
						case 99 :
							tile.h = 99999;	
							break;
							
						default :
							tile.counter++;
							tile.h = 0;
							if(tile.counter == 1) {
								shard(3, xa + tile_size * t, ya + tile_size * i, 10);
							}
						
					}
				}
				
				//action on repair
				if(tile.counter > 600) {
					tile.counter = 0;
					if(tile.state != 50) tile.state--;
					switch(tile.state){
						case 50 :
							tile.h = 1;
							tile.kill = 11;
							break;
						case 3 :
							tile.h = 20;
							tile.kill = 11;
							break;	
						case 2 :
							tile.h = 16;
							tile.kill = 11;
							break;	
						case 1 :
							tile.h = 10;
							tile.kill = 11;
							break;	
					}
				}
				
				//unused healing tile code
				//tile.heal++;
				if(tile.heal > 240 && tile.h > 0) {
					tile.h++;
					tile.heal = 0;
					if(tile.state == 3 && tile.h > 18) {
						tile.h = 18;
					}
					if(tile.state == 2 && tile.h > 16) {
						tile.h = 16;
					}
					if(tile.state == 1 && tile.h > 10) {
						tile.h = 10;
					}
				}
				if(tile.kill > 0) tile.kill--;	
			}
		}
	}
}