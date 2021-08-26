//find local IP
if(network_on <= 1) {
	network_on = 2;
	locip = ds_map_find_value(async_load, "ip")
}

//running an established connection
if(network_on == 3) {
	if(is_server) {
		server_net();
	}
	else {
		client_net();
	}
}