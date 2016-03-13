//
//  DataService.m
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/11.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "DataService.h"

@implementation DataService

+ (void)requestWithToken:(NSString *)token

{
    NSURL *url=[[NSURL alloc]initWithString:@"https://api.zrlh.net/pingche/illegal"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[@"carnum=冀JKX715&vin=A1D9867B2794016&type=02" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url
                                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                         timeoutInterval:20.0f];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"token"];
    [request setHTTPBody:postBody];
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"结果：%@",result);

}


#define HTTP_CONTENT_BOUNDARY @"WANPUSH"
+ (void)httpPutData:(NSString*)strUrl Data:(NSData*)data FileName:(NSString *)fileName DataType:(NSString*)dataType Token:(NSString *)token {
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:strUrl];
    
    NSString* strBodyBegin = [NSString stringWithFormat:@"--%@\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\nContent-Type: %@\n\n", HTTP_CONTENT_BOUNDARY, @"file",  fileName, dataType];
    NSString* strBodyEnd = [NSString stringWithFormat:@"\n--%@--",HTTP_CONTENT_BOUNDARY];
    
    NSMutableData *httpBody = [NSMutableData data];
    [httpBody appendData:[strBodyBegin dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[strBodyEnd dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest* httpPutRequest = [[NSMutableURLRequest alloc] init];
    [httpPutRequest setURL:url];
    [httpPutRequest setHTTPMethod:@"POST"];
    [httpPutRequest setValue:token forHTTPHeaderField:@"token"];
    [httpPutRequest setTimeoutInterval: 60000];
    [httpPutRequest setValue:[NSString stringWithFormat:@"%@", @(httpBody.length)] forHTTPHeaderField:@"Content-Length"];
    [httpPutRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",HTTP_CONTENT_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    httpPutRequest.HTTPBody = httpBody;
    
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:httpPutRequest
                                                 returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"结果：%@",result);
    
  
    
}


@end
