//
//  AppConfig.h
//  Fourk
//
//  Created by Qing Tan on 2019/9/5.
//

#ifndef AppConfig_h
#define AppConfig_h


@interface AppConfig : NSObject {
    // private
}
@property (nonatomic, copy) NSDictionary *mAppConfig;

+ (AppConfig*)manager;

-(NSDictionary *) getValueDict: (NSString *)key ;

@end


#endif /* AppConfig_h */
