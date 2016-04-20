// JS Demo： https://github.com/bang590/JSPatch/wiki/JSPatch-基础用法

//change view background color to red color
require('UIView, UIColor')
defineClass('JSPatchSwiftTest.ViewController', {
            viewDidLoad: function (){
            self.super().viewDidLoad();
            self.view().setBackgroundColor(UIColor.yellowColor());
            
            var view = UIView.alloc().init();
            view.setFrame({x:100, y:100, width:100, height:100});
            view.setBackgroundColor(UIColor.redColor());
            self.view().addSubview(view);
            }
            });


/**
 if your patch doesn't take effect, you should consider adding the dynamic attribute to the function
 
 http://stackoverflow.com/questions/25651081/method-swizzling-in-swift
 
 In production environment, I advise you to add the dynamic attribute to all your Custom Function.
 But you must know, this operation will reduce efficiency.
 */
defineClass('JSPatchSwiftTest.ViewController',{
                getNameAsync: function (){
                    return "Swift test";
                }
            });

defineClass('ObjCViewController',{
                getNameAsync: function (){
                    return "ObjC test";
                }
            });


//Reactive Cocoa
defineClass('ObjCViewController', {
            viewDidLoad: function (){
            self.super().viewDidLoad();
            
            
            var userNameFieldSignal = self.userNameField().rac__textSignal();//rac_textSignal==> rac__textSignal
            var passwordFieldSignal = self.passwordField().rac__textSignal();

            var slf = self;//use block
            var reduceBlock = block('NSString *, NSString *', function (userName, password){
                                    var u = userName.length() >= 3
                                    var p = password.length() >= 2;
                                    var enable = u && p;
                                    
//                                    slf.printV(userName + " " + password);
//                                    slf.printV("enable:" + enable + " " + "u:" + u + "p:" + p);
                                    
                                    return enable
                                    });
            var enableSignal = require('RACSignal').combineLatest_reduce(new Array(userNameFieldSignal, passwordFieldSignal), reduceBlock);
            
            require('RACSubscriptingAssignmentTrampoline').alloc().initWithTarget_nilValue(self.loginButton(), 0).setObject_forKeyedSubscript(enableSignal, "enabled");
            
            self.loginButton().rac__valuesForKeyPath_observer("enabled", self).subscribeNext(block('NSNumber *', function(x){
                                                                                                   if (x) {
                                                                                                      slf.dismissViewControllerAnimated_completion(YES, null);
                                                                                                   }
                                                                                                   
                                                                                                   }));
            }
            });
