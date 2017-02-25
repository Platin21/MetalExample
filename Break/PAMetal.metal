//
//  PAMetal.metal
//  Break
//
//  Created by Armin Hamar on 24.02.17.
//  Copyright © 2017 ProjektBlue. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


float rand(float2 co,uint id)
{
    return fract(sin(dot(co.xy,float2(12.9898,78.233))) * 43758.5453) + (id / 10);
}

struct Vertex
{
    float4  position [[position]];
    float4  color;
    uint    id;
};

vertex Vertex Shader_vert(uint vid [[ vertex_id ]],constant packed_float4* position  [[ buffer(0) ]],constant packed_float4* color    [[ buffer(1) ]])
{
    Vertex outVertex;
    
    outVertex.position = position[vid];
    outVertex.color    = color[vid];
    outVertex.id = vid;
    
    return outVertex;
};

fragment half4 Shader_frag(Vertex inFrag [[stage_in]])
{
    return half4(rand(inFrag.color.rg,inFrag.id),rand(inFrag.color.gb,inFrag.id),rand(inFrag.color.rb,inFrag.id),1.0);
};


