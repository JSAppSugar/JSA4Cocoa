//
//  JSAConvertor.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/11/5.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "JSAConvertor.h"
#import "JSAObjectCocoa.h"

@implementation JSAConvertor

+(id) js2ocWithObject:(id) object{
    if(object == nil){
        return nil;
    }
    if([object isKindOfClass: [NSNull class]]){
        return nil;
    }
    return object;
}

+(id) oc2jsWithObject:(id) object{
    if(object == nil){
        return nil;
    }
    if([object isKindOfClass: [JSAObjectCocoa class]]){
        return [object jsValue];
    }
    if([object isKindOfClass: [NSArray class]]){
        NSArray *array = (NSArray *)object;
        NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity: array.count];
        for(id value in array){
            [newArray addObject:[JSAConvertor oc2jsWithObject: value]];
        }
        return newArray;
    }
    return object;
}

@end
