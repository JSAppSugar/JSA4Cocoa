//
//  JSAConvertor.h
//  JSA4Cocoa
//
//  Created by Neal on 2018/11/5.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSAConvertor : NSObject

+(id) js2ocWithReturnObject:(id) object;

+(id) js2ocWithParamObject:(id) object;

+(id) oc2jsWithObject:(id) object;

@end
