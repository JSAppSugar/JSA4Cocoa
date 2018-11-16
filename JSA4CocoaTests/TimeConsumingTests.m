//
//  TimeConsumingTests.m
//  JSA4CocoaTests
//
//  Created by Neal on 2018/11/16.
//  Copyright © 2018年 JSAppSugar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSA4Cocoa/JSA4Cocoa.h>

@interface TimeConsumingTests : XCTestCase

@end

@implementation TimeConsumingTests{
    JSA4Cocoa *jsa;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if(jsa == nil){
        jsa = [[JSA4Cocoa alloc]init];
        JSADefaultClassLoader *loader = [[JSADefaultClassLoader alloc] initWithNSBundle: [NSBundle bundleForClass: [TimeConsumingTests class]]];
        [jsa addJSClassLoader:loader];
        [jsa startEngine];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testPerformanceExample {
    id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
    // This is an example of a performance test case.
    [self measureBlock:^{
        for(int i=0;i<10000;i++){
            [testObject invokeMethod:@"getA"];
        }
    }];
}

@end
