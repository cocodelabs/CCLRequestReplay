//
//  CCLRequestReplayProtocol.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CCLRequestReplayManager;


@interface CCLRequestReplayProtocol : NSURLProtocol

+ (CCLRequestReplayManager *)manager;
+ (void)setManager:(CCLRequestReplayManager *)manager;

@end
