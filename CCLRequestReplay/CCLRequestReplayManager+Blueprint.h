//
//  CCLRequestReplayManager+Blueprint.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLRequestReplayManager.h"


/** An extension to CCLRequestReplayManager to add support to
 read recordings from an API Blueprint file. */
@interface CCLRequestReplayManager (Blueprint)

/** A convinience method to create a manager from a blueprint file.
 @param URL The URL of the blueprint file on disk.
 @param error An error that occured when reading or parsing the API blueprint
 @return A new manager or nil on error.
 */
+ (instancetype)managerFromBlueprintURL:(NSURL *)URL error:(NSError **)error;

/** Add recordings from an API Blueprint file.
 @param URL The URL of the blueprint file on disk.
 @param error An error that occured when reading or parsing the API blueprint
 @return YES on success or NO on failure along with providing an error.
 */
- (BOOL)addRecordingsFromBlueprintURL:(NSURL *)URL error:(NSError **)error;

/** Add recordings from API Blueprint data.
 @param data The API Blueprint data
 @param error An error that occured when reading or parsing the API blueprint
 @return YES on success or NO on failure along with providing an error.
 */
- (BOOL)addRecordingsFromBlueprintData:(NSData *)data error:(NSError **)error;

@end
