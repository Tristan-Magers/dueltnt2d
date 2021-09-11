var r_mx = mouse_x - camera_get_view_x(view_camera[0]);
var r_my = mouse_y - camera_get_view_y(view_camera[0]);

var g_mx = goal_x - camera_get_view_x(view_camera[0]);
var g_my = goal_y - camera_get_view_y(view_camera[0]);

var t_mx = target_x - camera_get_view_x(view_camera[0]);
var t_my = target_y - camera_get_view_y(view_camera[0]);

draw_sprite_ext(spr_cross, 0, r_mx * room_scale, r_my * room_scale, 1, 1, 0, c_white, 0.8);

//draw_text(8,8,goal_x);
//draw_text(8,20,temper);

if(ai) draw_sprite_ext(spr_cross, 0, g_mx * room_scale, g_my * room_scale, 1, 1, 0, c_black, 0.8);
if(ai) draw_sprite_ext(spr_cross, 0, t_mx * room_scale, t_my * room_scale, 1, 1, 0, c_yellow, 0.8);
if(ai) draw_text(8,8,test);
if(ai) draw_text(8,26,test2);
if(ai) draw_text(8,40,test3);
//draw_text(8,8,can_attack);
//draw_text(8,24,camera_get_view_x(view_camera[0]));
//draw_text(8,50,mouse_x - camera_get_view_x(view_camera[0]));