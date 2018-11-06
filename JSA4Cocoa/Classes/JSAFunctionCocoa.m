//
//  JSAFunctionCocoa.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/11/6.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "JSAFunctionCocoa.h"
#import "JSAConvertor.h"
#import "JSAObjectCocoa.h"

@implementation JSAFunctionCocoa{
    JSValue *_jsValue;
    JSValue *js_function_apply;
}

-(instancetype) initWithJSValue:(JSValue *)value{
    if(self = [super init]){
        _jsValue = value;
        JSContext *context = [_jsValue context];
        js_function_apply = context[@"$js_function_apply"];
    }
    return self;
}

-(JSValue *) jsValue{
    return _jsValue;
}

-(id) call{
    return [self callWithArguments:@[]];
}

-(id) callWithArguments:(NSArray *)arguments{
    arguments = [JSAConvertor oc2jsWithObject:arguments];
    JSValue* value = [_jsValue callWithArguments:arguments];
    return [JSAConvertor js2ocWithReturnJSValue:value];
}

- (id)applyWithObject:(id<JSAObject>)thisObject {
    return [self applyWithObject:nil Arguments:@[]];
}


- (id)applyWithObject:(id<JSAObject>)thisObject Arguments:(NSArray *)arguments {
    arguments = [JSAConvertor oc2jsWithObject:arguments];
    id _this = [NSNull null];
    if([thisObject isKindOfClass: [JSAObjectCocoa class]]){
        _this = [(JSAObjectCocoa *)thisObject jsValue];
    }
    JSValue* value = [js_function_apply callWithArguments:@[_this,_jsValue,arguments]];
    return [JSAConvertor js2ocWithReturnJSValue:value];
}



@end
