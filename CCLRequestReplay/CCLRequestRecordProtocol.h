//
//  CCLRequestRecordProtocol.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLRequestReplayManager.h"


@interface CCLRequestRecordProtocol : NSURLProtocol

@end

/** An extension to CCLRequestReplayManager to add support for recording
 requests and responses from real NSURLProtocol connections */
@interface CCLRequestReplayManager (Record)

/// Start recording all NSURLProtocol connections
- (void)record;

/// Stop recording NSURLProtocol connections
- (void)stopRecording;

@end
