shader_type canvas_item;

//Light colour = 160,160,255
//Dark colour = 30,30,97

void fragment() { //
	float R = 0.95; //Stands for reduction
	COLOR = texture(TEXTURE, UV);
	float alpha = COLOR.a;
	float outer_X[] = {2.5/180.0, 1.f - (2.5/180.0)};
	float inner_X[] = {5.0/180.0, 1.f - (5.0/180.0)};
	float outer_Y[] = {2.5/106.0, 1.f - (2.5/106.0)};
	float inner_Y[] = {5.0/106.0, 1.f - (5.0/106.0)};
	vec4 darker = COLOR * R;
	vec4 darkest = COLOR * (2.f*R - 1.f);
	darker.a = alpha;
	//Boxes stretch between outer and inner in the short ways, and outer in the long ways
	//Top:    outer_X < UV.x < (1.f-outer_X) && outer < UV.y < inner
	//Bottom: outer_X < UV.x < (1.f-outer_X) && (1.f-outer) > UV.y > (1.f - inner)
	//Left:   outer_Y < UV.y < (1.f-outer_Y) &&
	//Right:  outer_Y < UV.y < (1.f-outer_Y) && 
	
	if (outer_X[0] < UV.x && UV.x < outer_X[1]) { //Top bar
		if (outer_Y[0] < UV.y && UV.y < inner_Y[0]) COLOR = darker;
	}
	if (outer_X[0] < UV.x && UV.x < outer_X[1]) { //Bottom bar
		if (outer_Y[1] > UV.y && UV.y > inner_Y[1]) COLOR = darker;
	}
	if (outer_Y[0] < UV.y && UV.y < outer_Y[1]) { //Left bar
		if (outer_X[0] < UV.x && UV.x < inner_X[0]) COLOR = darker;
	}
	if (outer_Y[0] < UV.y && UV.y < outer_Y[1]) { //Right bar
		if (outer_X[1] > UV.x && UV.x > inner_X[1]) COLOR = darker;
	}
	if (UV.x < outer_X[0] || UV.x > outer_X[1] || UV.y < outer_Y[0] || UV.y > outer_Y[1]) COLOR = darkest;

}