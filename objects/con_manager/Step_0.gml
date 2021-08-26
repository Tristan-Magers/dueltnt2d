//manage state
if (network_on == 3) {
	if(is_server) server_send();
	else client_send();
}

//start game
if (network_on == 2) {
	network_on = 3
	map_inst = instance_create_layer(0, 0, "game_layer", obj_map);
	if(is_server) start_server();
	else start_client();
}

//choose startup
if (keyboard_check_pressed(vk_space) && network_on == 0) {
	start_net();
}
if (keyboard_check_pressed(vk_shift) && network_on == 0) {
	network_on = 2;
}

//functions
function start_net(){
	network_on = 1;
	is_server = true;
	global.is_server = true;
	
	//randomize();
	//port = irandom_range(49152,65535);
	port = 65656
	host = network_create_server(network_socket_udp, port, 5);

	if (host < 0)
	{
	    show_message("Failed to create a broadcast server");
	    game_end();
	}
	else
	{
	    var sock = network_create_socket(network_socket_udp);
	    var buff = buffer_create(32, buffer_fixed, 1);
    
	    buffer_fill(buff, 0, buffer_bool, 0, 32);
	    network_send_broadcast(sock, port, buff, buffer_get_size(buff));
    
	    network_destroy(sock);
	    buffer_delete(buff);
	}
}

function start_server() {
	server_buffer = buffer_create(1024,buffer_fixed,1);
	socket_list = ds_list_create();
	
	port = 63212
	max_clients = 6;

	host = network_create_server(network_socket_tcp,port,max_clients);
}

function start_client(){
	client = network_create_socket(network_socket_tcp);
	connected = network_connect(client,"127.0.0.1",63212);

	global.has_server = true;

	client_buffer = buffer_create(1024,buffer_fixed,1);
}

function client_send(){

}

function server_send(){			
	server_send_all();
}