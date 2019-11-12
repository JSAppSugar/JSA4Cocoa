//
//  TestOCObject.h
//  JSA4CocoaTests
//
//  Created by Neal on 2018/10/29.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSA4Cocoa/JSA4Cocoa.h>

@interface TestOCObject : NSObject

+(NSString *) staticA;

-(NSString *) staticA;

-(instancetype) initWithString:(NSString *) s Int:(int) i;
-(instancetype) initWithNSDictionary:(NSDictionary *) m;

-(NSString *) getS;
-(int) getI;
-(id) testNull:(id) undefined;
-(NSString *) testString:(NSString *) s;
-(int) testInt:(int) i;
-(BOOL) testBool:(BOOL) b;
-(NSDictionary *) testMap:(NSDictionary *) m;
-(NSArray *)testArray:(NSArray *) array;
-(id) testObject:(id) o;
-(id<JSAObject>) testJSAObject:(id<JSAObject>) jsaObject;
-(id<JSAFunction>) testJSAFunction:(id<JSAFunction>) func;

@end

