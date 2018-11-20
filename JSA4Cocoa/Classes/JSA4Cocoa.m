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
#import "JSAConvertor.h"

@implementation JSA4Cocoa{
    JSContext *_jsContext;
    id<JSAClassLoader> _mainClassLoader;
    NSMutableArray* _jsClassLoaders;
    NSMutableSet *_loadedClasses;
    NSMapTable *_weakMap;
    
    JSValue *f_newClass;
    JSValue *f_classFunction;
}

-(instancetype) init{
    if(self = [super init]){
        _jsClassLoaders = [NSMutableArray new];
        _mainClassLoader = [[JSADefaultClassLoader alloc] init];
    }
    return self;
}

-(void) loadJSClassWithName:(NSString *) className{
    if(![_loadedClasses containsObject:className]){
        NSString* jsaScript = nil;
        for(id<JSAClassLoader> loader in _jsClassLoaders){
            jsaScript = [loader loadJSClassWithName:className];
        }
        if(jsaScript == nil){
            jsaScript = [_mainClassLoader loadJSClassWithName:className];
        }
        if(jsaScript == nil){
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"Can't find JS class: %@ .",className] reason:nil userInfo:nil];
        }
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\$super[ ]*\\(" options:0 error:nil];
        jsaScript = [regularExpression stringByReplacingMatchesInString:jsaScript options:0 range:NSMakeRange(0, jsaScript.length) withTemplate:@"this.\\$super\\(\"\\$init\"\\)\\("];
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"(\\$super)[ ]*\\.[ ]*([0-9a-zA-Z\\$_]+)[ ]*\\(" options:0 error:nil];
        jsaScript = [regularExpression stringByReplacingMatchesInString:jsaScript options:0 range:NSMakeRange(0, jsaScript.length) withTemplate:@"this\\.$1(\"$2\")\\("];
        
        [_jsContext evaluateScript:jsaScript withSourceURL:[NSURL URLWithString:className]];
        [_loadedClasses addObject:className];
    }
}

-(void) addJSClassLoader:(id<JSAClassLoader>) loader{
    [_jsClassLoaders insertObject:loader atIndex:0];
}

-(void) startEngine{
    [self startEngineWithLoader: [[JSADefaultClassLoader alloc] initWithNSBundle:[NSBundle bundleForClass: [JSA4Cocoa class]]]];
}
    
-(void) startEngineWithLoader:(id<JSAClassLoader>) loader{
    if(_jsContext == nil){
        _loadedClasses = [NSMutableSet new];
        _jsContext = [[JSContext alloc]init];
        [_jsContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
            NSLog(@"%@",exception);
        }];
        
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
        [_jsContext evaluateScript: jsa4CScript];
        [_jsContext evaluateScript: jsaScript];
        f_newClass = _jsContext[@"$newClass"];
        f_classFunction = _jsContext[@"$classFunction"];
        JSValue *f_retrieve = _jsContext[@"$js_retrieve"];
        _jsContext[@"$oc_new"] = ^(NSString *className,NSString* initMethod,NSArray *arguments){
            arguments = [JSAConvertor js2ocWithParamObject:arguments Retrieve:f_retrieve];
            return [JSAObjectAccessor constructWithClass:className InitMethod:initMethod Arguments:arguments];
        };
        _jsContext[@"$oc_invoke"] = ^(id object,NSString* method,NSArray* arguments){
            arguments = [JSAConvertor js2ocWithParamObject:arguments Retrieve:f_retrieve];
            id value = [JSAObjectAccessor invokeObject:object Method:method Arguments:arguments];
            return [JSAConvertor oc2jsWithObject:value];
        };
        _jsContext[@"$oc_classInvoke"] = ^(NSString *className,NSString* method,NSArray* arguments){
            arguments = [JSAConvertor js2ocWithParamObject:arguments Retrieve:f_retrieve];
            id value = [JSAObjectAccessor invokeClass:className Method:method Arguments:arguments];
            return [JSAConvertor oc2jsWithObject:value];
        };
        NSMapTable *weakMap = [NSMapTable weakToWeakObjectsMapTable];
        _weakMap = weakMap;
        _jsContext[@"$oc_save_weak"] = ^(id key,id value){
            [weakMap setObject:value forKey:key];
        };
        _jsContext[@"$oc_get_weak"] = ^(id key){
            return [weakMap objectForKey:key];
        };
    }
}

- (id)invokeClass:(NSString *)className Method:(NSString *)method {
    return [self invokeClass:className Method:method Arguments:@[]];
}

- (id)invokeClass:(NSString *)className Method:(NSString *)method Arguments:(NSArray *)arguments {
    [self loadJSClassWithName:className];
    arguments = [JSAConvertor oc2jsWithObject:arguments];
    JSValue* value = [f_classFunction callWithArguments:@[className,method,arguments]];
    return [JSAConvertor js2ocWithReturnJSValue:value];
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

-(id) evaluateScript:(NSString*) script{
    JSValue *value = [_jsContext evaluateScript:script];
    return [JSAConvertor js2ocWithReturnJSValue:value];
}

@end
