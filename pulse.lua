-- http://www.iquilezles.org/apps/shadertoy
-- Pulse glsl shader preset.
-- by Iñigo Quilez
-- adapted to Love by Ref

fx = {}

fx.pulse = love.graphics.newPixelEffect[[

	extern number time		= 0.0;
	extern vec2 resolution	= vec2(1280,800);
	uniform sampler2D tex0;
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
	{
	    vec2 halfres	= resolution/2.0;
	    vec2 cPos		= pixel_coords.xy;
	    //cPos.x 			-= 0.5*halfres.x*sin(time/2.0)+0.3*halfres.x*cos(time)+halfres.x;
	    //cPos.y 			-= 0.4*halfres.y*sin(time/5.0)+0.3*halfres.y*cos(time)+halfres.y;
	    cPos.x 			-= halfres.x * .25;//(time * 50);
	    cPos.y 			-= halfres.y * .5;
	    float cLength	= length(cPos) / .5;
		vec2 uv			= pixel_coords/resolution-(cPos/cLength)*cos(cLength/200.0-time*5.0)/25.0;
	    vec3 col		= texture2D(tex0,uv).xyz*500.0/cLength;
	 
	 	return vec4( col, 1.0 );
	}

]]

fx.magnify = love.graphics.newPixelEffect [[

    extern Image map;
    extern number fac = 1.0;
    extern number mousex = 1.0;
    extern number mousey = 1.0;
    uniform sampler2D tex0;
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
    {
        vec2 uv2         = vec2(
                texture_coords.x,
                1 - texture_coords.y
        );
        vec4 mapcol = Texel(map, uv2);
        vec2 uv         = vec2(
                texture_coords.x - (.5 - mapcol.r)/(2/fac)*ceil(mapcol.g), // - mapcol.b/(16/fac),
                texture_coords.y - (.5 - mapcol.g)/(2/fac)*ceil(mapcol.g)  // - mapcol.b/(16/fac)
        );

        vec3 col = vec3(
                texture2D(tex0,uv).x,
                texture2D(tex0,uv).y,
                texture2D(tex0,uv).z
        );
        col += (1 - clamp(sqrt(pow(texture_coords.x*4 - mousex*4 - .5, 2) + pow(texture_coords.y*4 - mousey*4 + .5, 2)), 0, 1) - .2)*ceil(mapcol.g)*fac;
     
     	return vec4(col, 1);
    }

]]
