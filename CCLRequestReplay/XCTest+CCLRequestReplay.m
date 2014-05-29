//
//  XCTest+CCLRequestReplay.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <objc/runtime.h>
#import <XCTest/XCTest.h>
#import "CCLRequestReplayProtocol.h"

static CCLRequestReplayManager *_requestReplayManager;

@implementation XCTest (CCLRequestReplay)

+ (void)initialize {
    if (self == [XCTest class]) {
        Method setUp = class_getInstanceMethod(self, @selector(setUp));
        Method cclSetUp = class_getInstanceMethod(self, @selector(cclRequestReplay_setUp));
        method_exchangeImplementations(setUp, cclSetUp);

        Method tearDown = class_getInstanceMethod(self, @selector(tearDown));
        Method cclTearDown = class_getInstanceMethod(self, @selector(cclRequestReplay_tearDown));
        method_exchangeImplementations(tearDown, cclTearDown);
    }
}

- (CCLRequestReplayManager *)requestReplayManager {
    return _requestReplayManager;
}

- (void)cclRequestReplay_setUp {
    [self cclRequestReplay_setUp];
    _requestReplayManager = [[CCLRequestReplayManager alloc] init];
    [_requestReplayManager replay];
}

- (void)cclRequestReplay_tearDown {
    [self cclRequestReplay_tearDown];
    [_requestReplayManager stopReplay];
    _requestReplayManager = nil;
}

@end