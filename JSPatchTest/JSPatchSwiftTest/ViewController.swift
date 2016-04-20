//
//  ViewController.swift
//  JSPatchSwiftTest
//
//  Created by yixiaoluo on 16/4/19.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    final override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\(self.getNameAsync())")
        
        self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("ObjCViewController"))!, animated: true) {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    dynamic private func getNameAsync() -> String {
        return "Origin ViewController"
    }

    func printV(text:String) {
        print("text from js: \(text)");
    }
}

