//
//  ViewController.swift
//  CoreAnimationDemo
//
//  Created by yixiaoluo on 15/11/3.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var layerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let subLayer:CALayer = CALayer();
        subLayer.frame = layerView.bounds;
        layerView.layer.addSublayer(subLayer);
        
        let img:UIImage? = UIImage(named:"copy");
        subLayer.contents = img?.CGImage as? AnyObject;
        subLayer.backgroundColor = UIColor.brownColor().CGColor;
        
        //content mode
        //layerView.contentMode <==> subLayer.contentsGravity
//        layerView.contentMode = UIViewContentMode.ScaleAspectFit;
        subLayer.contentsGravity = kCAGravityCenter;
        subLayer.contentsScale = (img?.scale)!;
        
        
        subLayer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);//CGRectMake(0.25, 0.25, 0.75, 0.75);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

