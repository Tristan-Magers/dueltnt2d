// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function physvar(){
	ground = 0;
	
	size_x = 0;
	size_y = 0;

	xpos = 0;
	ypos = 0;

	prev_x = 0;
	prev_y = 0;
	
	vx = 0;
	vy = 0;
	fx = 0;
	fy = 0;
	
	w = 1;
	
	fric_ground = 10;
	fric_air = 20;
	
	floora = 1000000;
	onfloor = 0;
	checkfloor = 0;
	checkceil = 0;
	checkwall = 0;
	
	ledge = 0;
	
	boosted = 0;
	blasted = 0;
	blastbounce = false;
	
	sticky = false;
	stick = false;
	
	bouncy = false;
	bounce = 0.6;
	
	bounce_s_x = 1;
	bounce_s_y = 1;
	
	mgravity = true;
	g = 0.8;
	
	res = 0;
	
	dead = false;
}

function phy_obj(g_f,a_f){ //general physics sequence, based on friction
	boomblast();
	force();
	myfriction(g_f,a_f);
	myphysics();	
}

function sim_phy_obj(){ //for basic temporary entities
	myphysics();	
}

function myphysics(){ // where physics happens lol
	if (vx > 31) vx = 31;
	if (vx < -31) vx = -31;
	
	if (vy > 31) vy = 31;
	if (vy < -31) vy = -31;

	if(stick) {
		vx = 0;
		vy = 0;
	}

	prev_x = xpos;
	prev_y = ypos;
	
	ypos += vy;
	xpos += vx;

	myfloor = 0;
	myceil = 0;
	mywall = 0;
	checkfloor = 0;
	checkceil = 0;
	checkwall = 0;
	
	if(blastbounce) {
		if(blasted > 1) bouncy = true;
		else bouncy = false;	
	}
	
	getmap();
	
	for(i=ds_grid_height(map) - 1;i>=0;i--){
		for(t=0;t < ds_grid_width(map);t++){
			if (touchblock(size_x, size_y, t, i)) {
				hitblock(size_x, size_y, t, i);
				hitb = {
					xpos : 0,
					ypos : 0
				}
				hitb.ypos = i;
				hitb.xpos = t;
			}
		}
	}

	if(ypos>floora) {
		myfloor = floora;
		checkfloor = true;
		dead = true;
	}

	onfloor = checkfloor;	
	
	if(checkwall > 0) {
		if(sticky) stick = true;
		
		if(checkwall > 1) {
			if(onfloor = 1) onfloor = 0;
		
			if(!bouncy || abs(vx) < 4) {
				vx *= 0.6;
				if(ground > 0) vx = 0;
			}
			else vx *= -bounce * bounce_s_x;		
		}
		else {
			if(!bouncy || abs(vx) < 4) {
				vx *= 0.92;
				if(ground > 0) vx = 0;
			}
			else vx *= -bounce * bounce_s_x;	
		}
	}
	
	if(mgravity) vy += g;
	
	if(onfloor > 0) {
		ypos = myfloor;
		
		if(sticky) stick = true;
		
		vy -= g;
		
		if (onfloor > 1 || ledge > 1) {
			if(!bouncy || abs(vy) < 4) vy *= 0.5;
			else vy *= -bounce * bounce_s_y;
			
			djump = 1;
			ground = 5;	
		}
		else {
			if(!bouncy || abs(vy) < 4) vy *= 0.8;
			else vy *= -bounce * bounce_s_y;
			
			ledge++;
		}
	}
	else {
		ground--;
		ledge = 0;
	}
	
	if(checkceil > 0) {
		if(sticky) stick = true;
		
		if(checkwall > 1) {
			if(!bouncy || abs(vy) < 4) vy *= 0.1;
			else vy *= -bounce * bounce_s_y;			
		}
		else {
			if(!bouncy || abs(vy) < 4) vy *= 0.85;
			else vy *= -bounce * bounce_s_y;	
		}
	}	
	
	if(boosted > 0 && ground > 0) boosted--;
	if(blasted > 0) blasted--;
}

function myfriction(ph,air) {
	fric_air = air;
	fric_ground = ph;
	ph = 1 - (1/ph)
	air = 1 - (1/air)
	if(ground > 1 && boosted < 1) vx *= ph;
	else vx *= air;	
}

function force() { // change velocity based on force
	
	fx /= w;
	fy /= w;
	
	//x-axis force
    if(fx< 0) fx = -(fx*fx);
	else fx = (fx*fx);
	if(vx< 0) var newx = -(vx*vx) + fx;
	else var newx = (vx*vx) + fx;
	if(newx < 0) vx = -1 * power(abs(newx),0.5);
	else vx = power(abs(newx),0.5)	
	
	//y-axis force
    if(fy< 0) fy = -(fy*fy);
	else fy = (fy*fy);
	if(vy< 0) var newy = -(vy*vy) + fy;
	else var newy = (vy*vy) + fy;
	if(newy < 0) vy = -1 * power(abs(newy),0.5);
	else vy = power(abs(newy),0.5)	
	
	fx = 0;
	fy = 0;
}

function boomblast(){ //chek explosions and applky interactions to self
	
	for(i=0;i<ds_list_size(global.booms);i++){
		tboom = ds_list_find_value(global.booms, i);
		if (tboom.res != res) {
			var dist_x = abs(tboom.xpos - xpos);
			var dist = sqrt(power(tboom.xpos - xpos, 2) + power(tboom.ypos - ypos, 2));
			var rang = dist - 16;
			rang -= tboom.r * 0.25;
			if (rang < 0) rang = 0;
			if(rang < tboom.rm && tboom.counter == 1) {
				xdif = tboom.xpos - xpos;
				ydif = tboom.ypos - ypos + 10;
		
				pow = tboom.knock * power((1 - (rang + 0.01)/tboom.r),0.4);
				ang = arctan2(ydif, xdif);	
			
				fy -= sin(ang) * pow;
				if(dist_x > 1) fx -= cos(ang) * pow;
			
				boosted = 12;
				if(tboom.blaster) blasted = 18;
				ground = -1;
			}	
		}
	}
}