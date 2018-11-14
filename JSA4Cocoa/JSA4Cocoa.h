//
//  JSA4Cocoa.h
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/23.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSAppSugar.h"
#import "JSAClassLoader.h"

@interface JSA4Cocoa : NSObject<JSAppSugar>

/*!
 @method
 @abstract Add a JS class loader that you implement on your own.
 @param loader A implementation of JSClassLoader.
 */
-(void) addJSClassLoader:(id<JSAClassLoader>) loader;

/*!
 @method
 @abstract start engine
 */
-(void) startEngine;

/*!
 @method
 @abstract Start engine with given JSClassLoader
 @param loader A implementation of JSClassLoader.
 */
-(void) startEngineWithLoader:(id<JSAClassLoader>) loader;

@end

