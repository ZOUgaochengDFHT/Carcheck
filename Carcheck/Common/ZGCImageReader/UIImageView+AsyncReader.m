//
//  UIImageView+AsyncReader.m
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/13.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import "UIImageView+AsyncReader.h"

@implementation UIImageView (AsyncReader)

- (void)setImageWithPath:(NSString *)path placeholderImage:(UIImage *)placeHolderImage{
    // 给  ImageView 设置 tag, 指向当前 url
//    self.tag = [path intValue];
    
    // 预设一个图片，可以为 nil
    // 主要是为了清除由于复用以前可能存在的图片
    self.image = placeHolderImage;
    
    if (path) {
        // 异步读取图片
        ZGCAsyncImageReader *imageReader = [ZGCAsyncImageReader sharedImageReader];
       
        [imageReader readImageWithPath:path
                      placeHolderImage:placeHolderImage
                              complete:^(UIImage *image, NSError *error, NSString *imagePath) {
            // 通过 tag 保证图片被正确的设置
            if (image ) {
                self.image = image;
            }else{
                NSLog(@"error when download:%@", error);
            }
        }];
    }
}

@end
