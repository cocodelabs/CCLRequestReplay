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
#import <CCLRequestReplay/CCLRequestReplayProtocol.h>


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
        NSURLRequest *requestA = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://testA.com"]];
        NSURLRequest *requestB = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://testB.com"]];
        NSError *error = [[NSError alloc] init];

        CCLRequestReplayManager *sut = [[CCLRequestReplayManager alloc] init];
        [sut addRequest:requestA error:error];
        [sut addRequest:requestB error:error];

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

    it(@"should register a protocol for replaying", ^{
        NSURL *URL = [NSURL URLWithString:@"ccl://cocode.org/test"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"1.1" headerFields:@{}];
        NSData *data = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];

        CCLRequestReplayManager *sut = [[CCLRequestReplayManager alloc] init];
        [sut addRequest:request response:response data:data];
        [sut replay];

        expect([NSURLConnection canHandleRequest:request]).to.beTruthy();

        [sut stopReplay];
    });

    it(@"should support secure encoding", ^{
        expect([CCLRequestReplayManager supportsSecureCoding]).to.beTruthy();
    });

    it(@"should should encode and decode a manager", ^{
        CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];
        [manager addRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test/"]] error:nil];

        NSData *archivedManager = [NSKeyedArchiver archivedDataWithRootObject:manager];
        CCLRequestReplayManager *unarchivedManager = [NSKeyedUnarchiver unarchiveObjectWithData:archivedManager];

        expect([manager recordings]).to.equal([unarchivedManager recordings]);
    });
});

SpecEnd
