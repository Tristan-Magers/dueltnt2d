if (global.state != 1) instance_destroy();

phy_obj(4,19);

//players manager
var newplay = {
	alive : true,
	mx : xpos,
	my : ypos,
}

if (dead) newplay.alive = false;

ds_list_replace(global.players,myid,newplay);

if(dead) {
	instance_destroy();	
	instance_create_layer(0, 0, "game_layer", obj_dummy);
	global.sc ++;
}