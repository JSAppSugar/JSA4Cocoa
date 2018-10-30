//
//  JSAHelper.h
//  JSA4Cocoa
//
//  Created by Neal on 2018/10/29.
//  Copyright (c) 2018 Neal. All rights reserved.
//

static void (^_debugError)(NSString *log) = ^void(NSString *log) {
    NSCAssert(FALSE, log);
};
