//
//  XCTest+CCLRequestReplay.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCLRequestReplayManager.h"


/** An extension to XCTest to create and cleanup a request
 replay manager around your test cases. */
@interface XCTest (CCLRequestReplay)

/** Returns a request replay manager
 @note This manager only exists inside a test case, and is cleaned up afterwards.
 @return A request replay manager */
- (CCLRequestReplayManager *)requestReplayManager;

@end
