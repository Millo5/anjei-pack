#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;
in vec4 rawColor;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    if (vertexColor.g > 0.5) {
        discard;
    }
    if (vertexColor.b > 0.5) {
        discard;
    }

    // fragColor = vec4(vertexColor.r, vertexColor.r, vertexColor.r, 1.);
    // fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
    // return;
    int green = int(rawColor.g * 255.0);

    vec3 backgroundColor = vec3(0.01, 0.01, 0.03);
    vec3 foregroundColor = vec3(.4, .4, .8);

    if (green >= 1 && green < 5) {
        foregroundColor = vec3(1., 0., 0.);
    }
    if (green >= 1 && green < 5) {
        foregroundColor = vec3(1., 0., 0.);
    }
    
    float dist = 1.15 - rawColor.r;
    if (dist < 0.) {
        dist = 0.;
    }
    if (dist > 1.) {
        dist = 1.;
    }

    fragColor = vec4(mix(foregroundColor, backgroundColor, dist), 1.);


    // // fragColor = vec4(1., 1., 1., dist);

    // // fragColor = vec4(.5, .5, 1., dist);
    // fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}