//
//  JSA4CocoaTests.m
//  JSA4CocoaTests
//
//  Created by Neal on 2018/10/27.
//  Copyright © 2018 JSAppSugar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSA4Cocoa/JSA4Cocoa.h>

@interface JSA4CocoaTests : XCTestCase

@end

@implementation JSA4CocoaTests{
    JSA4Cocoa *jsa;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if(jsa == nil){
        jsa = [[JSA4Cocoa alloc]init];
        DefaultJSClassLoader *loader = [[DefaultJSClassLoader alloc] initWithNSBundle: [NSBundle bundleForClass: [JSA4CocoaTests class]]];
        [jsa setJSClassLoader:loader];
        [jsa startEngine];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDefaultJSClassLoader {
    DefaultJSClassLoader *loader = [[DefaultJSClassLoader alloc] initWithNSBundle: [NSBundle bundleForClass: [JSA4CocoaTests class]]];
    XCTAssertNil([loader loadJSClassWithName:@"TestObject"]);
    XCTAssertNotNil([loader loadJSClassWithName:@"test.jsa.TestObject"]);
}

- (void)testNewJSClass {
    id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject" Arguments:@[@"a"]];
    NSString *a = [testObject invokeMethod:@"getA"];
    XCTAssertEqualObjects(@"a", a);
}

@end
