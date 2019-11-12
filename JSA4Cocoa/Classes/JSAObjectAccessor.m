//
//  JSAObjectAccessor.m
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/29.
//  Copyright (c) 2018 Neal. All rights reserved.
//

#import <objc/message.h>
#import "JSAObjectAccessor.h"
#import "JSAHelper.h"

@interface JSASel : NSObject

@property (nonatomic) SEL sel;

@end

@implementation JSASel

@end

@implementation JSAObjectAccessor

+(id) constructWithClass:(NSString *)className InitMethod:(NSString *) initMethod Arguments:(NSArray *)arguments{
    Class class = NSClassFromString(className);
    id newObject = [class alloc];
    return [JSAObjectAccessor invokeObject:newObject Method:initMethod Arguments:arguments];
}

+(id) invokeClass:(NSString *) className Method:(NSString *) method Arguments:(NSArray *)arguments{
    Class class = NSClassFromString(className);
    return [JSAObjectAccessor invokeObject:class Method:method Arguments:arguments];
}

static NSMutableDictionary* classSel = nil;

+(SEL) sel:(NSString*) selName OfClass:(Class )clz{
    if(classSel == nil){
        classSel = [NSMutableDictionary new];
    }
    NSString *clzName = NSStringFromClass(clz);
    NSMutableDictionary *clzMethods = [classSel valueForKey:clzName];
    if(clzMethods == nil){
        clzMethods = [NSMutableDictionary new];
        [classSel setValue:clzMethods forKey:clzName];
    }
    SEL sel = nil;
    JSASel *jsaSel = [clzMethods valueForKey:selName];
    if(jsaSel!=nil){
        sel = jsaSel.sel;
    }
    
    if(jsaSel == nil){
        unsigned int count;
        Method *methods = class_copyMethodList(clz, &count);
        for(int i=0;i<count;i++){
            Method method = methods[i];
            SEL asel = method_getName(method);
            NSString* name = NSStringFromSelector(asel);
            if([name isEqualToString:selName]){
                sel = asel;
                jsaSel = [JSASel new];
                jsaSel.sel = sel;
                [clzMethods setValue:jsaSel forKey:selName];
                break;
            }
        }
        free(methods);
    }
    
    return sel;
}

+(id) invokeObject:(id) object Method:(NSString *) method Arguments:(NSArray *)arguments{
    if(object == nil) return nil;
    Class class = [object class];
    if (class_isMetaClass(object_getClass(object))) {
        class = object;
        object = nil;
    }
    
    //SEL selector = NSSelectorFromString(method);
    SEL selector = [JSAObjectAccessor sel:method OfClass:class];
    
    NSMethodSignature *methodSignature;
    if(object){
        methodSignature = [class instanceMethodSignatureForSelector:selector];
    }else{
        methodSignature = [class methodSignatureForSelector:selector];
    }
    if(!methodSignature){
        _debugError([NSString stringWithFormat:@"unrecognized selector %@ send to %@", method, object]);
        return nil;
    }
    NSInvocation *invocation= [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:object?object:class];
    [invocation setSelector:selector];
    
    NSUInteger numberOfArguments = methodSignature.numberOfArguments;
    for (NSUInteger i = 2; i < numberOfArguments; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        id valObj = arguments[i-2];
        switch (argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
                
            #define ARGUMENT_CASE(_typeString, _type, _selector)\
                case _typeString: {\
                _type value = [valObj _selector];\
                [invocation setArgument:&value atIndex:i];\
                break;\
            }
            
            ARGUMENT_CASE('c', char, charValue)
            ARGUMENT_CASE('C', unsigned char, unsignedCharValue)
            ARGUMENT_CASE('s', short, shortValue)
            ARGUMENT_CASE('S', unsigned short, unsignedShortValue)
            ARGUMENT_CASE('i', int, intValue)
            ARGUMENT_CASE('I', unsigned int, unsignedIntValue)
            ARGUMENT_CASE('l', long, longValue)
            ARGUMENT_CASE('L', unsigned long, unsignedLongValue)
            ARGUMENT_CASE('q', long long, longLongValue)
            ARGUMENT_CASE('Q', unsigned long long, unsignedLongLongValue)
            ARGUMENT_CASE('f', float, floatValue)
            ARGUMENT_CASE('d', double, doubleValue)
            ARGUMENT_CASE('B', BOOL, boolValue)
            
            default:{
                if([valObj isKindOfClass: [NSNull class]]){
                    valObj = nil;
                }
                [invocation setArgument:&valObj atIndex:i];
                break;
            }
        }
    }
    
    [invocation invoke];
    
    const char *returnType = [methodSignature methodReturnType];
    id returnValue = nil;
    if(strncmp(returnType, "v", 1) != 0){
        if (strncmp(returnType, "@", 1) == 0) {
            void *result;
            [invocation getReturnValue:&result];
            returnValue = (__bridge id)result;
        }else{
            switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
                
                #define RETURN_CASE(_typeString, _type)\
                case _typeString: {\
                    _type temp;\
                    [invocation getReturnValue:&temp];\
                    returnValue = @(temp);\
                    break;\
                }
                    RETURN_CASE('c', char)
                    RETURN_CASE('C', unsigned char)
                    RETURN_CASE('s', short)
                    RETURN_CASE('S', unsigned short)
                    RETURN_CASE('i', int)
                    RETURN_CASE('I', unsigned int)
                    RETURN_CASE('l', long)
                    RETURN_CASE('L', unsigned long)
                    RETURN_CASE('q', long long)
                    RETURN_CASE('Q', unsigned long long)
                    RETURN_CASE('f', float)
                    RETURN_CASE('d', double)
                    RETURN_CASE('B', BOOL)
            }
        }
    }
    return returnValue;
}

@end
