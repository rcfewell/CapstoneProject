//
//  HuntDataSource.h
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hunt.h"
#import "DownloadAssistant.h"

@protocol DataSourceReadyForUseDelegate;

@interface HuntDataSource : NSObject<WebDataReadyDelegate>

@property (nonatomic) id<DataSourceReadyForUseDelegate> delegate;
@property (nonatomic) BOOL dataReadyForUse;

- (NSMutableArray *) allHunts;
- (instancetype) initWithHuntsURLString: (NSString *) hURL;
- (void) processHuntJSON;
- (void) print;
- (void) acceptWebData:(NSData *) webData forURL:(NSURL *) url;
- (Hunt *) huntWithName: (NSString *) huntName;
- (NSArray *) getAllhunts;
- (BOOL) deleteHuntAtIndex: (NSInteger) idx;
- (Hunt *) huntAtIndex: (int) idx;
- (NSInteger ) numberOfHunts;
- (NSString *) HuntsTabBarTitle;


@end

@protocol DataSourceReadyForUseDelegate <NSObject>



@optional

-(void) dataSourceReadyForUse: (HuntDataSource *) dataSource;

@end
