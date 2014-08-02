//
//  CCLRequestRecording.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The `CCLRequestRecordingProtocol` protocol is adopted by an object that
 can be used to replay a response or error for a matching NSURLRequest. */
@protocol CCLRequestRecordingProtocol <NSObject, NSSecureCoding>

/** A method to determine if the recording matches the supplied request
 @param request The NSURLRequest to compare
 @return YES if this recording matches the supplied request
 */
- (BOOL)matchesRequest:(NSURLRequest *)request;

/** A method which can return an error as a response to the given request.
 @param request The NSURLRequest
 @return An error or nil to instead return a response
 */
- (NSError *)errorForRequest:(NSURLRequest *)request;

/** A method which can return a response for the given request.
 @param request The request to respond to.
 @return A response, or nil if there was instead an error.
 */
- (NSURLResponse *)responseForRequest:(NSURLRequest *)request;

/** A method which can optionally return the HTTP body for the given request.
 @param request The request to respond to.
 @return The data, or nil if there is not a HTTP body for the response.
 */
- (NSData *)dataForRequest:(NSURLRequest *)request;

@end

/// An implementation of the CCLRequestRecordingProtocol protocol
@interface CCLRequestRecording : NSObject <CCLRequestRecordingProtocol>

/** Initialize a request recording with a request and a response.
 @param request The request to match
 @param response The response to replay
 @param data Optional HTTP Body data to replay
 @return A request recording
 */
- (instancetype)initWithRequest:(NSURLRequest *)request response:(NSURLResponse *)response data:(NSData *)data;

/** Initialize a request recording with a request and an error.
 @param request The request to match
 @param error An error to replay for the matching request
 @return A request recording
 */
- (instancetype)initWithRequest:(NSURLRequest *)request error:(NSError *)error;

/** Returns a Boolean value that indicates whether a given recording is equal to the receiver.
 @param recording The recording with which to compare the receiver.
 @return YES if the recording is equal to the receiver.
 */
- (BOOL)isEqualToRecording:(CCLRequestRecording *)recording;

/** The request to match, required. */
@property (nonatomic, copy, readonly) NSURLRequest *request;

/** The response to replay, may be nil if this is an erroring response. */
@property (nonatomic, copy, readonly) NSURLResponse *response;

/** The response data to replay, may be nil. */
@property (nonatomic, copy, readonly) NSData *data;

/** An error to replay if there is no response. */
@property (nonatomic, copy, readonly) NSError *error;

@end
