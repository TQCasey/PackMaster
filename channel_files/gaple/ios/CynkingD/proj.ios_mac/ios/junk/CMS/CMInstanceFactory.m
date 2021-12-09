//
//  CMInstanceFactory.m
//
//
//  Created by CynkingGame inc on 2019/02/14.
//  Copyright © 2019年 @no_no_no. All rights reserved.
//

#import "CMInstanceFactory.h"
#import "RootViewController.h"
#import "jiazai.h"
#import "LuaCallEvent.h"
#import "uuid.h"
#import "AppController.h"
#import "tupian.h"
#import "zhifu.h"

@implementation CMInstanceFactory

+ (void)instanceFactory {

	[RootViewController instanceFactory];
	[IAPManager instanceFactory];
	[LuaCallEvent instanceFactory];
	[AppController instanceFactory];
	[VPImageCropperViewController instanceFactory];
	[LoadingView instanceFactory];
}

@end