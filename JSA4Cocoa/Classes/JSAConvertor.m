//
//  JSAConvertor.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/11/5.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "JSAConvertor.h"
#import "JSAObjectCocoa.h"
#import "JSAFunctionCocoa.h"

@implementation JSAConvertor

+(id) js2ocWithReturnJSValue:(JSValue *) jsValue{
    id value = nil;
    if([jsValue isObject]){
        JSValue* constructor = [jsValue valueForProperty:@"constructor"];
        NSString* className = constructor==nil?nil:[[constructor valueForProperty:@"name"] toString];
        if([@"JSAClass" isEqualToString:className]){
            if([jsValue hasProperty:@"$this"]){
                value = [[jsValue valueForProperty:@"$this"] toObject];
            }else{
                value = [[JSAObjectCocoa alloc] initWithJSValue:jsValue];
            }
        }else if ([@"Function" isEqualToString:className]){
            value = [[JSAFunctionCocoa alloc] initWithJSValue:jsValue];
        }else if([@"Object" isEqualToString:className]){
            value = [jsValue toObject];
            if([value isKindOfClass: NSDictionary.class]){
                NSMutableDictionary* newMap = [[NSMutableDictionary alloc]initWithDictionary:value];
                for(NSString* key in value){
                    JSValue* propertyJSvalue = [jsValue valueForProperty:key];
                    id ocValue = [JSAConvertor js2ocWithReturnJSValue:propertyJSvalue];
                    [newMap setValue:ocValue forKey:key];
                }
                value = newMap;
            }
        }else if([@"Array" isEqualToString:className]){
            NSArray* jsArray = [jsValue toArray];
            NSMutableArray* newArray = [[NSMutableArray alloc]initWithCapacity:jsArray.count];
            for(int i=0;i<jsArray.count;i++){
                JSValue* propertyJSvalue = [jsValue valueAtIndex: i];
                id ocValue = [JSAConvertor js2ocWithReturnJSValue:propertyJSvalue];
                [newArray addObject:ocValue];
            }
            value = newArray;
        }
        else{
            value = [jsValue toObject];
        }
    }else{
        value = [jsValue toObject];
    }
    if(value == nil || [value isKindOfClass: [NSNull class]]){
        return nil;
    }
    return value;
}

+(id) js2ocWithParamObject:(id) object Retrieve:(JSValue *) jsRetrieve{
    if(object == nil){
        return nil;
    }
    if([object isKindOfClass: [NSArray class]]){
        NSArray *array = (NSArray *)object;
        NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity: array.count];
        for(id value in array){
            [newArray addObject:[JSAConvertor js2ocWithParamObject: value Retrieve:jsRetrieve]];
        }
        return newArray;
    }
    if([object isKindOfClass:[NSDictionary class]]){
        NSString* oid = [object objectForKey:@"$id"];
        if(oid != nil){
            NSString *type = [object objectForKey:@"$type"];
            JSValue* jsObj = [jsRetrieve callWithArguments:@[oid]];
            if([type isEqualToString:@"object"]){
                return [[JSAObjectCocoa alloc] initWithJSValue:jsObj];
            }else if([type isEqualToString:@"function"]){
                return [[JSAFunctionCocoa alloc]initWithJSValue:jsObj];
            }
        }
        id this = [object objectForKey:@"$this"];
        if(this != nil){
            return this;
        }
        NSDictionary *map = object;
        NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] initWithCapacity:map.count];
        for(NSString* key in map){
            newDictionary[key] = [JSAConvertor js2ocWithParamObject: map[key] Retrieve:jsRetrieve];
        }
        return newDictionary;
    }
    return object;
}

+(id) oc2jsWithObject:(id) object{
    if(object == nil){
        return nil;
    }
    if([object isKindOfClass: [JSAObjectCocoa class]] || [object isKindOfClass: [JSAFunctionCocoa class]]){
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
