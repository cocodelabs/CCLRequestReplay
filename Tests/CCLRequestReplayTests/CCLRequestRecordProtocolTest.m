//
//  CCLRequestRecordProtocol.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 26/01/2014.
//  Copyright (c) 2014 Cocode LTD. All rights reserved.
//

#define EXP_SHORTHAND YES

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import <CCLRequestReplay/CCLRequestRecordProtocol.h>
#import <CCLRequestReplay/CCLRequestReplayProtocol.h>


SpecBegin(CCLRequestHTTPRecordProtocol)

describe(@"CCLRequestRecordProtocol", ^{
    it(@"should inherit from NSURLProtocol", ^{
        expect([[NSClassFromString(@"CCLRequestRecordProtocol") alloc] init]).to.beKindOf([NSURLProtocol class]);
    });

    it(@"should init with a request", ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test.com/"]];
        expect([NSClassFromString(@"CCLRequestRecordProtocol") canInitWithRequest:request]).to.beTruthy();
    });

    it(@"should record an errored request", ^{
        CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];

        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://cocode.org/error"]];
        NSError *error = [NSError errorWithDomain:@"test.error" code:0 userInfo:nil];
        [manager addRequest:request error:error];

        [manager replay];
        [manager record];

        [NSURLConnection connectionWithRequest:request delegate:nil];

        expect([[manager recordings] count]).will.equal(2);
    });

    it(@"should record a successful request", ^{
        CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];

        NSURL *URL = [NSURL URLWithString:@"http://cocode.org/success"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:201 HTTPVersion:@"1.1" headerFields:@{}];
        [manager addRequest:request response:response data:nil];

        [manager replay];
        [manager record];

        [NSURLConnection connectionWithRequest:request delegate:nil];

        expect([[manager recordings] count]).will.equal(2);
    });
});

SpecEnd
