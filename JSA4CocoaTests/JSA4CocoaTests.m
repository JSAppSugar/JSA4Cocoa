//
//  JSA4CocoaTests.m
//  JSA4CocoaTests
//
//  Created by Neal on 2018/10/27.
//  Copyright © 2018 JSAppSugar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSA4Cocoa/JSA4Cocoa.h>
#import "TestOCObject.h"

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
        [jsa addJSClassLoader:loader];
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
        XCTAssertTrue([testObject hasMethod:@"getA"]);
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
        id testOCObject = [testObject invokeMethod: @"getNativeObj"];
        XCTAssertEqualObjects(@"TestOCObject", NSStringFromClass([testOCObject class]));
    }
    {
        NSString *a = [testObject invokeMethod:@"testNativeInit" Arguments:@[@"a",@1]];
        XCTAssertEqualObjects(@"a1", a);
    }
    {
        id o = [NSNull null];
        id r = [testObject invokeMethod:@"testNull" Arguments:@[o]];
        XCTAssertNil(r);
    }
    {
        NSString* r = [testObject invokeMethod:@"testString" Arguments:@[@"s"]];
        XCTAssertEqualObjects(@"s", r);
    }
    {
        NSNumber* r = [testObject invokeMethod:@"testInt" Arguments:@[@1]];
        XCTAssertEqual(1, [r intValue]);
    }
    {
        NSNumber* r = [testObject invokeMethod:@"testBool" Arguments:@[@true]];
        XCTAssertEqual(true, [r boolValue]);
    }
    {
        NSDictionary* m = @{@"a":@1,@"b":@"1"};
        NSDictionary* r = [testObject invokeMethod:@"testMap" Arguments:@[m]];
        NSNumber* a = [r valueForKey:@"a"];
        NSString* b = [r valueForKey:@"b"];
        id o = [r valueForKey:@"o"];
        id<JSAFunction> f = [r valueForKey:@"f"];
        XCTAssertEqual(1, [a intValue]);
        XCTAssertEqualObjects(@"1", b);
        XCTAssertEqualObjects(@"TestOCObject", NSStringFromClass([o class]));
        XCTAssertTrue([f conformsToProtocol: @protocol(JSAFunction)]);
    }
    {
        NSArray* m = @[@1,@"1"];
        NSArray* r = [testObject invokeMethod:@"testArray" Arguments:@[m]];
        NSNumber* a = [r objectAtIndex:0];
        NSString* b = [r objectAtIndex:1];
        XCTAssertEqual(1, [a intValue]);
        XCTAssertEqualObjects(@"1", b);
    }
    {
        NSObject* o = [NSObject new];
        NSObject* r = [testObject invokeMethod:@"testObject" Arguments:@[o]];
        XCTAssertEqual(o, r);
    }
    {
        id<JSAObject> o = [jsa newClass:@"test.jsa.TestObject" Arguments:@[@"a"]];
        id<JSAObject> r = [testObject invokeMethod:@"testJSAObject" Arguments:@[o]];
        XCTAssertEqualObjects(@"a", [r invokeMethod:@"getA"]);
    }
    {
        id<JSAObject> o = [jsa newClass:@"test.jsa.TestObject" Arguments:@[@"a"]];
        id<JSAFunction> f = [testObject invokeMethod:@"getTestFunc"];
        NSString* r = [f callWithArguments:@[@"f"]];
        XCTAssertEqualObjects(@"f", r);
        NSString* a = [f applyWithObject:o Arguments:@[@"f"]];
        XCTAssertEqualObjects(@"a", a);
    }
    {
        id<JSAFunction> f = [testObject invokeMethod:@"getTestFunc"];
        id<JSAFunction> r = [testObject invokeMethod:@"testJSAFunction" Arguments:@[f]];
        NSString* t = [r callWithArguments:@[@"f"]];
        XCTAssertEqualObjects(@"f", t);
    }
}

-(void)testStatic {
    {
        NSString* a = [jsa invokeClass:@"test.jsa.TestObject" Method:@"staticGetA" Arguments:@[@"a"]];
        XCTAssertEqualObjects(@"aa", a);
    }
    {
        NSString* a = [jsa staticVariable:@"staticA" Class:@"test.jsa.TestObject"];
        XCTAssertEqualObjects(@"a", a);
    }
    {
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
        NSString* r = [testObject invokeMethod:@"testNativeStatic"];
        XCTAssertEqualObjects(@"a", r);
    }
}

-(void)testWeak {
    {
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
        id<JSAWeakObject> weakTestObject = [testObject weakObject];
        XCTAssertNotNil([weakTestObject value]);
    }
    {
        TestOCObject* testOCObj = [[TestOCObject alloc] init];
        id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
        [testObject invokeMethod:@"testWeakNativeA" Arguments:@[testOCObj]];
        testOCObj = [testObject invokeMethod:@"testWeakNativeB"];
        XCTAssertNotNil(testOCObj);
    }
}

-(void)testJSNativeObject{
    id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
    {
        id v = [testObject invokeMethod:@"testNativeObject"];
        XCTAssertEqualObjects(@"TestOCObject", NSStringFromClass([v class]));
    }{
        id v = [testObject invokeMethod:@"testJSNativeObject"];
        XCTAssertEqualObjects(@"NSObject", NSStringFromClass([v class]));
    }
    {
        NSString* script = @"$import(\"test.jsa.NativeObject\");(function(){return new test.jsa.NativeObject();})();";
        id v = [jsa evaluateScript:script];
        XCTAssertEqualObjects(@"TestOCObject", NSStringFromClass([v class]));
    }
}

-(void)testPerformance{
    id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
    long max = 100000000;
    long c = [[testObject invokeMethod:@"testPerformance" Arguments:@[@(max)]] longValue];
    XCTAssertEqual(c,max);
}

-(void)testStaticInit{
    id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
    NSDictionary* m = @{@"s":@"s"};
    id o = [testObject invokeMethod:@"testStaticInit" Arguments:@[m]];
    NSString* s = [o getS];
    XCTAssertEqualObjects(@"s", s);
}

-(void)testWorkInMain{
    id<JSAObject> testObject = [jsa newClass:@"test.jsa.TestObject"];
    [testObject invokeMethod:@"testWorkInMain"];
    XCTAssertTrue(true);
}

@end
