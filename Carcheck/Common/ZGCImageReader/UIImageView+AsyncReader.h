//
//  UIImageView+AsyncReader.h
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/13.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGCAsyncImageReader.h"
@interface UIImageView (AsyncReader)


// 通过为 ImageView 设置 tag 防止错位
// tag 指向的永远是当前可见图片的 url， 这样通过 tag 就可以过滤掉已经滑出屏幕的图片的 url
//@property NSString *tagIndex;

- (void)setImageWithPath:(NSString *)path placeholderImage:(UIImage *)placeholder;

@end
