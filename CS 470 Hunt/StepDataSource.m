//
//  StepDataSource.m
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/19/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "StepDataSource.h"

@interface StepDataSource ()
{
    BOOL _debug;
}

@property (nonatomic) NSMutableArray *steps;
@property (nonatomic) NSString *stepsURLString;
@property (nonatomic) DownloadAssistant *downloadAssistant;
@property (nonatomic) NSData *stepsNSData;

@end


@implementation StepDataSource

- (NSMutableArray *) steps
{
    if( _steps == nil )
        _steps = [[NSMutableArray alloc] init];
    return _steps;
}

- (instancetype) initWithStepsURL: (NSString *) sURL
{
    if( (self = [super init]) == nil )
        return nil;
    
    self.stepsURLString = sURL;
    _debug = YES;
    
    _downloadAssistant = [[DownloadAssistant alloc]init];
    [self.downloadAssistant setDelegate:self];
    
    self.dataReadyForUse = NO;
    
    NSURL *url = [NSURL URLWithString:self.stepsURLString];
    [self.downloadAssistant downloadContentsOfURL:url];
    
    return self;
}

- (void) processStepJSON
{
    NSError *parseError = nil;
    NSArray *jsonString = [NSJSONSerialization JSONObjectWithData:self.stepsNSData options:0 error:&parseError];
    
    if( _debug )
        NSLog( @"JSON string: %@", jsonString );
    
    if( parseError )
    {
        NSLog( @"In hunts Badly formed JSON string: %@", [parseError localizedDescription] );
        return;
    }
    
    for( NSMutableDictionary *stepTuple in jsonString )
    {
        Step *step = [[Step alloc] initWithDictionary:stepTuple];
//        Step *step = [[Step alloc] init];
//        [step.stepAttributes setDictionary:stepTuple];
//        step.stepAttributes = [NSMutableDictionary dictionaryWithDictionary:stepTuple];
//        NSLog( @"step attributes: %@", [step.stepAttributes valueForKey:@"description"]);
        
        if( _debug )
            [step print];
        [self.steps addObject:step];
        NSLog( @"num of steps %lu", (unsigned long)[self.steps count] );
    }
    
    self.stepsNSData = nil;
    
//    if( [self.delegate respondsToSelector: @selector(dataSourceReadyForUse:)])
//        [self.delegate performSelector: @selector(dataSourceReadyForUse:) withObject:self];
    
        
    
    
}

- (void) print
{
    NSLog( @"number of steps %lu", (unsigned long)[self.steps count] );
    for( Step *s in self.steps )
        [s print];
}

- (void) acceptWebData:(NSData *) webData forURL:(NSURL *) url
{
    self.stepsNSData = webData;
    [self processStepJSON];
    [self print];
    NSLog( @"completing printing steps" );
    self.dataReadyForUse = YES;
    
}

- (Step *) stepWithName: (NSString *) stepName
{
    if( [self.steps count] == 0 )
        return nil;
    
    for( Step *s in self.steps )
        if( [s.title isEqualToString:stepName] )
            return s;
    return nil;
}

- (NSArray *) getAllSteps
{
    return  self.steps;
}

-(BOOL) deleteStepAtIndex: (NSInteger) idx
{
    [self.steps removeObjectAtIndex:idx];
    return YES;
}

- (Step *) stepAtIndex: (int) idx
{
    if( idx >= [self.steps count] )
        return nil;
    return [self.steps objectAtIndex:idx];
}

- (NSInteger ) numberOfSteps
{
    return [self.steps count];
}

- (NSString *) StepsTabBarTitle
{
    return @"Steps";
}

@end
