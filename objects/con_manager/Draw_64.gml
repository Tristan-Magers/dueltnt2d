if(network_on >= 0 && network_on <= 1) draw_text(40, 40, "Space to start network");
if(network_on >= 2 && is_server) {
	m_message = "Connect IP: " + string(locip) + ":" + string(port);
	draw_text(10, 10, m_message);
}
if(network_on == 2 && !is_server) {
	m_message = "Connecting...";
	draw_text(10, 10, m_message);
}
if(network_on == 3 && !is_server) {
	m_message = "Connected!";
	draw_text(10, 10, m_message);
}

//if(!is_server) draw_text(10, 40, global.has_server);
if(is_server && network_on == 3) draw_text(10, 40, ds_list_size(socket_list));