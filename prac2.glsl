#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float sdGuy(vec3 p) {

    float t = fract(u_time);
    float y = 4.0*t*(1.0-t);
    vec3 cen = vec3(0.0, y, 0.0);
    return length(p-cen) - 0.25;
}

float sceneSDF(vec3 p) {

    float d = sdGuy(p);
    float s = p.y - (-0.25);

    float q = min(d, s);
    return q;
}

float raymarch(vec3 ro, vec3 rd) {
    float depth = 0.0;
    for(int i = 0; i < 100; i++) {
        float dist = sceneSDF(ro + depth * rd);
        if (dist < .001) break;
        depth += dist;
        if (dist > 20.) break;
    }
    if (depth > 20.0) depth = -1.0;
    return depth;
}

vec3 calcNormal (vec3 p) {
    vec2 e = vec2(0.001, 0.0);
    return normalize(vec3(
        sceneSDF(p + e.xyy) - sceneSDF(p - e.xyy),
        sceneSDF(p + e.yxy) - sceneSDF(p - e.yxy),
        sceneSDF(p + e.yyx) - sceneSDF(p - e.yyx)
    ));
}

void main() {

    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    //camera rotation
    float an = 10.0*u_mouse.x/u_resolution.x;//0.6*u_time;

    vec3 ta = vec3(0.0, .5, 0.0);
    // vec3 ro = ta + vec3(1.5*sin(an), 0.0, 1.5*cos(an));
    vec3 ro = ta + vec3(1.5, 0.0, 1.5);


    vec3 ww = normalize(ta-ro);
    vec3 uu = normalize(cross(ww, vec3(0,1,0)));
    vec3 vv = normalize(cross(uu, ww));

    vec3 rd = normalize(uv.x*uu + uv.y*vv + 1.8*ww);

    vec3 col = vec3(0.04, 0.75, 1.0) - 0.5 * rd.y;
    col = mix(col, vec3(0.7, 0.75, 0.8), exp(-10.0*rd.y));

    float d = raymarch(ro, rd);

    if (d > 0.0) {
        vec3 pos = ro + d * rd;
        vec3 p = calcNormal(pos);

        //dif light is the strongest light
        vec3 mate = vec3(0.18);

        vec3 sun_dir = normalize(vec3(0.8, 0.4, 0.2));
        float sun_dif = clamp(dot(p, sun_dir), 0.0, 1.0);
        float sun_ray = step(raymarch(pos+p*0.001, sun_dir), 0.0);
        float sky_dif = clamp(0.5 + 0.5 * dot(p, vec3(0.0, 1.0, 0.0)), 0.0, 1.0);
        float sky_bounce = clamp(0.5 + 0.5 * dot(p, vec3(0.0, -1.0, 0.0)), 0.0, 1.0);

        col = mate*vec3(7.0, 4.5, 3.0) * sun_dif * sun_ray;
        col += mate*vec3(0.5, 0.8, 0.9) * sky_dif;
        col += mate*vec3(0.7, 0.3, 0.2) * sky_bounce;

    }

    //gamma correction
    col = pow(col, vec3(0.4545));

    gl_FragColor = vec4(col, 1.0);
}