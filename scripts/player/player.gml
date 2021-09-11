function player(){
	if (!ai) keypress();
	else runai();

	//jump
	if (!attacking) {
		//start jump
		 if (((ground > 1 || djump > 0)) && up == 2) {
			if(ground > 1) {
				vy = -10;
				vx *= 1.1;
				djump=1;
				ground = 0;
				jump_hold = 10;
			}
			else {
				if(vy > -3) {bomb3();}
				else {bomb4();}
				//can_attack = true;
				if(vy>-4) vy = -4;
				else vy -= 2;
				djump--;		
				angry = 20;
				ground = 0;
			}
		}
		
		//hold jump
		if (up < 1) {
			if(jump_hold > 0) {
				g = 1.0;
				jump_hold--;
			}
			else g = 0.8
		 }
		 else {
			if(jump_hold > 0) {
				g = 0.2;			
				jump_hold--;
			}
			else {
				g = 0.8;	
			}		
		 }	
	}
	
	//left-right movement
	if (right > 0 && checkwall == 0) {
		if(ground > 1) {
			if(shift == 0) { 
				if(vx < 1) fx += 2.9;
				else  { 
					if(vx > 2) fx += 2.8;
					else  fx += 2.35;
				}
			}
			else fx += 1.8;
		}
		else {
			if(shift == 0) fx += 1.85;
			else fx += 1.3;
		}
	}
	if (left > 0 && checkwall == 0) {
		if(ground > 1) {
			if(shift == 0 && shift == 0) { 
				if(vx > -1) fx -= 2.9;
				else  { 
					if(vx < -2) fx -= 2.8;
					else  fx -= 2.35;
				}
			}
			else fx -= 1.8;
		}
		else {
			if(shift == 0) fx -= 1.85;
			else fx -= 1.3;
		}
	};
	
	//moving-stop friction
	if (shift == 0 || (right == 0 && left == 0)) fric_ground = 10;
	else fric_ground = 4;
	
	//attack states
	if ((down == 2) && attacking && space == 0) { //cancle down
		attacking = false;
		can_attack = false;
		if(vy > -12) {	
			vy = -12;
		}
		g = 0.8;
		ground = 0;
	}
	
	if (((down > 1 && ground < 1) || (down == 2 && ground > 0)) && !attacking && can_attack && space == 0) { //start down
		attacking = true;	
		can_attack = false;	
		attack = 0;
	}
	
	//space attack
	if(space_timer > 0) space_timer--;
	
	if (space == 2 && djump > 0 && !attacking && down == 0) {
		if(vy > -3) bomb3();
		else bomb4();
		
		djump=0;
		ground = 0;
		track_vy = vy;
		vy = -4;		
		angry = 12;
		space_timer = 5;
	}
	
	//charge
	if (!charged && space > 0 && down > 0 && attack_time < 3 && (space == 2 || down == 2 || charge > 0)) {
		charge++;
		
		//when to show
		if(charge > 1) charging = true;
		else charging = false;
		
		//end previous
		if (charge == 1) {
			if(space_timer > 0) {
				instance_destroy(trackbomb);
				vy = track_vy;
				djump++;
			}
			
			//can_attack = false;
			//djump = 0;
		}
		
		//during / ending
		if(charge >= 1) {
			attacking = false;
		}
		
		//at max
		if (charge > charge_max) {
			charge = 0;
			charged = true;
			ammo = 1;
		}
	}
	else {
		charge = 0;
		charging = false;
	}
	
	//attack manage
	if (attacking) {
		attack_time++;
		if(attack_time > 8) angry = 5;
		
		if(attack_time == 3) {
			if(vy > -11) vy = -11;
			vx *= 1.1;
			g = 1.5;
			ground = 0;	
		}
	}
	else {
		attack_time = 0;
		attack = -1;
	}
	
	if (ground > 1 && vy < 1 && (attack_time > 3 || attack_time < 1)) {
		if (attacking) {
			vy = ((attack_time - 11) * -0.62) - 5;
			makeboom(100, xpos, ypos + 60);
			makeboom(101, xpos, ypos - 10);
			ground = 0;
		}
		else {
			can_attack = true;	
		}
		
		attacking = false;
		g = 0.8;
	}
	
	//physics
	fric_air = 19;
	phy_obj(fric_ground, fric_air);
	
	//mouse attacks
	xdif = target_x - xpos;
	ydif = target_y - ypos;
	ang = arctan2(ydif, xdif);
	
	if((mouse_hold == 1 || lmouse == 2) && ammo > 0 && !attacking) {
		if(shot_d = 0 || (shot_d_s = 0 && shot_t != 0)) {
			if(!charged) bomb1();
			else bomb5();
		}
		else mouse_hold = 1;
	}
	if((mouse_hold == 2 || rmouse == 2) && ammo > 0 && !attacking) {
		if(shot_d = 0 || (shot_d_s = 0 && shot_t != 1)) {
			if(!charged) bomb2();
			else bomb5();
		}
		else mouse_hold = 2;
	}
	
	if(lmouse > 0 && rmouse == 0 && shot_t == 0 && reload == 0) mouse_hold = 1;
	if(rmouse > 0 && lmouse == 0 && shot_t == 1 && reload == 0) mouse_hold = 2;
	
	if(lmouse == 2 && rmouse == 0 && reload > 30) mouse_hold = 1;
	if(rmouse == 2 && lmouse == 0 && reload > 30) mouse_hold = 2;
	
	if(lmouse == 0 && rmouse == 0) mouse_hold = 0;
	
	if(ammo < 2) {
		reload++;
		if(reload > 53) {
			reload = 0;
			ammo = 2;
			shot_t = -1;
		}
	}
	
	//dead trigger
	if(dead){
		global.state = 2;
		
		//ypos = 0;
		//xpos = room_width/2;
		dead = false;	
	}
	
	//players manager
	var newplay = {
		alive : true,
		mx : xpos,
		my : ypos,
	}

	ds_list_replace(global.players,myid,newplay);
	
	//state timers
	if (angry > 0) angry--;
	if (shot_d > 0) shot_d--;
	if (shot_d_s > 0) shot_d_s--;
}

function keypress(){
	up = 0;
	down = 0;
	left = 0;
	right = 0;
	space = 0;
	shift = 0;
	lmouse = 0;
	rmouse = 0;
	
	if keyboard_check(vk_up) up = 1;
	if keyboard_check(vk_down) down = 1;
	if keyboard_check(vk_left) left = 1;
	if keyboard_check(vk_right) right = 1;
	
	if keyboard_check(vk_space) space = 1;
	if keyboard_check(vk_shift) shift = 1;
	
	if keyboard_check(ord("W")) up = 1;
	if keyboard_check(ord("S")) down = 1;
	if keyboard_check(ord("A")) left = 1;
	if keyboard_check(ord("D")) right = 1;
	
	if mouse_check_button(mb_left) lmouse = 1;
	if mouse_check_button(mb_right) rmouse = 1;
	
	if keyboard_check_pressed(vk_up) up = 2;
	if keyboard_check_pressed(vk_down) down = 2;
	if keyboard_check_pressed(vk_left) left = 2;
	if keyboard_check_pressed(vk_right) right = 2;
	
	if keyboard_check_pressed(vk_space) space = 2;
	if keyboard_check_pressed(vk_shift) shift = 2;
	
	if keyboard_check_pressed(ord("W")) up = 2;
	if keyboard_check_pressed(ord("S")) down = 2;
	if keyboard_check_pressed(ord("A")) left = 2;
	if keyboard_check_pressed(ord("D")) right = 2;
	
	if mouse_check_button_pressed(mb_left) lmouse = 2;
	if mouse_check_button_pressed(mb_right) rmouse = 2;
	
	target_x = mouse_x;
	target_y = mouse_y;
}

function room_adjust() {
	var center_weight = 3
	var cam_speed = 12;

	camera_set_view_size(view_camera[0],room_width/room_scale,room_height/room_scale);

	var camx = ((xpos - room_width/(room_scale * 2))/center_weight);
	var camy = ((ypos - room_height/(room_scale * 2))/center_weight);

	var camx_d = camera_get_view_x(view_camera[0]) - camx;
	var camy_d = camera_get_view_y(view_camera[0]) - camy;

	camx = camera_get_view_x(view_camera[0]) - camx_d/cam_speed;
	camy = camera_get_view_y(view_camera[0]) - camy_d/cam_speed;

	camera_set_view_pos(view_camera[0], camx, camy);
}

function bomb1() { //bouncer
		newbomb = instance_create_layer(0, 0, "game_layer", obj_bomb);
		newbomb.xpos = xpos;
		newbomb.ypos = ypos - 0;
		
		pow = 7 + power(sqrt(xdif*xdif + ydif*ydif),0.64)/2.6;
		
		newbomb.vy = (sin(ang) * pow - 1) * 1.3;
		newbomb.vx = cos(ang) * pow * 1.1;	
		
		if(ground < 1 && newbomb.vy > 0) fy -= newbomb.vy/3;
		fx -= newbomb.vx/22;
						
		newbomb.bt = 0;	
		
		ammo--;
		
		shot_t = 0;
		shot_d = 8;
		shot_d_s = 4;
		mouse_hold = 0;
		
		charged = false;
}

function bomb2() { //sticky
		newbomb = instance_create_layer(0, 0, "game_layer", obj_bomb);
		newbomb.xpos = xpos;
		newbomb.ypos = ypos - 0;
		
		pow = 7 + power(power(xdif*xdif + ydif*ydif,0.5),0.5)/2;
		
		newbomb.vy = sin(ang) * pow - 3;
		newbomb.vx = cos(ang) * pow * 1.1;	
		
		if(ground < 1 && newbomb.vy > 0) fy -= newbomb.vy/3;
		fx -= newbomb.vx/22;
		
		newbomb.bt = 1;	
		
		ammo--;
		
		shot_t = 1;
		shot_d = 6;
		shot_d_s = 4;
		mouse_hold = 0;
		
		charged = false;
}

function bomb3() { //strong boost
		newbomb = instance_create_layer(0, 0, "game_layer", obj_bomb);
		trackbomb = newbomb;
		newbomb.xpos = xpos;
		newbomb.ypos = ypos + 10;
		
		newbomb.vy = 5;
		newbomb.vx = 0;
		
		newbomb.bt = 2;	
}

function bomb4() { //weak boost
		newbomb = instance_create_layer(0, 0, "game_layer", obj_bomb);
		trackbomb = newbomb;
		newbomb.xpos = xpos;
		newbomb.ypos = ypos + 10;
		
		newbomb.vy = 5;
		newbomb.vx = 0;
		
		newbomb.bt = 3;	
}

function bomb5() {
		newbomb = instance_create_layer(0, 0, "game_layer", obj_bomb);
		newbomb.xpos = xpos;
		newbomb.ypos = ypos - 10;
		
		pow = 31;
		
		newbomb.vy = sin(ang) * pow;
		newbomb.vx = cos(ang) * pow;	
		
		newbomb.bt = 4;	
		
		ammo = 0;
		reload = 30;
		
		shot_d = 10;
		mouse_hold = 0;
		
		charged = false;
}