#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 palette( float t ) {

    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(2.0, 1.0, 0.0);
    vec3 d = vec3(0.50, 0.20, 0.25);

    return a + b*cos( 6.28318*(c*t+d) );
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void main() {

    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    vec2 uv1 = uv;
    vec2 uv2 = uv;
    float d2 = length(uv2);
    d2 = sin(d2*12. + u_time) / smoothstep(-.2, .0, u_time);
    d2 = abs(d2);
    uv1 = fract(uv1 * 2.) - 0.5;
    float d1 = sdBox(uv1 * d2, vec2(0.5, 0.5) + -abs(max(1.6, sin(u_time)*1.6))) * exp(-length(uv1));
    d1 = sin(d1 * 12. + u_time/.2) / 12.;
    d1 = abs(d1);
    d1 = .02 / d1 ;
    vec3 col2 = vec3(d2);
    vec3 col1 = palette(d1 + u_time);
    col1 -= col2;
    

    // vec2 uv0 = (gl_FragCoord.xy * 2. / sin(min(0.2, u_time)) - u_resolution) / u_resolution.y;

    vec2 uv0 = uv / sin(min(0.2, u_time));
    uv0 = abs(uv);

    vec3 col;

    uv = fract(uv * min(4.0 ,smoothstep(-1.6, 0.8, sin(u_time)/1.4))) - .5;
    
    vec3 color = palette(length(uv0) + u_time);

    col = color;

    // uv = fract(uv) - 0.5;

    float d = length(uv) / exp(-length(uv0));

    d = sin(d * 8. + u_time/.4) / 8.;
    d = abs(d);
    // d = smoothstep(0., .2, d);
     d = 0.03 / d;

     col *= d;

    col += col1;

    gl_FragColor = vec4(col1, 1.0);
}