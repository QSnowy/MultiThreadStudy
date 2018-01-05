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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadDidSingle:) name:NSDidBecomeSingleThreadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadWillMulti:) name:NSWillBecomeMultiThreadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadWillExit:) name:NSThreadWillExitNotification object:nil];
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)startCreateThread:(id)sender {
    // NSThread
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMethod:) object:@"呵呵哒"];
    thread.name = @"NSThread";
    _sysThread = thread;

    // CalcThread
    NSInteger arrCount = 5000000;
    NSMutableArray *numbArr = [NSMutableArray arrayWithCapacity:arrCount];
    for (NSInteger j = 0; j < arrCount; j ++){
        NSInteger random = arc4random();
        [numbArr addObject:@(random)];
    }
    CalcThread *calcthread = [[CalcThread alloc] initWithNumbers:numbArr];
    _calThread = calcthread;
    [calcthread addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
}
- (IBAction)threadStart:(id)sender {
    
    [_sysThread start];
    [_calThread start];
    
}
- (IBAction)threadCancel:(id)sender {

    [_sysThread cancel];
    [_calThread cancel];

}
- (IBAction)threadExit:(id)sender {
    //  A线程里面调用[NSThread exit]后终止A线程，不要在主线程执行
    //    [NSThread exit];

}
- (void)threadMethod:(id)obj{
    NSLog(@"executing thread = %@ object = %@", [NSThread currentThread], obj);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"kvc called");
}

- (void)dealloc{
    
    [_calThread removeObserver:self forKeyPath:@"isFinished"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
