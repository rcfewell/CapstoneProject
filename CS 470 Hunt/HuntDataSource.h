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

@property (nonatomic, copy) NSString *huntsURLString;
@property (nonatomic) NSData *huntsNSData;
@property (nonatomic) NSMutableArray *allHunts;
@property (nonatomic) DownloadAssistant *downloadAssistant;

@end

@protocol DataSourceReadyForUseDelegate <NSObject>

@optional

-(void) dataSourceReadyForUse: (HuntDataSource *) dataSource;

@end
