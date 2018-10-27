//
//  DefaultJSClassLoader.h
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/27.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSClassLoader <NSObject>

-(NSString *) loadJSClassWithName:(NSString *) className;

@end

@interface DefaultJSClassLoader : NSObject<JSClassLoader>

-(id) initWithNSBundle:(NSBundle *) bundle;

@end
