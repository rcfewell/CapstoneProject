//
//  Hunt.h
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hunt : NSObject

@property (nonatomic) NSMutableDictionary *huntAttributes;

-(id) initWithDictionary: (NSDictionary *) dictionary;

@end
