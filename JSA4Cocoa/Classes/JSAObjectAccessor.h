//
//  JSAObjectAccessor.h
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/29.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSAObjectAccessor : NSObject

+(id) constructWithClass:(NSString *)className InitMethod:(NSString *) initMethod Arguments:(NSArray *)arguments;

+(id) invokeObject:(id) object Method:(NSString *) method Arguments:(NSArray *)arguments;

@end
