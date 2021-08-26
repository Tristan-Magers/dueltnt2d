function shard(scount, x_p, y_p, r_s){
	for(s_c=0;s_c<scount;s_c++){
		makeshard(x_p, y_p, r_s);
	}
}

function makeshard(x_p, y_p, r_s) {
	newshard = instance_create_layer(0, 0, "game_layer", obj_shard);
	newshard.xpos = x_p + random_range(-r_s,r_s);
	newshard.ypos = y_p + random_range(-r_s,r_s);	
}