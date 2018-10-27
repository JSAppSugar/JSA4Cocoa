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

@implementation JSA4CocoaTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDefaultJSClassLoader {
    DefaultJSClassLoader *loader = [[DefaultJSClassLoader alloc] initWithNSBundle: [NSBundle bundleForClass: [JSA4CocoaTests class]]];
    XCTAssertNil([loader loadJSClassWithName:@"TestObject"]);
    XCTAssertNotNil([loader loadJSClassWithName:@"js.test.TestObject"]);
}

- (void)testJSA4CocoaInit {
    JSA4Cocoa *jsa = [[JSA4Cocoa alloc] init];
    [jsa startEngine];
    XCTAssertNotNil(jsa);
}

@end
