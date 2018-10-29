//
//  TestOCObject.m
//  JSA4CocoaTests
//
//  Created by Neal on 2018/10/29.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import "TestOCObject.h"

@implementation TestOCObject{
    NSString *_a;
}

-(instancetype) init{
    return [self initWithA:@"-"];
}

-(instancetype) initWithA:(NSString *) a{
    if(self = [super init]){
        _a = a;
    }
    return self;
}

-(NSString *) a{
    return _a;
}

@end
