//
//  CCLRequestReplayManager.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import "CCLRequestReplayManager.h"
#import "CCLRequestRecording.h"
#import "CCLRequestReplayProtocol.h"


@interface CCLRequestReplayManager () {
    NSMutableArray *_recordings;
}

@end

@implementation CCLRequestReplayManager

- (instancetype)init {
    if (self = [super init]) {
        _recordings = [NSMutableArray new];
    }

    return self;
}

- (NSArray *)recordings {
    return [_recordings copy];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _recordings = [[aDecoder decodeObjectOfClass:[NSArray class] forKey:@"recordings"] mutableCopy];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self.recordings copy] forKey:@"recordings"];
}

#pragma mark - Managing recordings

- (void)addRecording:(id<CCLRequestRecordingProtocol>)recording {
    [_recordings addObject:recording];
}

- (void)removeRecording:(id<CCLRequestRecordingProtocol>)recording {
    [_recordings removeObject:recording];
}

- (void)removeAllRecordings {
    [_recordings removeAllObjects];
}

#pragma mark - Adding a recording for a request/response

- (CCLRequestRecording *)addRequest:(NSURLRequest *)request response:(NSURLResponse *)response data:(NSData *)data {
    CCLRequestRecording *recording = [[CCLRequestRecording alloc] initWithRequest:request response:response data:data];
    [self addRecording:recording];
    return recording;
}

- (CCLRequestRecording *)addRequest:(NSURLRequest *)request error:(NSError *)error {
    CCLRequestRecording *recording = [[CCLRequestRecording alloc] initWithRequest:request error:error];
    [self addRecording:recording];
    return recording;
}

@end

@implementation CCLRequestReplayManager (Convenience)

- (CCLRequestRecording *)addRequest:(NSURLRequest *)request responseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers contentType:(NSString *)contentType content:(NSData *)content {
    if (contentType && headers[@"Content-Type"] == nil) {
        NSMutableDictionary *mutableHeaders = headers ? [headers mutableCopy] : [NSMutableDictionary dictionary];
        mutableHeaders[@"Content-Type"] = contentType;
        headers = [mutableHeaders copy];
    }

    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:statusCode HTTPVersion:@"1.1" headerFields:headers];
    return [self addRequest:request response:response data:content];
}

- (CCLRequestRecording *)addRequest:(NSURLRequest *)request JSONResponseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers content:(id)content {
    NSData *data;

    if (content) {
        data = [NSJSONSerialization dataWithJSONObject:content options:0 error:NULL];
    }

    return [self addRequest:request responseWithStatusCode:statusCode headers:headers contentType:@"application/json; charset=utf8" content:data];
}

@end
