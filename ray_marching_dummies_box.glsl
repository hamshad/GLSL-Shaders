#ifdef GL_ES
    precision mediump float;
#endif

#define MAX_STEPS 100
#define MAX_DIST 100.
#define MAX_SURF .01

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Basically we are marching towards the point i.e intersecting
float RayMarch( vec3 a, vec3 b );
//getting distance between camera and the place where intersection hit
float GetDist( vec3 x );
//get diffuse light
float GetLight( vec3 a );
//get the normal i.e is light parallel to ground or not to reflect
vec3 GetNormal( vec3 p );

void main() {

    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution) / u_resolution.y;

    vec3 color = vec3(0);

    //ray origin ( camera model )
    // vec3 ro = vec3(0, 1, 0);
    vec3 ro = vec3(-5, 5, 0);
    //ray direction
    // vec3 rd = normalize(vec3(uv.x, uv.y, 1.0));
    vec3 rd = normalize(vec3(uv.x + 0.9, uv.y - 0.6, 1.0));

    float d = RayMarch(ro, rd);
    // d /= 6.;

    //diffuse ligth
    vec3 p = ro + rd * d;
    
    float dif = GetLight( p );
    color = vec3( dif);

    gl_FragColor = vec4(color, 1.0);
}

//Ray Marching function
float RayMarch( vec3 ro, vec3 rd ) {
    float dO = 0.;

    for(int i = 0; i < MAX_STEPS; i++) {
        vec3 p = ro + rd*dO;
        float ds = GetDist(p);
        dO += ds;
        if (dO>MAX_DIST || dO<MAX_SURF) break;
    }

    return dO;
}

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float GetDist( vec3 p ) {

    float movS = sin(u_time)+cos(u_time);
    //sphere ( middle, above from ground, away from screen, radius )
    // vec4 s = vec4(0, 1, 6, 1);
    vec4 s = vec4(movS, 1, mix(2.0, 3.0, abs(movS + .2)*6.), u_time >= 1. ? 1.0 : smoothstep(0.4,1.0, u_time));
    
    //getting length from both camera and object's center and removing radius
    // float sphereDist = length(p-s.xyz)-s.w;
    float boxDist = sdBox(p-vec3(0, 1.3, 6), vec3(1.2, 1, 1));
    float planeDist = p.y;

    float d = min(boxDist - 0.3, planeDist);
    // float d = min(sphereDist, planeDist);
    return d;
}

float GetLight( vec3 p ) {
    // vec3 lightPos = vec3(0, 5, 6);
    vec3 lightPos = vec3(-2.0, 5, 3);
    lightPos.xz += vec2(sin(u_time), cos(u_time)) * 2.;
    vec3 l = normalize(lightPos-p);
    vec3 n = GetNormal(p);

    float dif = clamp(dot(n, l), 0.0, 1.0);
    float d = RayMarch(p + n * MAX_SURF * 2., l);
    if(d < length(lightPos - p)) dif *= .1;

    return dif;
}

vec3 GetNormal( vec3 p ) {
    float d = GetDist(p);
    vec2 e = vec2(0.01, 0.0);

    vec3 n = d - vec3(
        GetDist(p - e.xyy),
        GetDist(p - e.yxy),
        GetDist(p - e.yyx)
    );

    return normalize(n);
}