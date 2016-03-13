//
//  ZGCAsyncImageReader.m
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/13.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "ZGCAsyncImageReader.h"

@implementation ZGCAsyncImageReader

+(id)sharedImageReader{
    static ZGCAsyncImageReader *sharedImageReader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImageReader = [[self alloc] init];
    });
    
    return sharedImageReader;
}

- (void)readImageWithPath:(NSString *)imagePath
         placeHolderImage:(UIImage *)placeHolderImage
                 complete:(ImageDownloadedBlock)completeBlock {
    
    ZGCImageCache *imageCache = [ZGCImageCache sharedCache];
    UIImage *image = [imageCache getImageFromMemoryForkey:imagePath];
    // 从内存中取
    if (image) {
        if (completeBlock) {
            NSLog(@"image exists in memory");
            completeBlock(image,nil,imagePath);
        }
        
        return;
    }
//    
//    // 再从文件中取
//    image = [imageCache getImageFromFileForKey:imagePath];
//    if (image) {
//        if (completeBlock) {
//            NSLog(@"image exists in file");
//            completeBlock(image,nil,imagePath);
//        }
//        
//        // 重新加入到 NSCache 中
//        [imageCache cacheImageToMemory:image forKey:imagePath];
//        
//        return;
//    }
    
    // 内存和文件中都没有再从网络下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError * error;
//        NSData *imgData = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingMappedIfSafe error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImage *image = [UIImage imageNamed:imagePath];
            if (placeHolderImage) {
                // 先缓存图片到内存
                [imageCache cacheImageToMemory:placeHolderImage forKey:imagePath];
                
//                // 再缓存图片到文件系统
//                NSString *extension = [[imagePath substringFromIndex:imagePath.length - 3] lowercaseString];
//                NSString *imageType = @"jpg";
//                
//                if ([extension isEqualToString:@"jpg"]) {
//                    imageType = @"jpg";
//                }else{
//                    imageType = @"png";
//                }
//                
//                [imageCache cacheImageToFile:image forKey:imagePath ofType:imageType];
                if (completeBlock) {
                    completeBlock(placeHolderImage, error, imagePath);
                }
            }
        });
    });
}

@end
