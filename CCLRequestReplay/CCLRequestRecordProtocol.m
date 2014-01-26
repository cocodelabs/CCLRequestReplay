//
//  CCLRequestRecordProtocol.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import "CCLRequestRecordProtocol.h"
#import "CCLRequestReplayManager.h"
#import "CCLRequestRecording.h"


@interface CCLRequestRecordProtocol () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;

@end


static NSString * const CCLRequestRecordProtocolIsRecordingKey = @"CCLRequestRecordProtocolIsRecordingKey";

@implementation CCLRequestRecordProtocol

static NSMutableSet *_managers;

+ (void)addManager:(CCLRequestReplayManager *)manager {
    if (_managers == nil) {
        [NSURLProtocol registerClass:[CCLRequestRecordProtocol class]];
        _managers = [NSMutableSet new];
    }

    [_managers addObject:manager];
}

+ (void)removeManager:(CCLRequestReplayManager *)manager {
    [_managers removeObject:manager];

    if (_managers && [_managers count] == 0) {
        [NSURLProtocol unregisterClass:[CCLRequestRecordProtocol class]];
        _managers = nil;
    }
}

+ (void)addRecording:(CCLRequestRecording *)recording {
    if (_managers) {
        for (CCLRequestReplayManager *manager in _managers) {
            [manager addRecording:recording];
        }
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return ![[self propertyForKey:CCLRequestRecordProtocolIsRecordingKey inRequest:request] boolValue];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSMutableURLRequest *request = [[self request] mutableCopy];
    [[self class] setProperty:@YES forKey:CCLRequestRecordProtocolIsRecordingKey inRequest:request];

    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)stopLoading {
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate(s)

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    CCLRequestRecording *recording = [[CCLRequestRecording alloc] initWithRequest:[self request] error:error];
    [[self class] addRecording:recording];

    [[self client] URLProtocol:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = response;
    self.data = [[NSMutableData alloc] init];

    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    CCLRequestRecording *recording = [[CCLRequestRecording alloc] initWithRequest:self.request response:self.response data:[self.data copy]];
    [[self class] addRecording:recording];

    [[self client] URLProtocolDidFinishLoading:self];
}

@end

@implementation CCLRequestReplayManager (Recording)

- (void)record {
    [CCLRequestRecordProtocol addManager:self];
}

- (void)stopRecording {
    [CCLRequestRecordProtocol removeManager:self];
}

@end
