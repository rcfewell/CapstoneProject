//
//  Hunt.m
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "Hunt.h"

@implementation Hunt

-(id) initWithDictionary: (NSDictionary *) dictionary
{
    if( (self = [super init]) == nil)
        return nil;
    
    self.huntAttributes = [NSMutableDictionary dictionaryWithDictionary: dictionary];
    
    return self;
}

@end
