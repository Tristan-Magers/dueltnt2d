if (keyboard_check_pressed(vk_space)) {
	buffer_seek(con_client.client_buffer,buffer_seek_start,0);
	buffer_write(con_client.client_buffer,buffer_u8,1);
	buffer_write(con_client.client_buffer,buffer_string,"Hello World");
	network_send_packet(con_client.client,con_client.client_buffer,buffer_tell(con_client.client_buffer));
	times = time;
}

if (image_index != myindex) {
	myindex = image_index;
	timedif = time - times;
}

time++;