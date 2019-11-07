//
//  TestOCObject.m
//  JSA4CocoaTests
//
//  Created by Neal on 2018/10/29.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "TestOCObject.h"

@implementation TestOCObject{
    NSString *_s;
    int _i;
}

+(SEL) loadSelectorWithName:(NSString *) selectorName{
    if([@"initWithString:Int:" isEqualToString:selectorName]){
        return @selector(initWithString:Int:);
    }
    else if([@"initWithNSDictionary:" isEqualToString:selectorName]){
        return @selector(initWithNSDictionary:);
    }
    else if([@"staticA" isEqualToString:selectorName]){
        return @selector(staticA);
    }
    else if([@"getS" isEqualToString:selectorName]){
        return @selector(getS);
    }
    else if([@"getI" isEqualToString:selectorName]){
        return @selector(getI);
    }
    else if([@"testNull:" isEqualToString:selectorName]){
        return @selector(testNull:);
    }
    else if([@"testString:" isEqualToString:selectorName]){
        return @selector(testString:);
    }
    else if([@"testInt:" isEqualToString:selectorName]){
        return @selector(testInt:);
    }
    else if([@"testBool:" isEqualToString:selectorName]){
        return @selector(testBool:);
    }
    else if([@"testMap:" isEqualToString:selectorName]){
        return @selector(testMap:);
    }
    else if([@"testArray:" isEqualToString:selectorName]){
        return @selector(testArray:);
    }
    else if([@"testObject:" isEqualToString:selectorName]){
        return @selector(testObject:);
    }
    else if([@"testJSAObject:" isEqualToString:selectorName]){
        return @selector(testJSAObject:);
    }
    else if([@"testJSAFunction:" isEqualToString:selectorName]){
        return @selector(testJSAFunction:);
    }
    
    return nil;
}

-(instancetype) init{
    return [self initWithString:@"-" Int:0];
}

-(instancetype) initWithString:(NSString *) s Int:(int) i{
    if(self = [super init]){
        _s = s;
        _i = i;
    }
    return self;
}
-(instancetype) initWithNSDictionary:(NSDictionary *) m{
    if(self = [super init]){
        _s = [m valueForKey:@"s"];
        _i = [[m valueForKey:@"o"] intValue];
    }
    return self;
}

+(NSString *) staticA{
    return @"a";
}

-(NSString *) getS{
    return _s;
}
-(int) getI{
    return _i;
}
-(id) testNull:(id) undefined{
    if(undefined == nil) {
        return nil;
    }
    return @"nil";
}
-(NSString *) testString:(NSString *) s{
    if(s!=nil && [s isKindOfClass:[NSString class]]){
        return s;
    }
    return nil;
}
-(int) testInt:(int) i{
    if( i!=0 ) {
        return i;
    }
    return 0;
}
-(BOOL) testBool:(BOOL) b{
    if(b) {
        return b;
    }
    return false;
}
-(NSDictionary *) testMap:(NSDictionary *) m{
    if( [m count]>0 ) {
        NSNumber *a = [m valueForKey:@"a"];
        NSString *b = [m valueForKey:@"b"];
        id o = [m valueForKey:@"o"];
        id<JSAFunction> f = [m valueForKey:@"f"];
        id<JSAObject> s = [m valueForKey:@"s"];
        if([a intValue] == 1
           && [b isEqualToString:@"1"]
           && [o isKindOfClass: TestOCObject.class]
           && [f conformsToProtocol: @protocol(JSAFunction)]
           && [s conformsToProtocol: @protocol(JSAObject)]
           ) {
            return m;
        }
    }
    return nil;
}
-(NSArray *)testArray:(NSArray *) array{
    if(array.count>0) {
        NSNumber *a = [array objectAtIndex:0];
        NSString *b = [array objectAtIndex:1];
        if([a intValue] == 1 && [b isEqualToString:@"1"]) {
            return array;
        }
    }
    return nil;
}
-(id) testObject:(id) o{
    if([o class] == [NSObject class]) {
        return o;
    }
    return nil;
}
-(id<JSAObject>) testJSAObject:(id<JSAObject>) jsaObject{
    if([jsaObject conformsToProtocol:@protocol(JSAObject)]) {
        NSString *a = [jsaObject invokeMethod:@"getA"];
        if([a isEqualToString:@"a"]) {
            return jsaObject;
        }
    }
    return nil;
}
-(id<JSAFunction>) testJSAFunction:(id<JSAFunction>) jsaFunc{
    NSString *r = [jsaFunc callWithArguments:@[@"f"]];
    if([r isEqualToString:@"f"]) {
        return jsaFunc;
    }
    return nil;
}

@end
