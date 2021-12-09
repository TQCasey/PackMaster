//
//  AppConfig.m
//  Fourk iOS
//
//  Created by Qing Tan on 2019/9/5.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"

@implementation AppConfig

+ (AppConfig*)manager
{
    static AppConfig* instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

// constructor
-(id) init{
    self = [super init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"appconfig" ofType:@"plist"];
    self.mAppConfig = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
//    NSLog(@"===>%@",self.mAppConfig);
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [self.mAppConfig release];
}

-(NSDictionary *) getValueDict: (NSString *)key {
    NSDictionary *value = [self.mAppConfig objectForKey:key];
//    NSLog(@"getValue %@ ==> %@",key,value);
    return value;
}

@end
