precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 palette ( float a );

void main() {
    // vec2 uv =  gl_FragCoord.xy / u_resolution * 2.0 - 1.0;
    // uv.x *= u_resolution.x / u_resolution.y;

    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution) / u_resolution.y;

    vec2 uv0 = uv;

    vec3 finalColor = vec3(0.0);

    // uv *= 2.0;
    // uv = fract(uv);
    // uv -= 0.5;

    for(float i = 0.0; i < 4.0; i++) {
        
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        // vec3 col = vec3(1.0, 2.0, 3.0);
        // vec3 col = palette(d + u_time);
        vec3 col = palette(length(uv0) + u_time);

        // d -= 0.5;
        d = sin(d * 8. + i + u_time ) / 8.;
        d = abs(d);

        //step() takes a threshold and a value where the value is > thres than returns 1 otherwise 0
        // d = step(0.02, d);

        //smoothStep() takes two values and eases out the inbetween the thresholds value
        // d = smoothstep(0.0, 0.1, d);

        // d = 0.01 / d;
        d = pow(0.01 / d, 1.2);

        finalColor += col * d;
    
    }

    gl_FragColor = vec4(finalColor, 1.0);
}

vec3 palette( float t ) {

    //[[0.500 0.500 0.500] [0.528 0.248 0.500] [1.000 0.168 1.000] [0.000 0.333 0.667]]

    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.528, 0.248, 0.5);
    vec3 c = vec3(1.0, 0.168, 1.0);
    vec3 d = vec3(0.0, 0.333, 0.667);

    return a + b*cos( 6.28318*(c*t+d) );
}