//
//  DefaultJSClassLoader.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/27.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "DefaultJSClassLoader.h"

@implementation DefaultJSClassLoader{
    NSBundle *_bundle;
}

-(instancetype) init{
    if(self = [super init]){
        _bundle = [NSBundle mainBundle];
    }
    return self;
}

-(instancetype) initWithNSBundle:(NSBundle *) bundle{
    if(self = [super init]){
        _bundle = bundle;
    }
    return self;
}

-(NSString *) loadJSClassWithName:(NSString *) className{
    NSString *name = className;
    NSString *classFilePath = [className stringByReplacingOccurrencesOfString:@"." withString:@"/"];
    NSRange range = [classFilePath rangeOfString:@"/?[\\w\\-]+$" options:NSRegularExpressionSearch];
    NSString *directory = @"";
    if(range.location>0 && range.length>0){
        directory = [classFilePath substringWithRange: NSMakeRange(0, range.location)];
        name = [classFilePath substringFromIndex: range.location+1];
    }
    classFilePath = [_bundle pathForResource:name ofType:@"js" inDirectory:directory];
    return [NSString stringWithContentsOfFile:classFilePath encoding:NSUTF8StringEncoding error:nil];
}

@end
