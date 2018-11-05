//
//  JSA4Cocoa.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/23.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "JSA4Cocoa.h"
#import "JSAObjectCocoa.h"
#import "JSAObjectAccessor.h"

@implementation JSA4Cocoa{
    JSContext *_jsContext;
    id<JSClassLoader> _jsClassLoader;
    NSMutableSet *_loadedClasses;
    
    JSValue *f_newClass;
}

-(void) loadJSClassWithName:(NSString *) className{
    if(![_loadedClasses containsObject:className]){
        NSString* jsaScript = [_jsClassLoader loadJSClassWithName:className];
        if(jsaScript == nil){
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"Can't find JS class: %@ .",className] reason:nil userInfo:nil];
        }
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\$super[ ]*\\(" options:0 error:nil];
        jsaScript = [regularExpression stringByReplacingMatchesInString:jsaScript options:0 range:NSMakeRange(0, jsaScript.length) withTemplate:@"this.\\$super\\(\"\\$init\"\\)\\("];
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"(\\$super)[ ]*\\.[ ]*([0-9a-zA-Z\\$_]+)[ ]*\\(" options:0 error:nil];
        jsaScript = [regularExpression stringByReplacingMatchesInString:jsaScript options:0 range:NSMakeRange(0, jsaScript.length) withTemplate:@"this\\.$1(\"$2\")\\("];
        
        [_jsContext evaluateScript:jsaScript];
        [_loadedClasses addObject:className];
    }
}

-(void) setJSClassLoader:(id<JSClassLoader>) loader{
    _jsClassLoader = loader;
}

-(void) startEngine{
    [self startEngineWithLoader: [[DefaultJSClassLoader alloc] initWithNSBundle:[NSBundle bundleForClass: [JSA4Cocoa class]]]];
}
    
-(void) startEngineWithLoader:(id<JSClassLoader>) loader{
    if(_jsContext == nil){
        _loadedClasses = [NSMutableSet new];
        _jsContext = [[JSContext alloc]init];
        
        NSString *jsa4CScript = [loader loadJSClassWithName:@"JSA4Cocoa"];
        NSString *jsaScript = [loader loadJSClassWithName:@"JSAppSugar"];
        if(jsa4CScript == nil){
            @throw [NSException exceptionWithName:@"JSA4Cocoa.js not found" reason:nil userInfo:nil];
        }
        if(jsaScript == nil){
            @throw [NSException exceptionWithName:@"JSAppSugar.js not found" reason:nil userInfo:nil];
        }
        
        JSA4Cocoa __weak * SELF = self;
        _jsContext[@"$log"] = ^(NSString *s){
            NSLog(@"%@",s);
        };
        _jsContext[@"$oc_import"] = ^(NSArray* classes){
            for(NSString* className in classes){
                [SELF loadJSClassWithName:className];
            }
        };
        _jsContext[@"$oc_new"] = ^(NSString *className,NSString* initMethod,NSArray *arguments){
            return [JSAObjectAccessor constructWithClass:className InitMethod:initMethod Arguments:arguments];
        };
        _jsContext[@"$oc_invoke"] = ^(id object,NSString* method,NSArray* arguments){
            return [JSAObjectAccessor invokeObject:object Method:method Arguments:arguments];
        };
        _jsContext[@"$$oc_classInvoke"] = ^(NSString *className,NSString* method,NSArray* arguments){
            return nil;
        };
        
        [_jsContext evaluateScript: jsa4CScript];
        [_jsContext evaluateScript: jsaScript];
        f_newClass = _jsContext[@"$newClass"];
        if(_jsClassLoader == nil){
            _jsClassLoader = [[DefaultJSClassLoader alloc] init];
        }
    }
}

- (id)invokeClass:(NSString *)className Method:(NSString *)method {
    return [self invokeClass:className Method:method Arguments:@[]];
}

- (id)invokeClass:(NSString *)className Method:(NSString *)method Arguments:(NSArray *)arguments {
    return nil;
}

- (id<JSAObject>)newClass:(NSString *)className {
    return [self newClass:className Arguments:@[]];
}

- (id<JSAObject>)newClass:(NSString *)className Arguments:(NSArray *)arguments {
    [self loadJSClassWithName:className];
    JSValue* jsObj = [f_newClass callWithArguments:@[className,arguments]];
    if(jsObj != nil){
        return [[JSAObjectCocoa alloc]initWithJSValue:jsObj];
    }
    return nil;
}

@end
