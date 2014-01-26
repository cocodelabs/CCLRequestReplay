//
//  CCLRequestRecording.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import "CCLRequestRecording.h"


@implementation CCLRequestRecording

- (instancetype)initWithRequest:(NSURLRequest *)request response:(NSURLResponse *)response data:(NSData *)data {
    if (self = [super init]) {
        _request = request;
        _response = response;
        _data = data;
    }

    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request error:(NSError *)error {
    if (self = [super init]) {
        _request = request;
        _error = error;
    }

    return self;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    return (self == object) || ([object isKindOfClass:[self class]] && [self isEqualToRecording:object]);
}

- (BOOL)isEqualToRecording:(CCLRequestRecording *)recording {
    return [self.request isEqual:recording.request] &&
        ((!self.error && !recording.error) || [self.error isEqual:recording.error]) &&
        ((!self.response && !recording.response) || [self.response isEqual:recording.response]) &&
        ((!self.data && !recording.data) || [self.data isEqual:recording.data]);
}

- (NSUInteger)hash {
    return [self.request hash];
}

#pragma mark - Matching

- (BOOL)matchesRequest:(NSURLRequest *)request {
    return [[[self request] URL] isEqual:[request URL]] && [[[self request] HTTPMethod] isEqualToString:[request HTTPMethod]];
}

#pragma mark - Error

- (NSError *)errorForRequest:(NSURLRequest *)request {
    return [self error];
}

#pragma mark - Response + Data

- (NSURLResponse *)responseForRequest:(NSURLRequest *)request {
    return [self response];
}

- (NSData *)dataForRequest:(NSURLRequest *)request {
    return [self data];
}

@end
