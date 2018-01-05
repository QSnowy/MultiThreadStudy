//
//  PThreadVC.m
//  ThreadTest
//
//  Created by ChatLink on 2018/1/3.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import "PThreadVC.h"
#import <pthread.h>

struct threadInfo {
    uint32_t *inputValues;
    size_t count;
};

struct threadResult {
    uint32_t min;
    uint32_t max;
};




@interface PThreadVC ()

@end

@implementation PThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    size_t const count = 1000000;
    uint32_t inputValues[count];
    
    // 使用随机数字填充 inputValues
    for (size_t i = 0; i < count; ++i){
        inputValues[i] = arc4random();
    }
    
    // 开始4个寻找最小值和最大值的线程
    size_t const threadCount = 4;
    pthread_t tid[threadCount];
    for (size_t i = 0; i < threadCount; ++i){
        struct threadInfo * const info = (struct threadInfo *) malloc(sizeof(*info));
        size_t offset = (count / threadCount) * i;
        info->inputValues = inputValues + offset;
        info->count = MIN(count - offset, count / threadCount);
        int err = pthread_create(tid + i, NULL, &findMinAndMax, info);
        NSCAssert(err == 0, @"pthread_create() failed: %@", err);
    }
    
    // 等待线程退出
    struct threadResult *results[threadCount];
    for (size_t i = 0; i < threadCount; ++i){
        int err = pthread_join(tid[i], (void **) &(results[i]));
        NSCAssert(err == 0, @"pthread_join() failed: %d", err);
    }
    
    // 寻找min max
    uint32_t min = UINT32_MAX;
    uint32_t max = 0;
    for (size_t i = 0; i < threadCount; ++i){
        min = MIN(min, results[i]->min);
        max = MAX(max, results[i]->max);
        free(results[i]);
        results[i] = NULL;
    }
    NSLog(@"min = %u", min);
    NSLog(@"max = %u", max);
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void *findMinAndMax(void *arg){
    struct threadInfo const * const info = (struct threadInfo *) arg;
    uint32_t min = UINT32_MAX;
    uint32_t max = 0;
    for (size_t i = 0; i < info -> count; i ++){
        uint32_t v = info->inputValues[i];
        min = MIN(min, v);
        max = MAX(max, v);
    }
    free(arg);
    struct threadResult * const result = (struct threadResult *) malloc(sizeof(*result));
    result->min = min;
    result->max = max;
    return result;
}


@end
