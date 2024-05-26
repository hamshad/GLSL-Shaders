#ifdef GL_ES
precision mediump float;
#endif

// uniform means 0-1 (i guess)
uniform vec2 u_resolution; // Canvas Size (width(x), height(y))
uniform vec2 u_mouse; // Mouse position
uniform float u_time; //Time in seconds since load

void main () {
    
    //sin is going 0 - 1 then ends at 0
    //cos is going 1 - 0 then ends at 0
    //tan is going 0 - 1 then ends at 1
    //log goes 1 - 0 - 1 and stops
    //aps returns absolute value of x
    // gl_FragColor = vec4(abs(sin(u_time)), abs(cos(u_time)), 0.0, 1.0);

    // gl_FragCoord is different thread to thread so its called vary and can't be called uniform
    // vec2 a = vec2(gl_FragCoord.x * .9999, gl_FragCoord.y * .9999);
    // vec2 st = a/u_time;
    // vec2 st = gl_FragCoord.xy/u_resolution;
    // gl_FragColor = vec4(sin(st.xy), abs(sin(u_time)), 1.0);

    // code-golfing
    gl_FragColor = vec4(gl_FragCoord.xy/u_resolution, .5, 1.);
}