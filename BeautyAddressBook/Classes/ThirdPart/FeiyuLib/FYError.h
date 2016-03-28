//
//  FYErrorCode.h
//  FeiyuLib
//
//  Created by jinke on 2/28/15.
//  Copyright (c) 2015 feiyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FYError : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *msg;

-(NSString *)description;
-(FYError *)initWithCode:(NSInteger)code msg:(NSString *)msg;
@end
