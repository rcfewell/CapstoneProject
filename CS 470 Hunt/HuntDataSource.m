//
//  HuntDataSource.m
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "HuntDataSource.h"

@implementation HuntDataSource

-(void) acceptWebData:(NSData *)webData forURL:(NSURL *)url
{
    self.huntsNSData = webData;
    [self processHuntsJSON];
    self.dataReadyForUse = YES;
}

-(void) processHuntsJSON
{
    NSError *parseError = nil;
    NSArray *jsonString =  [NSJSONSerialization JSONObjectWithData:self.huntsNSData options:0 error:&parseError];

    if(parseError) {
        NSLog(@"Badly formed JSON string. %@", [parseError localizedDescription] );
        return;
    }
    
    for (NSDictionary *huntTuple in jsonString ) {
        Hunt *hunt = [[Hunt alloc] initWithDictionary:huntTuple];
        [self.allHunts addObject: hunt];
    }
    
    self.huntsNSData = nil;
    
    if ([self.delegate respondsToSelector: @selector(dataSourceReadyForUse:)])
        [self.delegate performSelector: @selector(dataSourceReadyForUse:) withObject:self];
}

@end
