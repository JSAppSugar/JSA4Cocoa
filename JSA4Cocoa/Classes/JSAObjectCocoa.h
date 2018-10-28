//
//  JSAObjectCocoa.h
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/28.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSAppSugar.h"

@interface JSAObjectCocoa : NSObject<JSAObject>

-(id) initWithJSValue:(JSValue *)value;

@end
