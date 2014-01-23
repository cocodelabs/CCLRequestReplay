//
//  CCLRequestRecording.h
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import "CCLRequestRecording.h"


@implementation CCLRequestRecording

- (instancetype)initWithRequest:(NSURLRequest *)request response:(NSURLResponse *)response data:(NSData *)data {
    if (self = [super init]) {
        _request = request;
        _response = response;
        _data = data;
    }

    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request error:(NSError *)error {
    if (self = [super init]) {
        _request = request;
        _error = error;
    }

    return self;
}

@end
