//
//  CCLRequestReplayProtocolTest.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2014 Cocode LTD. All rights reserved.
//

#define EXP_SHORTHAND YES

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <CCLRequestReplay/CCLRequestReplayProtocol.h>
#import <CCLRequestReplay/CCLRequestRecording.h>
#import <CCLRequestReplay/CCLRequestReplayManager.h>


SpecBegin(CCLRequestReplayProtocol)

describe(@"CCLRequestReplayProtocol", ^{
    it(@"should inherit from NSURLProtocol", ^{
        expect([[CCLRequestReplayProtocol alloc] init]).to.beKindOf([NSURLProtocol class]);
    });

    it(@"should init with matching request", ^{
        CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];

        NSURL *URL = [NSURL URLWithString:@"http://cocode.org/test"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:201 HTTPVersion:@"1.1" headerFields:@{}];
        [manager addRequest:request response:response data:nil];

        [CCLRequestReplayProtocol setManager:manager];

        expect([CCLRequestReplayProtocol canInitWithRequest:request]).to.beTruthy();
    });

    it(@"should canonicalize request", ^{
        NSURLRequest *request = [[NSURLRequest alloc] init];
        NSURLRequest *cannonicalizedRequest = [CCLRequestReplayProtocol canonicalRequestForRequest:request];
        expect(cannonicalizedRequest).notTo.beNil();
    });

    it(@"should replay response for matching request", ^{
        CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];

        NSURL *badURL = [NSURL URLWithString:@"http://cocode.org/badTest"];
        NSURLRequest *badRequest = [[NSURLRequest alloc] initWithURL:badURL];
        NSHTTPURLResponse *badResponse = [[NSHTTPURLResponse alloc] initWithURL:badURL statusCode:201 HTTPVersion:@"1.1" headerFields:@{}];
        [manager addRequest:badRequest response:badResponse data:nil];

        NSURL *URL = [NSURL URLWithString:@"http://cocode.org/test"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:201 HTTPVersion:@"1.1" headerFields:@{}];
        [manager addRequest:request response:response data:nil];

        [CCLRequestReplayProtocol setManager:manager];

        OCMockObject<NSURLProtocolClient> *client = [OCMockObject mockForProtocol:@protocol(NSURLProtocolClient)];
        CCLRequestReplayProtocol *protocol = [[CCLRequestReplayProtocol alloc] initWithRequest:request cachedResponse:nil client:client];
        [[client expect] URLProtocol:protocol didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[client expect] URLProtocolDidFinishLoading:protocol];

        [protocol startLoading];

        [client verify]; 
    });

    it(@"should replay error for matching request", ^{
        CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];

        NSURL *badURL = [NSURL URLWithString:@"http://cocode.org/badTest"];
        NSURLRequest *badRequest = [[NSURLRequest alloc] initWithURL:badURL];
        NSHTTPURLResponse *badResponse = [[NSHTTPURLResponse alloc] initWithURL:badURL statusCode:201 HTTPVersion:@"1.1" headerFields:@{}];
        [manager addRequest:badRequest response:badResponse data:nil];

        NSURL *URL = [NSURL URLWithString:@"http://cocode.org/test"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        NSError *error = [NSError errorWithDomain:@"Failure" code:200 userInfo:nil];
        [manager addRequest:request error:error];

        [CCLRequestReplayProtocol setManager:manager];

        OCMockObject<NSURLProtocolClient> *client = [OCMockObject mockForProtocol:@protocol(NSURLProtocolClient)];
        CCLRequestReplayProtocol *protocol = [[CCLRequestReplayProtocol alloc] initWithRequest:request cachedResponse:nil client:client];
        [[client expect] URLProtocol:protocol didFailWithError:error];

        [protocol startLoading];

        [client verify]; 
    });
});

SpecEnd
