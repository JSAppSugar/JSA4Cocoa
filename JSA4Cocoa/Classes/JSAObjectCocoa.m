//
//  JSAObjectCocoa.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/28.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "JSAObjectCocoa.h"
#import "JSAConvertor.h"

@implementation JSAObjectCocoa{
    JSValue *_jsValue;
}

-(instancetype) initWithJSValue:(JSValue *)value{
    if(self = [super init]){
        _jsValue = value;
    }
    return self;
}

-(JSValue *) jsValue{
    return _jsValue;
}

-(id) invokeMethod:(NSString *)method{
    return [self invokeMethod:method Arguments:@[]];
}

-(id) invokeMethod:(NSString *)method Arguments:(NSArray *)arguments{
    arguments = [JSAConvertor oc2jsWithObject:arguments];
    JSValue* value = [_jsValue invokeMethod:method withArguments:arguments];
    return [JSAConvertor js2ocWithReturnJSValue:value];
}

-(id<JSAWeakObject>) weakObject{
    return nil;
}

@end
