shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 256.0) = 32.0;

void fragment() {
    vec2 grid = vec2(pixel_size);
    vec2 uv_pixelizada = floor(UV * grid) / grid;
    COLOR = texture(TEXTURE, uv_pixelizada);
}