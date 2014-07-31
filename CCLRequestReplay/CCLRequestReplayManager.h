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

/** Add a recording to the managers recordings
 @param recording The recording to add
 */
- (void)addRecording:(id<CCLRequestRecordingProtocol>)recording;

/** A convinience method to add a recording by supplying a request, response and data.
 @param request The request to match
 @param response The response to replay when the request matches
 @param data The HTTP body for the response
 */
- (void)addRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data;

/** A convinience method to add a recording by supplying a request which results in an error.
 @param request The request to match
 @param error The error to replay when the request matches
 */
- (void)addRequest:(NSURLRequest *)request error:(NSError *)error;

/** Remove a recording from the replay manager
 @param recording The recording to remove from the replay manager
 */
- (void)removeRecording:(id<CCLRequestRecordingProtocol>)recording;

/// Remove every registered recording on the replay manager
- (void)removeAllRecordings;

@end
