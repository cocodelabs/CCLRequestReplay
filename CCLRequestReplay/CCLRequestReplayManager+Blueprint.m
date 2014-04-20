//
//  CCLRequestReplayManager+Blueprint.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import "CCLRequestReplayManager+Blueprint.h"


@implementation CCLRequestReplayManager (Blueprint)

+ (instancetype)managerFromBlueprintURL:(NSURL *)URL error:(NSError **)error {
    CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];

    if ([manager addRecordingsFromBlueprintURL:URL error:error] == NO) {
        manager = nil;
    }

    return manager;
}

- (BOOL)addRecordingsFromBlueprintURL:(NSURL *)URL error:(NSError **)error {
    NSData *blueprintData = [NSData dataWithContentsOfURL:URL options:0 error:error];
    BOOL didAddRecordingsFromFile = NO;

    if (blueprintData) {
        didAddRecordingsFromFile = [self addRecordingsFromBlueprintData:blueprintData error:error];
    }

    return didAddRecordingsFromFile;
}

- (BOOL)addRecordingsFromBlueprintData:(NSData *)data error:(NSError **)error {
    BOOL didAddRecordingsFromData = NO;
    NSDictionary *blueprint = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];

    if (blueprint) {
        if ([blueprint isKindOfClass:[NSDictionary class]]) {
            didAddRecordingsFromData = [self addRecordingsFromBlueprintDictionary:blueprint error:error];
        } else {
            // error
        }
    }

    return didAddRecordingsFromData;
}

- (BOOL)addRecordingsFromBlueprintDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    NSURL *baseURL;

    if ([dictionary objectForKey:@"metadata"]) {
        for (NSDictionary *metadata in dictionary[@"metadata"]) {
            if ([metadata[@"name"] isEqualToString:@"HOST"]) {
                baseURL = [NSURL URLWithString:metadata[@"value"]];
                break;
            }
        }
    }

    if ([dictionary objectForKey:@"resourceGroups"]) {
        for (NSDictionary *resourceGroup in dictionary[@"resourceGroups"]) {
            for (NSDictionary *resource in resourceGroup[@"resources"]) {
                NSString *uriTemplate = resource[@"uriTemplate"];

                for (NSDictionary *action in resource[@"actions"]) {
                    NSString *method = action[@"method"];
                    NSURL *URL = [[NSURL URLWithString:uriTemplate relativeToURL:baseURL] absoluteURL];
                    NSMutableURLRequest *baseRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
                    baseRequest.HTTPMethod = method;

                    for (NSDictionary *example in action[@"examples"]) {
                        for (NSDictionary *requestDictionary in example[@"requests"]) {
                            if ([requestDictionary objectForKey:@"headers"]) {
                                for (NSDictionary *header in requestDictionary[@"headers"]) {
                                    [baseRequest setValue:header[@"value"] forHTTPHeaderField:header[@"name"]];
                                }
                            }

                            // We don't care about the body right no
                            break; // TODO parse all the requests
                        }

                        for (NSDictionary *responseDictionary in example[@"responses"]) {
                            NSInteger statusCode = [responseDictionary[@"name"] integerValue];
                            NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];

                            if ([responseDictionary objectForKey:@"headers"]) {
                                for (NSDictionary *header in responseDictionary[@"headers"]) {
                                    [headers setValue:header[@"value"] forKey:header[@"name"]];
                                }
                            }

                            NSData *data;

                            if ([responseDictionary objectForKey:@"body"]) {
                                NSString *body = responseDictionary[@"body"];
                                data = [body dataUsingEncoding:NSUTF8StringEncoding];
                            }

                            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:statusCode HTTPVersion:@"1.1" headerFields:[headers copy]];
                            [self addRequest:baseRequest response:response data:data];
                            break; // TODO parse all the responses
                        }
                    }
                }
            }
        }
    }

    return YES;
}

@end
