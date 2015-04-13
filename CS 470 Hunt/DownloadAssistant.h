//
//  DownloadAssistant.h
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebDataReadyDelegate;

@interface DownloadAssistant : NSObject<NSURLConnectionDelegate>

@property (nonatomic) id<WebDataReadyDelegate> delegate;

-(void) downloadContentsOfURL: (NSURL *) url;
-(NSData *) downloadedData;

@end

@protocol WebDataReadyDelegate<NSObject>

@required

-(void) acceptWebData: (NSData *) webData forURL: (NSURL *) url;

@end
