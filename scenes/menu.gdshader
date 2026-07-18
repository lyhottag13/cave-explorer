shader_type canvas_item;

uniform vec2 hole_position = vec2(0.5, 0.5); // Normalized (0-1)
uniform float hole_radius = 0.2;
uniform float edge_softness = 0.01;

void fragment() {
    float dist = distance(UV, hole_position);

    float alpha = smoothstep(
        hole_radius,
        hole_radius + edge_softness,
        dist
    );

    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}