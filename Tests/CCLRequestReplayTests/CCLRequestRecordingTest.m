//
//  CCLRequestRecordingTest.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 26/01/2014.
//  Copyright (c) 2014 Cocode LTD. All rights reserved.
//

#define EXP_SHORTHAND YES

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import <CCLRequestReplay/CCLRequestRecording.h>


SpecBegin(CCLRequestRecording)

describe(@"CCLRequestRecording", ^{
    it(@"should conform to CCLRequestRecordingProtocol", ^{
        expect([[CCLRequestRecording alloc] init]).to.conformTo(@protocol(CCLRequestRecordingProtocol));
    });

    it(@"should should match for a URL", ^{
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://test.com/"]];
        CCLRequestRecording *recording = [[CCLRequestRecording alloc] initWithRequest:request error:nil];

        expect([recording matchesRequest:request]).to.beTruthy();
    });

    it(@"shouldn't match when method is different", ^{
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://test.com/"]];
        CCLRequestRecording *recording = [[CCLRequestRecording alloc] initWithRequest:request error:nil];

        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest setHTTPMethod:@"POST"];

        expect([recording matchesRequest:mutableRequest]).to.beFalsy();
    });

    it(@"should compare two recordings with same request and error as the same", ^{
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://test.com/"]];
        NSError *error = [NSError errorWithDomain:@"ErrorDomain" code:0 userInfo:nil];

        CCLRequestRecording *recordingA = [[CCLRequestRecording alloc] initWithRequest:request error:error];
        CCLRequestRecording *recordingB = [[CCLRequestRecording alloc] initWithRequest:request error:error];

        expect([recordingA isEqualToRecording:recordingB]).to.beTruthy();
    });

    it(@"should compare two recordings with same request, response and data as the same", ^{
        NSURL *URL = [NSURL URLWithString:@"http://test.com/"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"1.1" headerFields:@{}];
        NSData *data = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];

        CCLRequestRecording *recordingA = [[CCLRequestRecording alloc] initWithRequest:request response:response data:data];
        CCLRequestRecording *recordingB = [[CCLRequestRecording alloc] initWithRequest:request response:response data:data];

        expect([recordingA isEqualToRecording:recordingB]).to.beTruthy();
    });

    it(@"should hash two recordings with identical request and error with as the same hash", ^{
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://test.com/"]];
        NSError *error = [NSError errorWithDomain:@"ErrorDomain" code:0 userInfo:nil];

        CCLRequestRecording *recordingA = [[CCLRequestRecording alloc] initWithRequest:request error:error];
        CCLRequestRecording *recordingB = [[CCLRequestRecording alloc] initWithRequest:request error:error];

        expect([recordingA hash]).to.equal([recordingB hash]);
    });

    it(@"should hash two recordings with identical request and error with as the same hash", ^{
        NSURL *URL = [NSURL URLWithString:@"http://test.com/"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"1.1" headerFields:@{}];
        NSData *data = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];

        CCLRequestRecording *recordingA = [[CCLRequestRecording alloc] initWithRequest:request response:response data:data];
        CCLRequestRecording *recordingB = [[CCLRequestRecording alloc] initWithRequest:request response:response data:data];

        expect([recordingA hash]).to.equal([recordingB hash]);
    });

    it(@"should should support secure coding", ^{
        expect([CCLRequestRecording supportsSecureCoding]).to.beTruthy();
    });

    it(@"should be able to encode and decode", ^{
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://test.com/"]];
        CCLRequestRecording *recording = [[CCLRequestRecording alloc] initWithRequest:request error:nil];
        NSData *archivedRecording = [NSKeyedArchiver archivedDataWithRootObject:recording];
        CCLRequestRecording *unarchivedRecording = [NSKeyedUnarchiver unarchiveObjectWithData:archivedRecording];

        expect([recording isEqualToRecording:unarchivedRecording]).to.beTruthy();
    });
});

SpecEnd
