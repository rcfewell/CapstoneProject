//
//  CreateDataSource.m
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/27/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "CreateDataSource.h"

@interface CreateDataSource ()

@property (nonatomic) DownloadAssistant *downloadAssistant;
@property (nonatomic) NSString *huntURL;

@end

@implementation CreateDataSource

- (instancetype) initWithHuntString: (NSString *) hURL
{
    if( (self = [super init] ) == nil ){
        return nil;
    }
    
    self.huntURL = hURL;
//    _downloadAssitant = [[DownloadAssistant alloc] init];
    _downloadAssistant = [[DownloadAssistant alloc] init];
    
    [self.downloadAssistant setDelegate:self];
    self.dataReadyForUse = NO;
    
    NSURL *url = [NSURL URLWithString: self.huntURL];
    [self.downloadAssistant downloadContentsOfURL:url];
    return self;
}


- (void) acceptWebData:(NSData *)webData forURL:(NSURL *)url
{
    //pass
    // just to get rid of warning
}

@end
