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

    float dist = 1. - sphericalVertexDistance / 5.;
    if (dist < 0.) {
        discard;
    }

    vec3 backgroundColor = vec3(0.08235294, 0.07058824, 0.12156863);
    vec3 foregroundColor = vec3(.5, .5, 1.);
    
    fragColor = vec4(mix(backgroundColor, foregroundColor, dist), dist);


    // fragColor = vec4(1., 1., 1., dist);

    // fragColor = vec4(.5, .5, 1., dist);
    // fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}