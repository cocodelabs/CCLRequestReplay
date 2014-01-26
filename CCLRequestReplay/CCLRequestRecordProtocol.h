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

@interface CCLRequestReplayManager (Record)

- (void)record;
- (void)stopRecording;

@end
