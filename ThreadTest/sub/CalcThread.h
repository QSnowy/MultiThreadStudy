//
//  CalcThread.h
//  ThreadTest
//
//  Created by ChatLink on 2018/1/3.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcThread : NSThread

@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;

- (instancetype)initWithNumbers:(NSArray *)numbers;

@end
