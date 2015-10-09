//
//  MTASINetRequest.h
//  yimouleng
//
//  Created by Ely on 15-1-2.
//  Copyright (c) 2015年 yimouleng. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void(^FailedBlock)(id error);
typedef void(^SuccessBlock)(id result);

@interface MTASINetRequest : NSObject

+ (void)requestWithURL:(NSString *)url method:(NSString *)method params:(NSMutableDictionary *)params  success:(SuccessBlock)sBlock failed:(FailedBlock)fBlock;

+ (void)requestWithURL:(NSString *)url data:(NSMutableData *)data success:(SuccessBlock)sBlock failed:(FailedBlock)fBlock;

@end
