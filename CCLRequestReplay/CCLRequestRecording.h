//
//  CCLRequestRecording.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CCLRequestRecordingProtocol <NSObject, NSSecureCoding>

- (BOOL)matchesRequest:(NSURLRequest *)request;

- (NSError *)errorForRequest:(NSURLRequest *)request;

- (NSURLResponse *)responseForRequest:(NSURLRequest *)request;
- (NSData *)dataForRequest:(NSURLRequest *)request;

@end

@interface CCLRequestRecording : NSObject <CCLRequestRecordingProtocol>

- (instancetype)initWithRequest:(NSURLRequest *)request response:(NSURLResponse *)response data:(NSData *)data;
- (instancetype)initWithRequest:(NSURLRequest *)request error:(NSError *)error;

- (BOOL)isEqualToRecording:(CCLRequestRecording *)recording;

@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSURLResponse *response;
@property (nonatomic, copy, readonly) NSData *data;
@property (nonatomic, copy, readonly) NSError *error;

@end
