//
//  CustomOperation.h
//  ThreadTest
//
//  Created by ChatLink on 2018/1/10.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomOperation : NSOperation

- (void)loadImageView:(UIImageView *)imageView url:(NSURL *)url;

@end
