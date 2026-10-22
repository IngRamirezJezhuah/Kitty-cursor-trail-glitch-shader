#language slang 2026
// cursor-trail-glitch - efecto Glitch + particulas
// licencia MIT - Djxs4n

import kitty_custom_shader_types;

// paleta de color rgba
static const float4 COL_DARK = float4(0.002843, 0.003937 ,0.016807, 1.0);
static const float4 COL_MAGENTA = float4(0.930111, 0.001357, 0.376262, 1.0);
static const float4 COL_CYAN = float4(0.0, 1.0, 1.0, 1.0);

// parametros
static const float DURATION = 0.5;
static const float GHOST_OFFSET = 0.006;
static const float JITTER = 0.03;

static float
hash11(float p) {
  p = frac(p * 0.1031);
  p *= p + 33.33;
  p *= p + p;
  return frac(p);
}

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
  
  float age = clamp((d.timestamp -d.cursor_trail_change_time) / DURATION, 0.0, 1.0);
  if (age >= 1.0) return color; 

  // la chingadera de cuando el cursor va en vertical
  float2 pixelDims = float2(d.viewport_size_pixels) * t.viewport.zw;
  float2 px = t.pos * pixelDims;
  float seed = floor(d.cursor_trail_change_time * 1000.0) * 0.013;
  float moving = d.cursor_trail_state;

  float2 uv = t.pos; // chingadera del pixel para saber cual es
  float offset = GHOST_OFFSET * age ; // La mmda del desfase en uv
  
  float row = floor(px.y); // fila de píxeles
  float jump = hash11(row + seed);
  float shift = (step(0.85, jump) * (jump - 0.85)) * JITTER;  // solo algunas filas saltan
  float2 uvShifted = t.pos + float2(shift, 0.0);

  // mezcla de colores
  float4 newColor = color;
  float4 g = t.backbuffer.Sample(uvShifted - float2(offset, 0.0));
  float4 r = t.backbuffer.Sample(uvShifted + float2(offset, 0.0));
  float3 split = g.rgb * COL_MAGENTA.rgb - r.rgb * COL_CYAN.rgb;
  
  float glitchAmt = 1.0 - age;
  float intensity = clamp(glitchAmt * moving * 2.0, 0.0, 1.0);

  // la madre que hace que no se sobreponga
  float insideCursor = step(d.cursor_trail_edge.x, t.pos.x) * step(t.pos.x, d.cursor_trail_edge.y)
                   * step(d.cursor_trail_edge.w, t.pos.y) * step(t.pos.y, d.cursor_trail_edge.z);
  newColor.rgb = lerp(newColor.rgb, color.rgb, insideCursor);

  return newColor;
}


