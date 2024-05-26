#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

vec3 palette( float t ) {

    //[[0.500 0.500 0.500] [0.528 0.248 0.500] [1.000 0.168 1.000] [0.000 0.333 0.667]]

    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.528, 0.248, 0.5);
    vec3 c = vec3(1.0, 0.168, 1.0);
    vec3 d = vec3(0.0, 0.333, 0.667);

    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
    
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution) / u_resolution.y;

    vec2 uv0 = uv;

    vec3 col = vec3(0.0);

    for(float i = 0.0; i < 0.4; i++) {

        uv0 = fract(uv0 * 1.0) - 0.5;

        float absT = abs(u_time);
        
        float absT0 = 1.6*smoothstep(-1. ,.8,sin(absT + i));

        float d = length(sdBox(uv0, vec2( 0.2, 0.2)) + i + absT0) / 4. - cos(absT * 0.2) * exp(-length(uv));

        vec3 color = palette(length(uv) + u_time);
        
        d = sin(d*8. / 0.2) / 12.0;
        d = abs(d);
        d = smoothstep(0.0, 0.3, d);
        
        d = sqrt(pow(0.1 / d, 1.8));

        col += color * d;
    }

    col /= vec3(abs(sin(u_time)));
    
    gl_FragColor = vec4(col, 1.0);
}