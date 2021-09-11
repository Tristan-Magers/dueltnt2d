function booms(){ //check all explosions and apply interactions to map
	
	for(i=0;i<ds_list_size(global.booms);i++){
		var tboom = ds_list_find_value(global.booms, i);
		tboom.counter++;
		if(tboom.counter>10) ds_list_delete(global.booms, i);
		
		if(tboom.counter == 1){
			xval = xa;
			yval = ya;

			for(var i=0;i<ds_grid_height(map);i++){
				for(var t=0;t<ds_grid_width(map);t++){
					tile = ds_grid_get(map,t,i);					
					if(tile != -99 && tile.h > 0){
						rang = sqrt(power(tboom.xpos - xval, 2) + power(tboom.ypos - yval, 2));
						rang -= tile_size/1.9;
						if(rang < 0) rang = 0; 
						if(rang < tboom.rm) {
							tile.heal = 0;
							tile.h -= floor(power((1 - (rang + 0.01)/tboom.r),0.5) * tboom.breaker);
						}
					}
					xval += 64;
				}
				xval = xa;
				yval += 64;
			}
		}
	}
}

function makeboom(btype, xp, yp){ 	//create explosion based on type
	
	//res = resistance id, preventing hitting certain entities
	//blaster = knockback that causes bounce

	if (btype == 0) { //bouncer 1
			newboom = {
			xpos : 0,
			ypos : 0,
			draw : true,
			blaster : true,
			r : 240,
			rm : 140,
			knock : 22,
			breaker : 5,
			res : -10,
			counter : 0
		}	
	}
	
	if (btype == 1) { //sticky
			newboom = {
			xpos : 0,
			ypos : 0,
			draw : true,
			blaster : true,
			r : 91,
			rm : 90,
			knock : 16.5,
			breaker : 9,
			res : -1,
			counter : 0
		}	
	}
	
	if (btype == 2) { //strong boost
			newboom = {
			xpos : 0,
			ypos : 0,
			draw : true,
			blaster : true,
			r : 110,
			rm : 110,
			knock : 14.5,
			breaker : 8,
			res : -1,
			counter : 0
		}	
	}
	
	if (btype == 3) { //weak boost
			newboom = {
			xpos : 0,
			ypos : 0,
			draw : true,
			blaster : true,
			r : 110,
			rm : 100,
			knock : 12.5,
			breaker : 5,
			res : -1,
			counter : 0
		}	
	}
	
	if (btype == 4) { //missile
			newboom = {
			xpos : 0,
			ypos : 0,
			draw : true,
			blaster : true,
			r : 170,
			rm : 170,
			knock : 30,
			breaker : 16,
			res : -1,
			counter : 0
		}	
	}
	
	if (btype == 5) { //bouncer 2
			newboom = {
			xpos : 0,
			ypos : 0,
			draw : true,
			blaster : true,
			r : 120,
			rm : 90,
			knock : 15,
			breaker : 7,
			res : -1,
			counter : 0
		}	
	}
	
	if (btype == 100) { //head pound
			newboom = {
			xpos : 0,
			ypos : 0,
			draw : false,
			blaster : false,
			r : 110,
			rm : 90,
			knock : 0,
			breaker : 10.5,
			res : -1,
			counter : 0
		}	
	}
	
	if (btype == 101) { //head pound kb
			newboom = {
			xpos : 0,
			ypos : 0,
			draw : true,
			blaster : true,
			r : 150,
			rm : 90,
			knock : 11,
			breaker : 0,
			res : 1,
			counter : 0
		}	
	}
	
	newboom.xpos = xp;
	newboom.ypos = yp;
	newboom.counter = 0;
	
	ds_list_add(global.booms,newboom);
}

function bombtype() { //set entity properties based on type
	
	if (bt == 0) { //bouncer
		size_x = 28;
		size_y = 28;

		bouncy = true;
		bounce = 0.65;
		
		fric_ground = 15;

		w = 3;
		
		fuse = 23;
		trigger = 2;
		trig_switch_type = 5;
	}
	
	if (bt == 1) { //sticky
		size_x = 24;
		size_y = 24;
		
		sticky = true;
		bouncy = true;
		bounce = 0.08;
		
		w = 2;
		
		fuse = 8;
		trigger = 1;
		trig_switch_type = -1;
	}
	
	if (bt == 2) { //weak boost
		size_x = 5;
		size_y = 5;
		
		sticky = false;
		bouncy = false;

		w = 20;
		
		fuse = 5;
		trigger = 0;
		trig_switch_type = -1;
		
		mgravity = false;
	}
	
	if (bt == 3) { //strong boost
		size_x = 5;
		size_y = 5;
		
		sticky = false;
		bouncy = false;

		w = 20;
		
		fuse = 5;
		trigger = 0;
		trig_switch_type = -1;
		
		mgravity = false;
	}
	
	if (bt == 4) { //missile
		size_x = 30;
		size_y = 30;
		
		sticky = true;
		bouncy = false;

		w = 20;
		
		fuse = 13;
		trigger = 1;
		trig_switch_type = -1;
		
		mgravity = true;
	}
	
	tset = true;	
}