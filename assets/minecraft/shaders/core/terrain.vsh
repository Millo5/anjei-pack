#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

uniform sampler2D Sampler0;
uniform vec3 ChunkOffset;
uniform mat3 IViewRotMat;

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec3 posPass;
out float isRainbow; // 0, 1, 2
out float isVoid;

bool color_equals(vec3 a, vec3 b) {
    return all(lessThan(abs(a - b), vec3(0.01)));
}

vec4 minecraft_sample_lightmap(sampler2D lightMap, ivec2 uv) {
    return texture(lightMap, clamp((uv / 256.0) + 0.5 / 16.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}

void main() {
    vec3 pos = Position + ModelOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    posPass = sin(Position * 3.1415 * 2 / 16.); // (ProjMat * vec4(pos, 1.0)).rgb;

    isVoid = 0.;
    isRainbow = 0.;
    vec4 color = texture(Sampler0, UV0);
    if (color_equals(color.rgb * 255., vec3(24, 4, 8))) {
        isRainbow = 1.;
    }
    if (color_equals(color.rgb * 255., vec3(24, 4, 7))) {
        isRainbow = 2.;

        vec3 pos2 = IViewRotMat * (Position + ChunkOffset);
        vec3 camPos = inverse(mat3(ModelViewMat)) * ModelViewMat[3].xyz;
        vec3 toBlock = pos2 - camPos;

        if (abs(ProjMat[3][3] - 1.0) > 0.01) { //check if the item is in the world and not in a gui
            mat4 projMat = ProjMat;
            vec3 position = Position;
            projMat[3].xy = vec2(0.0);
            position += vec3(ProjMat[3].xy, 0.0);

            vec4 normal = projMat * ModelViewMat * vec4(Normal, 0.0);
            pos2 = IViewRotMat * (position + ChunkOffset);
            toBlock = pos2 - camPos;
        }

        vec3 viewDir = normalize((ProjMat * vec4(pos-pos2, 1.0)).xyz);

        posPass = viewDir; //floor(gl_Position.rgb);//( * ProjMat * vec4(pos, 1.0)).rgb;
    }
    if (color_equals(color.rgb * 255., vec3(24, 4, 6))) {
        isVoid = 1.;
    }
    if (color_equals(color.rgb * 255., vec3(24, 4, 5))) {
        isVoid = 2.;
    }


    sphericalVertexDistance = fog_spherical_distance(pos);
    cylindricalVertexDistance = fog_cylindrical_distance(pos);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
}