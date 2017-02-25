//
//  PAMetal.metal
//  Break
//
//  Created by Armin Hamar on 24.02.17.
//  Copyright © 2017 ProjektBlue. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct Vertex
{
    float4  position [[position]];
    float4  color;
};

vertex Vertex Shader_vert(uint vid [[ vertex_id ]],
                                     constant packed_float4* position  [[ buffer(0) ]],
                                     constant packed_float4* color    [[ buffer(1) ]])
{
    Vertex outVertex;
    
    outVertex.position = position[vid];
    outVertex.color    = color[vid];
    
    return outVertex;
};

fragment half4 Shader_frag(Vertex inFrag [[stage_in]])
{
    return half4(inFrag.color);
};


