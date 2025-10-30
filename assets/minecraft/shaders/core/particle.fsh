#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

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

    vec3 backgroundColor = vec3(0.01, 0.01, 0.03);
    vec3 foregroundColor = vec3(.3, .3, .6);
    
    float dist = 1. - vertexColor.r;

    fragColor = vec4(mix(foregroundColor, backgroundColor, dist), 1.);


    // // fragColor = vec4(1., 1., 1., dist);

    // // fragColor = vec4(.5, .5, 1., dist);
    // fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}