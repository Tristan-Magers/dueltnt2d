//
window_set_cursor(cr_none);

// -1 for offline, 0 for online
network_on = -1;

//
is_server = false;
global.is_server = false;
global.has_server = false;

def_sock = 0;

var locip;
var port;
var host;
var socket;

global.xp = 1000;
global.yp = 300;
connected = -1;

if(network_on == -1) map_inst = instance_create_layer(0, 0, "game_layer", obj_map);