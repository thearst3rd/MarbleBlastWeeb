precision mediump float;

#include <definitions>

varying vec2 vUv;
varying float vFragDepth;
varying float vIsPerspective;
varying vec4 color;

uniform sampler2D diffuseMap;
uniform float logDepthBufFC;

uniform bool bitcrush;

#if defined(LOG_DEPTH_BUF) && defined(IS_WEBGL1)
	#extension GL_EXT_frag_depth : enable
#endif

void main() {
	gl_FragColor = color * texture2D(diffuseMap, vUv);

	#ifdef LOG_DEPTH_BUF
		// We always need to set gl_FragDepthEXT when it's present in the file, otherwise it gets real weird
		// Also: Doing a strict comparison with == 1.0 can cause noise artifacts
		gl_FragDepthEXT = (vIsPerspective != 0.0)? log2(vFragDepth) * logDepthBufFC * 0.5 : gl_FragCoord.z;
	#endif

	if (bitcrush) {
		// Apply bit reduction
		float bitDepth = 8.0;
		gl_FragColor.r = floor(gl_FragColor.r * bitDepth + 0.5) / bitDepth;
		gl_FragColor.g = floor(gl_FragColor.g * bitDepth + 0.5) / bitDepth;
		gl_FragColor.b = floor(gl_FragColor.b * bitDepth + 0.5) / bitDepth;
	}
}
