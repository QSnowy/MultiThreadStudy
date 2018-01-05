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
    [self calc];

}
- (void)start{
    [super start];
    
}

- (void)cancel{
    [super cancel];
}


- (void)calc{
    
    NSLog(@"executing thread = %@",[NSThread currentThread]);

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
}

@end
