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
        paRender = PARender(device: mtlview.device!,view:mtlview)
        
    }
    
}







