//
//  CCLRequestRecordingXCTest.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 19/04/2014.
//
//

#define EXP_SHORTHAND YES

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import <CCLRequestReplay/XCTest+CCLRequestReplay.h>


SpecBegin(CCLRequestReplay)

describe(@"the xctest extension", ^{
    it(@"should add a request replay manager during setup", ^{
        CCLRequestReplayManager *manager = [self requestReplayManager];
        expect(manager).notTo.beNil();
    });
});

SpecEnd