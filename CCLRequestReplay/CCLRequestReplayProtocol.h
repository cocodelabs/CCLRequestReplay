//
//  CCLRequestReplayProtocol.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLRequestReplayManager.h"


@interface CCLRequestReplayProtocol : NSURLProtocol

@end

/** An extension to CCLRequestReplayManager to add support for
 replaying recording requests and responses when any matching
 request is made using NSURLProtocol. */
@interface CCLRequestReplayManager (Replay)

/// Start re-playing matching requests made using NSURLProtocol
- (void)replay;

/// Stop re-playing matching requests
- (void)stopReplay;

@end

