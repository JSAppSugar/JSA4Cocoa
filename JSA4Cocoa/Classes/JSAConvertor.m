//
//  JSAConvertor.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/11/5.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "JSAConvertor.h"

@implementation JSAConvertor

+(id) js2ocWithObject:(id) object Context:(JSContext *) context{
    if(object == nil){
        return nil;
    }
    if([object isKindOfClass: [NSNull class]]){
        return nil;
    }
    return object;
}

@end
