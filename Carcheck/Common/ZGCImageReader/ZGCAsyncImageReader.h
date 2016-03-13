//
//  ZGCAsyncImageReader.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/13.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGCImageCache.h"
#import <UIKit/UIKit.h>

typedef void(^ImageDownloadedBlock)(UIImage *image, NSError *error, NSString *imagePath);

@interface ZGCAsyncImageReader : NSObject

+ (id)sharedImageReader;

- (void)readImageWithPath:(NSString *)imagePath
         placeHolderImage:(UIImage *)placeHolderImage
                 complete:(ImageDownloadedBlock)completeBlock;
@end
