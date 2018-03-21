//
//  AppModel.h
//  GuessPhotos
//
//  Created by 李一贤 on 2018/3/21.
//  Copyright © 2018年 李一贤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject
@property(nonatomic,copy)NSString* icon;
@property(nonatomic,strong)NSString* answer;
@property(nonatomic,strong)NSArray* options;
-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)appModelWithDict:(NSDictionary*)dict;
@end
