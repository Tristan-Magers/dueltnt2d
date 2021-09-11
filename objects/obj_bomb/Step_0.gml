if (global.state != 1) instance_destroy();

if (!tset) {
	bombtype();
}
else {
	if (bt == 0) {
		bounce -= 0.00225;
		if (bounce < 0.04) bounce = 0.04;
	}
}

counter++;
if(counter > 600) 
{
	makeboom(0, xpos, ypos)
	instance_destroy();
}

if(counter2 < 1 && (checkfloor || checkceil || checkwall || !trigger)) {
	fric_ground = 8;
	if (bt == 0) bounce -= 0.012;
	counter2 = 1;
}

if(counter2 > 0) counter2++;
if(counter2 == fuse && trigger >= 1) 
{
	makeboom(bt, xpos, ypos);
}
if(counter2 >= fuse && trigger <= 0) 
{
	makeboom(bt, xpos, ypos);
	instance_destroy();
}

if(trigger > 0 && (checkfloor || checkceil || checkwall)) {
	if(!hitting) trigger--;
	if(trigger == 0 && trig_switch_type != -1 && counter2 >= fuse) bt = trig_switch_type;
	hitting = true;
}
else {
	hitting = false;	
}

if(!mgravity) g = 0;

phy_obj(5,60);

testx = xpos;
testy = ypos;