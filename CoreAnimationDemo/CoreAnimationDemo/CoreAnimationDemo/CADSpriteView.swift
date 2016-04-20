//
//  CADSpriteView.swift
//  CoreAnimationDemo
//
//  Created by yixiaoluo on 15/11/3.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

import UIKit

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class CADSpriteView: UIView {
    
    var iconNames:NSArray?;
    override convenience init(frame: CGRect) {
        self.init(frame: frame, iconNames:nil);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, iconNames:NSArray?) {
        
        super.init(frame: frame);
        self.frame = frame;
        if iconNames?.count > 4 {
            self.iconNames = iconNames?.subarrayWithRange(NSMakeRange(0, 4));
        }else{
            self.iconNames = iconNames;
        }
        
        let frameArray:NSArray = [NSStringFromCGRect(CGRectMake(0, 0, 0.5, 0.5)), NSStringFromCGRect(CGRectMake(0, 0, 1, 1)),NSStringFromCGRect(CGRectMake(0.5, 0.5, 0.5, 0.5)),NSStringFromCGRect(CGRectMake(0.5, 0.5, 1, 1))];
        self.iconNames?.enumerateObjectsUsingBlock({ (iconName:AnyObject, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            let layer = CALayer();
            layer.frame = CGRectFromString(frameArray[idx] as! String);
            self.layer
        });
    }
}
