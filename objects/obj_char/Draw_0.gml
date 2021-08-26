flip = 1;
if(ang > pi/2 || ang < -pi/2) flip = -1;

player_ang = 0
if (attacking) {
	if(attack_time < 8) player_ang = attack_time/8 * 180 * -flip;
	else player_ang = 180;
}

//y-stretch
ystr = 1 - (vy/60);

//draw player
draw_sprite_ext(spr_char, 0, xpos, ypos, flip, ystr, player_ang, c_white, 1);
if(blasted > 0) draw_sprite_ext(spr_char, 2, xpos, ypos, flip, ystr, player_ang, c_white, 1);
if(angry > 0) draw_sprite_ext(spr_char, 1, xpos, ypos, flip, ystr, player_ang, c_white, 1);

gun_flip = 1.2 * flip;

//draw gun
if(!attacking) {
	if(shot_d == 0){
		if(ammo == 2) draw_sprite_ext(spr_gun, 0, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);
		if(ammo == 1) draw_sprite_ext(spr_gun, 1, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);
		if(ammo == 0) draw_sprite_ext(spr_gun, 2, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);	
	}
	else draw_sprite_ext(spr_gun, 3, xpos, ypos - 10, 1.2, gun_flip, -ang*180/pi, c_white, 1);
}

check_land();