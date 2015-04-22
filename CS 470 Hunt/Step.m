//
//  Step.m
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "Step.h"

@implementation Step

enum {VIEW_HEIGHT = 90};

-(id) initWithDictionary: (NSDictionary *) dictionary
{
    if( (self = [super init]) == nil)
        return nil;
    
    self.stepAttributes = [NSMutableDictionary dictionaryWithDictionary: dictionary];

    
    return self;
}

- (void) addValue: (NSString *) attrVal forAttribute: (NSString *) attrName
{
    [self.stepAttributes setValue:attrVal forKey:attrName];
}

- (NSString *) getValueForAttribute: (NSString *) attr
{
    return [self.stepAttributes valueForKey:attr];
}

- (NSString *) title
{
    return [self.stepAttributes valueForKey:@"name"];
    //    return [self.theatersAttrs valueForKey:@"movieTitle"];
}

- (NSString*) getStepNumber
{
    return [self.stepAttributes valueForKey:@"step" ];
}

- (NSString *) getDescription
{
    NSLog( @"description: %@", [self.stepAttributes valueForKey:@"description"] );
//    return [self.stepAttributes valueForKey:@"description"];
    return [self getValueForAttribute:@"description"];
}

- (NSString *) getImageURL
{
    return [self getValueForAttribute: @"urlPath" ];
}

- (CGSize) sizeOfListEntryView
{
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    return CGSizeMake(bounds.size.height, VIEW_HEIGHT);
}

- (NSAttributedString *) compose: str withBoldPrefix: (NSString *) prefix
{
    const CGFloat fontSize = 13;
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIFont *italicFont = [UIFont italicSystemFontOfSize:fontSize];
    UIColor *foregroundColor = [UIColor blackColor];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:regularFont, NSFontAttributeName, foregroundColor, NSForegroundColorAttributeName, nil];
    
    NSDictionary *boldAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName, nil];
    
    NSMutableAttributedString * attrString = nil;
    
    if( [prefix isEqualToString:@""] )
    {
        [attrs setObject:italicFont forKey: NSFontAttributeName];
        attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:attrs];
    }
    else
    {
        NSString *text = [NSString stringWithFormat:@"%@: %@", prefix, str];
        attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
        NSRange range = NSMakeRange(0, prefix.length);
        [attrString setAttributes:boldAttrs range:range];
    }
    
    
    return attrString;
}

- (void) print
{
    NSEnumerator *tEnum = [self.stepAttributes keyEnumerator];
    NSString *attrName;
    while( attrName == (NSString *) [tEnum nextObject] )
    {
        NSLog( @"Attribute Name: %@", attrName );
        NSLog( @"Attribute Value: %@", [self.stepAttributes valueForKey:attrName]);
    }
}

@end
