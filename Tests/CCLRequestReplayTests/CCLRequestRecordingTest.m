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
});

SpecEnd
