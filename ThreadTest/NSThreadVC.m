//
//  NSThreadVC.m
//  ThreadTest
//
//  Created by ChatLink on 2018/1/3.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import "NSThreadVC.h"
#import "CalcThread.h"

@interface NSThreadVC ()
@property (nonatomic, strong) NSMutableSet *threads;
@property (nonatomic, strong) NSThread   *sysThread;
@property (nonatomic, strong) CalcThread *calThread;


@end

@implementation NSThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadWillExit:) name:NSThreadWillExitNotification object:nil];
    
    
    // Do any additional setup after loading the view.
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - instance create thread
- (IBAction)instanceCreater:(id)sender {
    // 警告：线程start后，不能再次调用start
    NSThread *selectorThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMethod:) object:@"init with selector"];
    selectorThread.name = @"init selector thread";
    [selectorThread start];
    
    // 这个方法生成的线程执行速度快哟
    NSThread *blockThread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"executing init with block thread = %@", [NSThread currentThread]);
    }];
    blockThread.name = @"init block thread";
    [blockThread start];
}

- (void)threadMethod:(id)obj{
    NSLog(@"executing init with selector thread = %@ object = %@", [NSThread currentThread], obj);
}

#pragma mark - class create thread
- (IBAction)classCreater:(id)sender {
    // 创建并自动start，自动exit
    [NSThread detachNewThreadSelector:@selector(detachThread:) toTarget:self withObject:@"class detach selector thread"];
    
    [NSThread detachNewThreadWithBlock:^{
        // 线程block内代码执行完毕发送线程结束通知，如果另开线程B，不会等B线程结束再发通知的
        NSLog(@"executing class detach with block thread  = %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3];
    }];
}

- (void)detachThread:(id)obj{
    NSLog(@"executing class detach with selector thread = %@ obj = %@", [NSThread currentThread], obj);
}
#pragma mark - custom create thread
- (IBAction)customCreate:(id)sender {
    // 自定义线程子类创建方式
    NSInteger arrCount = 5000000;
    NSMutableArray *numbArr = [NSMutableArray arrayWithCapacity:arrCount];
    for (NSInteger j = 0; j < arrCount; j ++){
        NSInteger random = arc4random();
        [numbArr addObject:@(random)];
    }
    CalcThread *calcthread = [[CalcThread alloc] initWithNumbers:numbArr];
    calcthread.name = @"custom calc thread";
    [calcthread start];
}

#pragma mark - thread extension
- (void)preformOnThread:(id)obj{
    NSLog(@"perform on thread = %@ obj = %@",[NSThread currentThread], obj);
}

- (void)performOnMainThread:(id)obj{
    [NSThread sleepForTimeInterval:2];
    NSLog(@"perform on main thread = %@",[NSThread currentThread]);
}

#pragma mark - Notice
- (void)threadDidSingle:(NSNotification *)notice{
    NSLog(@"thread did become single");
}

- (void)threadWillMulti:(NSNotification *)notice{
    NSLog(@"thread will becom multi");
}

- (void)threadWillExit:(NSNotification *)notice{
    
    NSThread *exitThread = notice.object;
    NSLog(@"will exit thread = %@", exitThread);

}




@end
