//
//  CustomOperation.m
//  ThreadTest
//
//  Created by ChatLink on 2018/1/10.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import "CustomOperation.h"

@implementation CustomOperation

- (void)start{
    
    [super start];
    NSLog(@"custom operation start");
}

- (void)main{
    
    [super main];
    NSLog(@"custom operation main method , thread = %@", [NSThread currentThread]);
}

- (void)cancel{
    
    [super cancel];
    NSLog(@"custom operation cancel");
}

@end
