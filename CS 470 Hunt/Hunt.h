//
//  Hunt.h
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Hunt : NSObject

@property (nonatomic) NSMutableDictionary *huntAttributes;

-(id) initWithDictionary: (NSDictionary *) dictionary;
- (void) addValue: (NSString *) attrVal forAttribute: (NSString *) attrName;
- (NSString *) getValueForAttribute: (NSString *) attr;
- (NSString *) title;
- (NSString *) getImageURL;
- (NSString *) getDate;
- (CGSize) sizeOfListEntryView;
- (NSAttributedString *) compose: str withBoldPrefix: (NSString *) prefix;
- (void) print;

@end
