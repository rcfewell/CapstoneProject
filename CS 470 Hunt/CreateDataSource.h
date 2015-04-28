//
//  CreateDataSource.h
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/27/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadAssistant.h"

@protocol DataSourceReadyForUseDelegate;

@interface CreateDataSource : NSObject<WebDataReadyDelegate>

@property (nonatomic) id<DataSourceReadyForUseDelegate> delegate;
@property (nonatomic) BOOL dataReadyForUse;

//-(instancetype) initWithbArrayURLString: (NSString *) bURL;
- (instancetype) initWithHuntString: (NSString *) hURL;


@end

@protocol DataSourceReadyForUseDelegate <NSObject>

@optional

-(void) dataSourceReadyForUse: (CreateDataSource *) dataSource;



@end
