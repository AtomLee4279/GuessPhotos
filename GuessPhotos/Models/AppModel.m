//
//  AppModel.m
//  GuessPhotos
//
//  Created by 李一贤 on 2018/3/21.
//  Copyright © 2018年 李一贤. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

-(instancetype)initWithDict:(NSDictionary*)dict
{
    if(self= [super init])
    {
        self.icon = dict[@"icon"];
        self.answer = dict[@"answer"];
//        self.answer = dict[@"title"];
        self.options = dict[@"options"];
    }
    return self;
}
+(instancetype)appModelWithDict:(NSDictionary*)dict
{
    return  [[self alloc]initWithDict:dict];
}


@end