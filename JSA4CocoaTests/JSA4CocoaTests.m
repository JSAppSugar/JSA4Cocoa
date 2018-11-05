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
        JSADefaultClassLoader *loader = [[JSADefaultClassLoader alloc] initWithNSBundle: [NSBundle bundleForClass: [JSA4CocoaTests class]]];
        [jsa setJSClassLoader:loader];
        [jsa startEngine];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDefaultJSClassLoader {
    JSADefaultClassLoader *loader = [[JSADefaultClassLoader alloc] initWithNSBundle: [NSBundle bundleForClass: [JSA4CocoaTests class]]];
    XCTAssertNil([loader loadJSClassWithName:@"TestObject"]);
    XCTAssertNotNil([loader loadJSClassWithName:@"test.jsa.TestObject"]);
}

- (void)testJSSuper {
    id<JSAObject> testObjectB = [jsa newClass:@"test.jsa.TestObjectB" Arguments:@[@"a",@"b"]];
    NSString* b = [testObjectB invokeMethod:@"getB"];
    XCTAssertEqualObjects(@"ab", b);
}

- (void)testNewJSClass {
    {
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
        NSString *a = [testObject invokeMethod:@"getA"];
        XCTAssertEqualObjects(@"-", a);
    }
    {
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject" Arguments:@[@"a"]];
        NSString *a = [testObject invokeMethod:@"getA"];
        XCTAssertEqualObjects(@"a", a);
    }
    {
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject" Arguments:@[@1]];
        int a = [[testObject invokeMethod:@"getA"] intValue];
        XCTAssertEqual(1, a);
    }
    {
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject" Arguments:@[@true]];
        BOOL a = [[testObject invokeMethod:@"getA"] boolValue];
        XCTAssertEqual(true, a);
    }
    {
        NSDictionary* m = @{@"a":@1,@"b":@"b"};
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject" Arguments:@[m]];
        NSDictionary* a = [testObject invokeMethod:@"getA"];
        XCTAssertEqual(1, [[a valueForKey:@"a"] intValue]);
        XCTAssertEqualObjects(@"b", [a valueForKey:@"b"]);
    }
    {
        NSArray *array = @[@1,@"a"];
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject" Arguments:@[array]];
        NSArray* a = [testObject invokeMethod:@"getA"];
        XCTAssertEqual(1, [[a objectAtIndex:0] intValue]);
        XCTAssertEqualObjects(@"a", [a objectAtIndex:1]);
    }
    {
        NSObject *obj = [NSObject new];
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject" Arguments:@[obj]];
        id a = [testObject invokeMethod:@"getA"];
        XCTAssertEqualObjects(obj, a);
    }{
        id<JSAObject> obj = [jsa newClass:@"test.jsa.TestObject" Arguments:@[@"a"]];
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject" Arguments:@[obj]];
        id<JSAObject> a = [testObject invokeMethod:@"getA"];
        XCTAssertEqualObjects(@"a", [a invokeMethod:@"getA"]);
    }
}

-(void)testTypes {
    id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
    {
        NSString *a = [testObject invokeMethod:@"testNativeInit" Arguments:@[@"a",@1]];
        XCTAssertEqualObjects(@"a1", a);
    }
    {
        id o = [NSNull null];
        id r = [testObject invokeMethod:@"testNull" Arguments:@[o]];
        XCTAssertNil(r);
    }
}

@end
