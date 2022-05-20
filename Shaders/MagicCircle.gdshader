shader_type canvas_item;
render_mode unshaded;

uniform vec4 default_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment()
{
	vec4 pixel_color = texture(TEXTURE, UV);
//	//COLOR = default_color;
//    if (pixel_color.a > 0.2) 
//	{
//    	pixel_color = pixel_color;
//	} else {
//		pixel_color.a = 0.0;
//		//pixel_color = default_color
//	}
	COLOR = pixel_color;
}


//https://godotshaders.com/shader/smooth-outline-2d/
//render_mode unshaded;
//
//uniform bool Smooth = true;
//uniform float width : hint_range(0.0, 64) = 1.0;
//uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
//uniform int pixel_size : hint_range(1, 10) = 4;
////uniform float width_speed :hint_range(0.1, 10) = 1;
//
//void fragment()
//{
//	vec4 pixel_color = texture(TEXTURE, UV);
//	//COLOR = default_color;
//    if (pixel_color.a > 0.2) 
//	{
//    	pixel_color = pixel_color;
//	} else {
//		pixel_color.a = 0.0;
//
//	}
//	COLOR = pixel_color;
//
//
//    float _width = width;// + ((sin(TIME*width_speed) + 1f) -2f) * 10f;
//    vec2 unit = (1.0/float(pixel_size) ) / vec2(textureSize(TEXTURE, 0));
//    //vec4 pixel_color = texture(TEXTURE, UV);
//    if (pixel_color.a == 0.0) {
//        pixel_color = outline_color;
//        pixel_color.a = 0.0;
//        for (float x = -ceil(_width); x <= ceil(_width); x++) {
//            for (float y = -ceil(_width); y <= ceil(_width); y++) {
//                if (texture(TEXTURE, UV + vec2(x, y)).a == 0.0 || (x==0.0 && y==0.0)) {
//                    continue;
//                }
//                if (Smooth) {
//                    pixel_color.a += outline_color.a / (pow(x,2)+pow(y,2)) * (1.0-pow(2.0, -_width));
//                    if (pixel_color.a > 1.0) {
//                        pixel_color.a = 1.0;
//                    }
//                } else {
//                    pixel_color.a = outline_color.a;
//                    return
//                }
//            }
//        }
//    }
//    COLOR = pixel_color;
//}
