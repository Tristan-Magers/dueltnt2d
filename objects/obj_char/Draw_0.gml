flip = 1;
if(ang > pi/2 || ang < -pi/2) flip = -1;

player_ang = 0
if (attacking && attack_time > 3) {
	if(attack_time > 0 && attack_time < 8 && !charging && space == 0) player_ang = (attack_time-1)/5 * 180 * -flip;
	else player_ang = 180;
}

//y-stretch
ystr = 1 - (vy/60);

//draw player
draw_sprite_ext(spr_char, 0, xpos, ypos, flip, ystr, player_ang, c_white, 1);
if(!can_attack && !attacking) draw_sprite_ext(spr_char, 8, xpos, ypos, flip, ystr, player_ang, c_white, 1);
if(blasted > 0) draw_sprite_ext(spr_char, 2, xpos, ypos, flip, ystr, player_ang, c_white, 1);
if(angry > 0 && space_timer < 1) draw_sprite_ext(spr_char, 1, xpos, ypos, flip, ystr, player_ang, c_white, 1);
if(charging) draw_sprite_ext(spr_char, 9, xpos, ypos, flip, ystr, player_ang, c_white, 1);

gun_flip = 1.2 * flip;

//draw charge
if(charging) draw_rectangle(xpos-20,ypos-size_y/2 - 10,xpos -20 + charge * (40 / charge_max),ypos-size_y/2 - 25,false);

//draw gun
if(!attacking) {
	if(shot_d == 0){
		if(ammo == 2) draw_sprite_ext(spr_gun, 0, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);
		if(ammo == 1) draw_sprite_ext(spr_gun, 1, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);
		if(ammo == 0) draw_sprite_ext(spr_gun, 2, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);	
		if(charged) draw_sprite_ext(spr_gun, 4, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);	
	}
	else draw_sprite_ext(spr_gun, 3, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);
}

check_land();