//
//  JSAFunctionCocoa.h
//  JSA4Cocoa
//
//  Created by Neal on 2018/11/6.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSAppSugar.h"

@interface JSAFunctionCocoa : NSObject<JSAFunction>

-(instancetype) initWithJSValue:(JSValue *)value;

-(JSValue *) jsValue;

@end
