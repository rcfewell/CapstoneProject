//
//  StepDataSource.h
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/19/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"
#import "DownloadAssistant.h"
//#import "StepViewController.h"

@protocol DataSourceReadyForUseDelegate;

@interface StepDataSource : NSObject<WebDataReadyDelegate>

@property (nonatomic) id<DataSourceReadyForUseDelegate> delegate;
@property (nonatomic) BOOL dataReadyForUse;

- (instancetype) initWithStepsURL: (NSString *) sURL;
- (void) processStepJSON;
- (void) print;
- (void) acceptWebData:(NSData *) webData forURL:(NSURL *) url;
- (Step *) stepWithName: (NSString *) stepName;
- (NSArray *) getAllSteps;
-(BOOL) deleteStepAtIndex: (NSInteger) idx;
- (Step *) stepAtIndex: (int) idx;
- (NSInteger ) numberOfSteps;
- (NSString *) StepsTabBarTitle;


@end


@protocol DataSourceReadyForUseDelegate <NSObject>

@optional

-(void) dataSourceReadyForUse: (StepDataSource *) dataSource;

@end




