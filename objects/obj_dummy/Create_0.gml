self.image_xscale = 0
self.image_yscale = 0

//map knowledge
gettileinfo();
getmap();

//character
physvar();

randomize();

getmap();
gettileinfo();

x_w = ds_grid_width(map);

found_tile = false;
for(var i=0;i<100;i++) {
	xtest = random_range(0,x_w-1);
	for(var t=0;t<ds_grid_height(map);t++) {
		t_tile = ds_grid_get(map,xtest,t);
		if (t_tile != -99) {
			if (t_tile.h > 0) {
				i = 1000;
				found_tile = true;
			}
		}
	}
}

if(found_tile) xpos = xtest;

xpos = xa + (tile_size * xpos) - tile_size/2 + random_range(-tile_size/3,tile_size/3);

prev_x = xpos;
prev_y = ypos;

size_x = 38;
size_y = 58;

bounce = 0.2;
blastbounce = true;

bounce_s_y = 2;

floora = 700;

djump = 0;
ang = 0;

char_spr = 3;

var sel = irandom(14);
if(sel = 6) char_spr = 4;
if(sel = 7) char_spr = 5;
if(sel = 8) char_spr = 6;
if(sel = 9) char_spr = 7;

myid = ds_list_size(global.players);

var newplay = {
	alive : true,
	mx : xpos,
	my : ypos,
}

ds_list_add(global.players,newplay);