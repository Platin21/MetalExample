//
//  PARender.swift
//  Break
//
//  Created by Armin Hamar on 24.02.17.
//  Copyright © 2017 ProjektBlue. All rights reserved.
//

import MetalKit

enum Colors
{
    //0.075 0.352 0.906 1
    static let projektblue_blue = MTLClearColor(red: 0.075, green: 0.352, blue: 0.906, alpha: 1.0)
}




class PARender : NSObject , MTKViewDelegate
{
    var device: MTLDevice!
    var cmdQueue : MTLCommandQueue!
    
    var inflightSema = DispatchSemaphore(value: 3)
    
    
    init(device:MTLDevice)
    {
        super.init()
        self.MakeDevice(mtldevice: device);
        self.LoadFunctions()
    }
    
    func draw(in view: MTKView) {
        
        view.clearColor = Colors.projektblue_blue;
        
        guard
            let drawable = view.currentDrawable,
            let desc = view.currentRenderPassDescriptor
        else
        {
            return
        }
        
        let cmdBuffer = cmdQueue.makeCommandBuffer()
        let cmdEncoder = cmdBuffer.makeRenderCommandEncoder(descriptor: desc)
        
        
        
        cmdEncoder.endEncoding()
        cmdBuffer.present(drawable)
        cmdBuffer.commit()
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        //Make methods here
    
    }
    
}


extension PARender {
    
    func MakeDevice(mtldevice:MTLDevice)
    {
        self.device = mtldevice;
        self.cmdQueue = mtldevice.makeCommandQueue()
        self.cmdQueue.label = "Main Command Queue"
    }
    
    func LoadFunctions()
    {
        let lib = self.device.newDefaultLibrary()!;
        lib.label = "Main Lib";
        let vertexprg   = lib.makeFunction(name: "Shader_vert")
        let fragmentprg = lib.makeFunction(name: "Shader_frag")
        
        let stateDescriptor = MTLRenderPipelineDescriptor()
        stateDescriptor.vertexFunction = vertexprg;
        stateDescriptor.fragmentFunction = fragmentprg;
    }
}


