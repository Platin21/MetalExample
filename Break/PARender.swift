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


let vertexData:[Float] = [
    -1.0 , -1.0, 1.0, 1.0,
    -1.0 ,  1.0, 1.0, 1.0,
    1.0  , -1.0, 1.0, 1.0
]

let ColorData:[Float] = [
    0.0, 0.25, 0.0, 1.0,
    0.0, 1.0, 0.0, 1.0,
    0.0, 0.25, 0.0, 1.0
]


func ownView(pos:Float)
{
    
}


class PARender : NSObject , MTKViewDelegate
{
    var device: MTLDevice!
    var cmdQueue : MTLCommandQueue!
    var view : MTKView!
    var inflightSema = DispatchSemaphore(value: 3)
    
    var pipeState:MTLRenderPipelineState! = nil
    
    //Buffer for Vertex and Vertecis
    var vertexBF : MTLBuffer! = nil
    var vertexColorBF : MTLBuffer! = nil
    
    var drawn : Bool = false;
    
    init(device:MTLDevice,view:MTKView)
    {
        super.init()
        
        self.view = view;
        self.view.delegate = self;
        self.view.clearColor = Colors.projektblue_blue
        
        self.MakeDevice(mtldevice: device);
        self.LoadShaders(vertexBuffer: vertexData ,colorBuffer: ColorData )
    }
    
    func draw(in view: MTKView) {
        if !drawn
        {
            let _ = inflightSema.wait(timeout: DispatchTime.distantFuture)
        
        
        
            let cmdBuffer = cmdQueue.makeCommandBuffer()
            cmdBuffer.label = "Frame cmdBuffer"
        
            cmdBuffer.addCompletedHandler{
                    [weak self] cmdBuffer in
                if let strongSelf = self
                {
                    strongSelf.inflightSema.signal()
                }
                return
            }
        
            guard
                let drawable = view.currentDrawable,
                let desc = view.currentRenderPassDescriptor
            else
            {
                return
            }
        
            let cmdEncoder = cmdBuffer.makeRenderCommandEncoder(descriptor: desc)
            cmdEncoder.label = "Encoder"
        
            //Add some Loading !
            cmdEncoder.pushDebugGroup("Draw Triangle")
            cmdEncoder.setRenderPipelineState(pipeState)
            cmdEncoder.setVertexBuffer(vertexBF, offset: 0, at: 0)
            cmdEncoder.setVertexBuffer(vertexColorBF, offset: 0, at: 1)
            cmdEncoder.drawPrimitives(type: .triangle , vertexStart: 0, vertexCount: 3)
            cmdEncoder.popDebugGroup()
            cmdEncoder.endEncoding()
        
            cmdBuffer.present(drawable)
            cmdBuffer.commit()
            drawn = true;
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        //Make methods for Resizing !
    
    }
    
}


extension PARender {
    
    func MakeDevice(mtldevice:MTLDevice)
    {
        self.device = mtldevice;
        self.cmdQueue = mtldevice.makeCommandQueue()
        self.cmdQueue.label = "Main Command Queue"
    }
    
    func LoadShaders(vertexBuffer:[f32],colorBuffer:[f32])
    {
        let lib = self.device.newDefaultLibrary()!;
        lib.label = "Main Lib";
        let vertexprg   = lib.makeFunction(name: "Shader_vert")
        let fragmentprg = lib.makeFunction(name: "Shader_frag")
        
        let stateDescriptor = MTLRenderPipelineDescriptor()
        stateDescriptor.vertexFunction = vertexprg;
        stateDescriptor.fragmentFunction = fragmentprg;
        
        let piplineDesc = MTLRenderPipelineDescriptor()
        piplineDesc.vertexFunction = vertexprg;
        piplineDesc.fragmentFunction = fragmentprg;
        piplineDesc.colorAttachments[0].pixelFormat = view.colorPixelFormat
        piplineDesc.sampleCount = view.sampleCount
        
        do
        {
            try pipeState = device.makeRenderPipelineState(descriptor: piplineDesc)
        }
        catch let error
        {
          print("Error Piplinestate: \(error)")
        }
        
        let vertexBfSize = vertexBuffer.count * MemoryLayout<Float>.stride * 4
        vertexBF = device.makeBuffer(bytes: vertexData,length: vertexBfSize, options: [])
        vertexBF.label = "vertices"
        
        let ColorBfSize = colorBuffer.count * MemoryLayout<Float>.stride
        vertexColorBF = device.makeBuffer(bytes: colorBuffer ,length: ColorBfSize, options: [])
        vertexColorBF.label = "colors"
        
    }
}


