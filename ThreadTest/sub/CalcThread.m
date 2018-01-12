//
//  CalcThread.m
//  ThreadTest
//
//  Created by ChatLink on 2018/1/3.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import "CalcThread.h"

@implementation CalcThread
{
    NSArray        *_numbers;
}

- (instancetype)initWithNumbers:(NSArray *)numbers{
    
    self = [super init];
    if (nil != self){
        _numbers = numbers;
    }
    return self;
}


- (void)main{
    [super main];
    NSLog(@"calc thread main");
    [self calc];

}
- (void)start{
    [super start];
    NSLog(@"calc thread start");
    
}

- (void)cancel{
    [super cancel];
    NSLog(@"calc thread cancel");
}


- (void)calc{
    
    NSLog(@"custom thread executing = %@",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:4];
//    [NSThread exit];
    NSInteger tempMin = NSIntegerMax;
    NSInteger tempMax = 0;
    for (NSNumber *num in _numbers){
        tempMin = [num integerValue] < tempMin ? [num integerValue] : tempMin;
    }
    for (NSNumber *num in _numbers){
        tempMax = [num integerValue] > tempMax ? [num integerValue] : tempMax;
    }
    _min = tempMin;
    _max = tempMax;
    NSLog(@"custom thread calc min = %ld, max = %ld",tempMin, tempMax);
}

@end
