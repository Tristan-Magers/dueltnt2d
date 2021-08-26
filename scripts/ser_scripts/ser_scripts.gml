enum network{
	move,
	update
}

function received_packet_cli(buffer){
	nsgid = buffer_read(buffer, buffer_u8);

	switch (nsgid) {		
		case network.move :
			var mes = buffer_read(buffer, buffer_string);
			show_message(mes);
			
			break;
		case network.update :
			global.xp = buffer_read(buffer, buffer_s16);
			global.yp = buffer_read(buffer, buffer_s16);
			
			break;
	}
}

function received_packet_ser(buffer, socket){
	nsgid = buffer_read(buffer, buffer_u8);

	switch (nsgid) {		
		case network.move :		
			
			break;
	}
}

function server_net() {
	type_event = ds_map_find_value(async_load,"type");

	switch (type_event)
	{
		case network_type_connect :
			socket = ds_map_find_value(async_load,"socket");
			def_sock = socket;
			ds_list_add(socket_list, socket);
			break;
		
		case network_type_disconnect :
			socket = ds_map_find_value(async_load,"socket");
			ds_list_delete(socket_list, ds_list_find_index(socket_list, socket));
			break;
		
		case network_type_data :
			buffer = ds_map_find_value(async_load,"buffer");
			socket = ds_map_find_value(async_load,"id");
			buffer_seek(buffer, buffer_seek_start, 0);
			received_packet_ser(buffer, socket);
			break;
	}	
}

function client_net() {
	type_event = ds_map_find_value(async_load,"type");

	switch(type_event) {
		case network_type_data :
			buffer = ds_map_find_value(async_load,"buffer");
			buffer_seek(buffer, buffer_seek_start, 0);
			received_packet_cli(buffer);
			break;
	}
}

function server_send_all() {
	/*
	for(i=0;i<ds_list_size(id_list);i++){	
	}	
	*/
	
	if (ds_list_size(socket_list) > 0) {
		buffer_seek(con_manager.server_buffer,buffer_seek_start,0);
		buffer_write(con_manager.server_buffer,buffer_u8,network.update);
		buffer_write(con_manager.server_buffer,buffer_s16,global.xp);
		buffer_write(con_manager.server_buffer,buffer_s16,global.yp);
		network_send_packet(def_sock,con_manager.server_buffer,buffer_tell(con_manager.server_buffer));
	}	
}
