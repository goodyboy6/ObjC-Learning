//
//  ViewController.m
//  TransitionDemo
//
//  Created by yixiaoluo on 15/11/12.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(300, 300)];
    container.widthTracksTextView = YES; // Controls whether the receiveradjusts the width of its bounding rectangle when its text view is resized
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(300, 150)];
    [path addArcWithCenter:CGPointMake(150, 150) radius:150 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    container.exclusionPaths = @[path];
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init]; // new in iOS 7.0
    [layoutManager addTextContainer:container];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 300, 300) textContainer:container];
    textView.textColor = [UIColor blackColor];
    textView.text = @"帮助系统LLDB帮助系统让我们可以了解LLDB提供了哪些功能，并可以查看LLDB命令结构的详细信息。熟悉帮助系统可以让我们访问帮助系统中中命令文档。我们可以简单地调用help命令来列出LLDB所有的顶层命令。如下所示：12345678910111213(lldb) helpThe following is a list of built-in, permanent debugger commands:_regexp-attach    -- Attach to a process id if in decimal, otherwise treat the                     argument as a process name to attach to._regexp-break     -- Set a breakpoint using a regular expression to specify the                     location, where <linenum> is in decimal and <address> is                     in hex._regexp-bt        -- Show a backtrace.  An optional argument is accepted; if                     that argument is a number, it specifies the number of                     frames to display.  If that argument is 'all', full                     backtraces of all threads are displayed. … and so forth …如果help后面跟着某个特定的命令，则会列出该命令相关的所有信息，我们以breakpoint set为例，输出信息如下：123456789101112(lldb) help breakpoint set     Sets a breakpoint or set of breakpoints in the executable.Syntax: breakpoint set <cmd-options>Command Options Usage:  breakpoint set [-Ho] -l <linenum> [-s <shlib-name>] [-i <count>] [-c <expr>] [-x <thread-index>] [-t <thread-id>] [-T <thread-name>] [-q <queue-name>] [-f <filename>] [-K <boolean>]  breakpoint set [-Ho] -a <address-expression> [-s <shlib-name>] [-i <count>] [-c <expr>] [-x <thread-index>] [-t <thread-id>] [-T <thread-name>] [-q <queue-name>]  breakpoint set [-Ho] -n <function-name> [-s <shlib-name>] [-i <count>] [-c <expr>] [-x <thread-index>] [-t <thread-id>] [-T <thread-name>] [-q <queue-name>] [-f <filename>] [-K <boolean>] [-L <language>]  breakpoint set [-Ho] -F <fullname> [-s <shlib-name>] [-i <count>] [-c <expr>] [-x <thread-index>] [-t <thread-id>] [-T <thread-name>] [-q <queue-name>] [-f <filename>] [-K <boolean>] … and so forth …还有一种更直接的方式来查看LLDB有哪些功能，即使用apropos命令：它会根据关键字来搜索LLDB帮助文档，并为每个命令选取一个帮助字符串，我们以apropos file为例，其输出如下：12345678910111213141516171819(lldb) apropos fileThe following commands may relate to 'file':…log enable                     -- Enable logging for a single log channel.memory read                    -- Read from the memory of the process being                                  debugged.memory write                   -- Write to the memory of the process being                                  debugged.platform process launch        -- Launch a new process on a remote platform.platform select                -- Create a platform if needed and select it as                                  the current platform.plugin load                    -- Import a dylib that implements an LLDB                                  plugin.process launch                 -- Launch the executable in the debugger.process load                   -- Load a shared library into the current                                  process.source                         -- A set of commands for accessing source file                                  information… and so forth …我们还可以使用help来了解一个命令别名的构成。如：";
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
