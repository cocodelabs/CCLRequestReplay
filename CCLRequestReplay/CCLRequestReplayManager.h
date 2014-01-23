//
//  CCLRequestReplayManager.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CCLRequestRecording;

@interface CCLRequestReplayManager : NSObject

- (NSArray *)recordings;

- (void)addRecording:(CCLRequestRecording *)recording;
- (void)addRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data;
- (void)addRequest:(NSURLRequest *)request error:(NSError *)error;

- (void)removeRecording:(CCLRequestRecording *)recording;
- (void)removeAllRecordings;

- (void)replay;

@end
