//
//  CCLRequestReplayManager.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLRequestRecording.h"


@interface CCLRequestReplayManager : NSObject <NSSecureCoding>

/** Returns an array of all registered recordings. */
- (NSArray *)recordings;

- (void)addRecording:(id<CCLRequestRecordingProtocol>)recording;
- (void)addRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data;
- (void)addRequest:(NSURLRequest *)request error:(NSError *)error;

- (void)removeRecording:(id<CCLRequestRecordingProtocol>)recording;
- (void)removeAllRecordings;

@end
