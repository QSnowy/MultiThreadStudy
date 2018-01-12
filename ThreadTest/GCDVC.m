//
//  GCDVC.m
//  ThreadTest
//
//  Created by ChatLink on 2018/1/3.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import "GCDVC.h"

@interface GCDVC ()

@end

@implementation GCDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createThread{
    dispatch_queue_t oneQueue = dispatch_queue_create("one", DISPATCH_QUEUE_CONCURRENT);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
