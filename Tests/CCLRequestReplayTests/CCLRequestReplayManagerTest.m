//
//  CCLRequestReplayManagerTest.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2014 Cocode LTD. All rights reserved.
//

#define EXP_SHORTHAND YES

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import <CCLRequestReplay/CCLRequestReplayManager.h>
#import <CCLRequestReplay/CCLRequestRecording.h>


SpecBegin(CLRequestReplayManager)

describe(@"CLRequestReplayManager", ^{
    it(@"should not have any recordings by default", ^{
        CCLRequestReplayManager *sut = [[CCLRequestReplayManager alloc] init];
        expect([[sut recordings] count]).to.equal(0);
    });

    it(@"should be able to register a request with a response", ^{
        NSURLRequest *request = [[NSURLRequest alloc] init];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
        NSData *data = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];

        CCLRequestReplayManager *sut = [[CCLRequestReplayManager alloc] init];
        [sut addRequest:request response:response data:data];

        CCLRequestRecording *urlResponse = [[sut recordings] firstObject];
        expect([urlResponse request]).to.equal(request);
        expect([urlResponse response]).to.equal(response);
        expect([urlResponse data]).to.equal(data);
        expect([urlResponse error]).to.beNil();
    });

    it(@"should be able to register a request with an error", ^{
        NSURLRequest *request = [[NSURLRequest alloc] init];
        NSError *error = [[NSError alloc] init];

        CCLRequestReplayManager *sut = [[CCLRequestReplayManager alloc] init];
        [sut addRequest:request error:error];

        CCLRequestRecording *urlResponse = [[sut recordings] firstObject];
        expect([urlResponse request]).to.equal(request);
        expect([urlResponse response]).to.beNil();
        expect([urlResponse data]).to.beNil();
        expect([urlResponse error]).to.equal(error);
    });

    it(@"should be able to remove a recording", ^{
        NSURLRequest *request = [[NSURLRequest alloc] init];
        NSError *error = [[NSError alloc] init];

        CCLRequestReplayManager *sut = [[CCLRequestReplayManager alloc] init];
        [sut addRequest:request error:error];
        [sut addRequest:request error:error];

        [sut removeRecording:[[sut recordings] firstObject]];

        expect([[sut recordings] count]).to.equal(1);
    });

    it(@"should be able to remove all recordings", ^{
        NSURLRequest *request = [[NSURLRequest alloc] init];
        NSError *error = [[NSError alloc] init];

        CCLRequestReplayManager *sut = [[CCLRequestReplayManager alloc] init];
        [sut addRequest:request error:error];
        [sut addRequest:request error:error];

        [sut removeAllRecordings];

        expect([[sut recordings] count]).to.equal(0);
    });

//    it(@"should register a protocol for replaying", ^{
//        NSURL *URL = [NSURL URLWithString:@"ccl://cocode.org/test"];
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
//        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"1.1" headerFields:@{}];
//        NSData *data = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];
//
//        CCLRequestReplayManager *sut = [[CCLRequestReplayManager alloc] init];
//        [sut addRequest:request response:response data:data];
//        [sut replay];
//
//        NSError *error;
//        NSURLResponse *outResponse;
//        NSData *outData = [NSURLConnection sendSynchronousRequest:request returningResponse:&outResponse error:&error];
//
//        expect(error).to.beNil();
//        expect(outResponse).to.equal(response);
//        expect(outData).to.equal(data);
//    });
});

SpecEnd
