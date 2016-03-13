//
//  ZGCImageCache.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/13.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZGCImageCache : NSObject {
@private
    NSCache *memCache;
    NSFileManager *fileManager;
    NSString *cacheDir;
    dispatch_queue_t ioQueue;
}
+ (ZGCImageCache*)sharedCache;

// 内存缓存
- (void)cacheImageToMemory:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getImageFromMemoryForkey:(NSString*)key;

// 文件缓存
- (void)cacheImageToFile:(UIImage*)image forKey:(NSString*)key ofType:(NSString*)imageType;
- (UIImage*)getImageFromFileForKey:(NSString*)key;

@end
