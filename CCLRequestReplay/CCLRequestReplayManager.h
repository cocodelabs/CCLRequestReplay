//
//  CCLRequestReplayManager.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLRequestRecording.h"

/** `CCLRequestReplayManager` is a class to manage request recordings
 and allow you to record or replay recordings.
 */
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
 @return Returns the created recording that was added to the receiver
 */
- (CCLRequestRecording *)addRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data;

/** A convinience method to add a recording by supplying a request which results in an error.
 @param request The request to match
 @param error The error to replay when the request matches
 @return Returns the created recording that was added to the receiver
 */
- (CCLRequestRecording *)addRequest:(NSURLRequest *)request error:(NSError *)error;

/** Remove a recording from the replay manager
 @param recording The recording to remove from the replay manager
 */
- (void)removeRecording:(id<CCLRequestRecordingProtocol>)recording;

/// Remove every registered recording on the replay manager
- (void)removeAllRecordings;

@end

@interface CCLRequestReplayManager (Convenience)

/** A convenience method to add a recording with a HTTP response.
 @param request The request to match
 @param statusCode The status code for the HTTP response
 @param headers Optional headers for the HTTP response
 @param contentType The content type for the HTTP response if there is content
 @param content The HTTP body for the HTTP response
 @return Returns the created recording that was added to the receiver
 */
- (CCLRequestRecording *)addRequest:(NSURLRequest *)request responseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers contentType:(NSString *)contentType content:(NSData *)content;

/** A convenience method to add a recording with a HTTP response with a JSON payload.
 @param request The request to match
 @param statusCode The status code for the HTTP response
 @param headers Optional headers for the HTTP response
 @param content The content to be JSON encoded
 @return Returns the created recording that was added to the receiver
 */
- (CCLRequestRecording *)addRequest:(NSURLRequest *)request JSONResponseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers content:(id)content;

@end
