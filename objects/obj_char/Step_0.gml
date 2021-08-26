if (global.state != 1) instance_destroy();

//player manager
if (!dummy) {
	player();

	if(global.is_server) {
		global.xp = xpos;
		global.yp = ypos;
	}

	if(global.has_server) {
		buffer_seek(con_manager.client_buffer,buffer_seek_start,0);
		buffer_write(con_manager.client_buffer,buffer_u8,network.move);
		network_send_packet(con_manager.client,con_manager.client_buffer,buffer_tell(con_manager.client_buffer));
	
		xpos = global.xp;
		ypos = global.yp;
	}

	room_adjust();
}

//dummy
if (dummy) {
	if (global.state != 1) instance_destroy();

	phy_obj(4,19);

	if(dead) {
		instance_destroy();	
		instance_create_layer(0, 0, "game_layer", obj_dummy);
		global.sc ++;
	}	
}