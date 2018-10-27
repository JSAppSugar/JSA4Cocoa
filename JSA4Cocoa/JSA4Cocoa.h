//
//  JSA4Cocoa.h
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/23.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSAppSugar.h"
#import "DefaultJSClassLoader.h"

@interface JSA4Cocoa : NSObject<JSAppSugar>

-(void) startEngine;

@end

