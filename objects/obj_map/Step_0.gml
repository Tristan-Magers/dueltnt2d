if (global.state == 0) {
	if keyboard_check_pressed(ord("S")) {
		gamestart();
		global.state = 1;
	}
}

if (global.state == 1) {
	global.map = map;

	//objects
	booms();
	manmap();

	global.timer--;	
	if(global.timer < 1) global.state = 2;
	
	active = true;
}

if (global.state == 2) {
	if(global.sc > global.hsc) global.hsc = global.sc;
	global.state = 0;
}