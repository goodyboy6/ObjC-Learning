//
//  AMapUITests.m
//  AMapUITests
//
//  Created by yixiaoluo on 16/4/12.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AMapUITests : XCTestCase

@end

@implementation AMapUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *staticText = app.tables.staticTexts[@"\u8def\u5f84\u89c4\u5212"];
    [staticText tap];
    
    XCUIElement *button = app.navigationBars[@"\u8def\u5f84\u89c4\u5212"].buttons[@"\u9ad8\u5fb7\u5730\u56fe\u6d4b\u8bd5"];
    [button tap];
    [staticText tap];
    [button tap];
}

@end
