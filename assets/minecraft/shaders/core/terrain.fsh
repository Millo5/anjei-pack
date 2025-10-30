#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec3 posPass;
in float isRainbow; // 0, 1, 2
in float isVoid; // 0, 1, 2

out vec4 fragColor;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif

    if (isVoid > 0.5) {
        fragColor = vec4(1., 1., 1., 1.);
        if (isVoid > 1.5) {
            // 150c1f
            fragColor = vec4(0.01, 0.01, 0.03, 1.);
        }
        return;
    }

    if (isRainbow > 0.) {
        float hue = (posPass.x + posPass.y + posPass.z) / 3.0 + 0.5 + GameTime * 500.;

        if (isRainbow > 1.5) {
            vec3 dir = normalize(posPass);

            float hue = atan(dir.y, dir.x) / (2.0 * 3.14159) + 0.5 + GameTime * 50.;
            float brightness = 0.5 + 0.5 * dir.z; // optional, for vertical gradient
            vec3 rainbow = hsv2rgb(vec3(hue, 1.0, brightness));

            fragColor = vec4(normalize(rainbow), 1.0);
            return;
        }

        vec3 hsvColor = hsv2rgb(vec3(hue, 1.0, 1.0));
        fragColor = vec4(hsvColor, 1.);
        return;
    }

    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}