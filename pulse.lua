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
    cPos.x -= halfres.x * .25;//(time * 50);
    cPos.y -= halfres.y * .5;
    float cLength	= length(cPos) / .5;
	vec2 uv			= pixel_coords/resolution-(cPos/cLength)*cos(cLength/200.0-time*5.0)/25.0;
    vec3 col		= texture2D(tex0,uv).xyz*500.0/cLength;
 return vec4( col, 1.0 );
}


]]

