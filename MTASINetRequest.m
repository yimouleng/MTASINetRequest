//
//  MTASINetRequest.m
//  yimouleng
//
//  Created by Ely on 15-1-2.
//  Copyright (c) 2015年 yimouleng. All rights reserved.
//



#import "MTASINetRequest.h"
#import "ASIFormDataRequest.h"

@implementation MTASINetRequest

+ (void)requestWithURL:(NSString *)url method:(NSString *)method params:(NSMutableDictionary *)params  success:(SuccessBlock)sBlock failed:(FailedBlock)fBlock
{
    
    // GET
    if ([method isEqualToString:@"GET"]) {
        
        NSMutableString *paramString=[NSMutableString string];
        NSArray *allkeys=[params allKeys];
        
        for (int i=0;i<[allkeys count]; i++){
            NSString *key=[allkeys objectAtIndex:i];
            id value=[params objectForKey:key];
            if (i==[allkeys count]-1) {
                [paramString appendFormat:@"%@=%@",key,value];
            }else{
                [paramString appendFormat:@"%@=%@&",key,value];
            }
        }
        NSMutableString *finalurl;
        if (allkeys.count > 0) {
            finalurl=[NSMutableString stringWithFormat:@"%@/%@?%@",OrderUrl,url,paramString];
        } else {
            finalurl=[NSMutableString stringWithFormat:@"%@/%@",OrderUrl,url];
        }
        NSLog(@"---GET---URL-----%@-----",finalurl);
         NSString *finalEncodStr = [finalurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:finalEncodStr]];
        request.timeOutSeconds = 20;
        __weak ASIHTTPRequest *weakRequest = request;

        [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        
        [request setRequestMethod:method];
        [request setCompletionBlock:^{
            
            ASIHTTPRequest *localRequest = weakRequest;
            id result=[NSJSONSerialization JSONObjectWithData:localRequest.responseData options:NSJSONReadingAllowFragments error:nil];
            
            if (sBlock!=nil) {
                sBlock(result);
            }
        }];
        [request setFailedBlock:^{
            fBlock(@"网络异常，请求失败！");
        }];
        
        [request startAsynchronous];
        
    // POST
    } else {
        NSMutableString *finalurl=[NSMutableString stringWithFormat:@"%@/%@",OrderUrl,url];

        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:finalurl]];
        request.timeOutSeconds = 20;
        request.requestMethod = @"POST";
        [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
        [request addRequestHeader:@"Accept" value:@"application/json"];

        NSArray *allkeys=[params allKeys];
        
        for (int i=0; i<[allkeys count]; i++){
            NSString *key=[allkeys objectAtIndex:i];
            id value=[params objectForKey:key];
            [request addPostValue:value forKey:key];
            NSLog(@"---POST---Key:%@-----value:%@-----",key,value);
        }
        __weak ASIFormDataRequest *weakRequest = request;
        
        [request setCompletionBlock:^{
            ASIFormDataRequest *localRequest = weakRequest;
            NSLog(@"setCompletionBlock:%@", localRequest.responseString);
            id result=[NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:NSJSONReadingAllowFragments error:nil];

            if (sBlock!=nil) {
                sBlock(result);
            }
        }];
        [request setFailedBlock:^{
            fBlock(@"网络异常，请求失败！");
        }];
        
        [request startAsynchronous];
    }
}

+ (void)requestWithURL:(NSString *)url data:(NSMutableData *)data success:(SuccessBlock)sBlock failed:(FailedBlock)fBlock
{
    NSMutableString *finalurl=[NSMutableString stringWithFormat:@"%@/%@",OrderUrl,url];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:finalurl]];
    request.timeOutSeconds = 20;
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    
    [request setPostBody:data];

    __weak ASIFormDataRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        ASIFormDataRequest *localRequest = weakRequest;
        NSLog(@"setCompletionBlock:%@", localRequest.responseString);
        id result=[NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (sBlock!=nil) {
            sBlock(result);
        }
    }];
    [request setFailedBlock:^{
        fBlock(@"网络异常，请求失败！");
    }];
    
    [request startAsynchronous];
}



@end
