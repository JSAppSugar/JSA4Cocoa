//
//  JSAObjectCocoa.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/28.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "JSAObjectCocoa.h"

@implementation JSAObjectCocoa{
    JSValue *_jsValue;
}

-(instancetype) initWithJSValue:(JSValue *)value{
    if(self = [super init]){
        _jsValue = value;
    }
    return self;
}

-(id) invokeMethod:(NSString *)method{
    return [self invokeMethod:method Arguments:@[]];
}

-(id) invokeMethod:(NSString *)method Arguments:(NSArray *)arguments{
    return  [[_jsValue invokeMethod:method withArguments:arguments] toObject];
}

-(id<JSAWeakObject>) weakObject{
    return nil;
}

@end
