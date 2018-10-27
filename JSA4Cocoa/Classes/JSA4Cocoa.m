//
//  JSA4Cocoa.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/23.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "JSA4Cocoa.h"
#import "DefaultJSClassLoader.h"

@implementation JSA4Cocoa{
    JSContext *_jsContext;
}

-(void) startEngine{
    if(_jsContext == nil){
        _jsContext = [[JSContext alloc]init];
        DefaultJSClassLoader *jsLoader = [[DefaultJSClassLoader alloc] initWithNSBundle:[NSBundle bundleForClass: [JSA4Cocoa class]]];
        [_jsContext evaluateScript: [jsLoader loadJSClassWithName:@"JSAppSugar"]];
    }
}

- (id)invokeClass:(NSString *)className Method:(NSString *)method {
    return nil;
}

- (id)invokeClass:(NSString *)className Method:(NSString *)method Arguments:(NSArray *)arguments {
    return nil;
}

- (id<JSAObject>)newClass:(NSString *)className {
    return nil;
}

- (id<JSAObject>)newClass:(NSString *)className Arguments:(NSArray *)arguments {
    return nil;
}

@end
