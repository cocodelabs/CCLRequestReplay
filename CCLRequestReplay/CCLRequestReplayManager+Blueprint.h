//
//  CCLRequestReplayManager+Blueprint.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLRequestReplayManager.h"


@interface CCLRequestReplayManager (Blueprint)

+ (instancetype)managerFromBlueprintURL:(NSURL *)URL error:(NSError **)error;

- (BOOL)addRecordingsFromBlueprintURL:(NSURL *)URL error:(NSError **)error;
- (BOOL)addRecordingsFromBlueprintData:(NSData *)data error:(NSError **)error;

@end
