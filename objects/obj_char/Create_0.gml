self.image_xscale = 0
self.image_yscale = 0

//map knowledge
gettileinfo();
getmap();

//character
physvar();

test = "none";
test2 = "none";
test3 = "none";

goal_x = 0;
goal_y = 0;

target_x = 0;
target_y = 0;

dummy = false;
ai = false;

xpos= room_width/2;

prev_x = xpos;
prev_y = ypos;

size_x = 38;
size_y = 58;

bounce = 0.2;
blastbounce = true;

bounce_s_y = 2;

floora = 700;

res = 1;

jump_hold = 0;
djump = 0;
ang = 0;

space_timer = 0;

ammo = 2;
reload = 0;
charge = 0;
charge_max = 22;
charging = false;
charged = false;
trackbomb = undefined;

track_vy = 0;

shift = 0;

can_attack = false;
attacking = false;
attack = -1;
attack_time = -1;

angry = 0;

shot_t = 0;
shot_d = 0;
shot_d_s = 0;

mouse_hold = 0;

room_scale = 1.1;

up = 0;
down = 0;
left = 0;
right = 0;
space = 0;
shift = 0;
rmouse = 0;
lmouse = 0;

myid = ds_list_size(global.players);

var newplay = {
	alive : true,
	mx : xpos,
	my : ypos,
}

ds_list_add(global.players,newplay);