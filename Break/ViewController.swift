//
//  ViewController.swift
//  Break
//
//  Created by Armin Hamar on 24.02.17.
//  Copyright © 2017 ProjektBlue. All rights reserved.
//

import UIKit
import MetalKit




class ViewController: UIViewController
{
    var mtlview : MTKView
    {
        return view as! MTKView
    }
    
    var paRender : PARender!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mtlview.device = MTLCreateSystemDefaultDevice();
        paRender = PARender(device: mtlview.device!)
        mtlview.delegate = paRender;
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        for touch in touches
        {
            print(touch.location(in: self.mtlview))
        }
        */
    }
    
    
    
}

/*
extension ViewController : MTKViewDelegate
{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        
        
    }
    
    func draw(in view: MTKView) {
        
        guard let drawable = view.currentDrawable,let desc = view.currentRenderPassDescriptor
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
}
*/








