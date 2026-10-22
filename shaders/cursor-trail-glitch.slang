#language slang 2026
// cursor-trail-glitch - efecto Glitch + particulas
// licencia MIT - Djxs4n

import kitty_custom_shader_types;

// paleta de color rgba
static cons float4 COL_DARK = float4(0.002843, 0.003937 ,0.016807, 1.0);
static const float4 COL_MAGENTA = float4(0.930111, 0.001357, 0.376262, 1.0);
static const float4 COL_CYAN = float4(0.0, 1.0, 1.0, 1.0);

// parametros

static cons float DURATION = 0.5;

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
  return color;
}
