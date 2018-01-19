//
//  OperationVC.m
//  ThreadTest
//
//  Created by ChatLink on 2018/1/4.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import "OperationVC.h"
#import "CustomOperation.h"

@interface OperationVC ()

@property (nonatomic, strong) NSInvocationOperation *invocationOperation;
@property (nonatomic, strong) NSBlockOperation *blockOperation;
@property (nonatomic, strong) CustomOperation *customOperation;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;
@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, strong) NSOperationQueue *backQueue;
@end

@implementation OperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    


    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i < 5; i ++){
        // @"http://cowo123.com/wp-content/uploads/2018/01/head_03.png"
        NSString *url = [NSString stringWithFormat:@"http://cowo123.com/wp-content/uploads/2018/01/head_0%ld.png",(long)i];
        [array addObject:url];
    }
    _imageUrls = array;
    


}
- (IBAction)createOperation:(id)sender {
    // 创建不同的operation
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            if (!_invocationOperation){
                _invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocation:) object:@"invocation_obj"];
                _invocationOperation.name = @"invocation";
                _invocationOperation.queuePriority = NSOperationQueuePriorityLow;
                
            }
        }
            break;
            
        case 2:
        {
            if (!_blockOperation){
                _blockOperation = [[NSBlockOperation alloc] init];
                _blockOperation.name = @"block";
                
                __weak typeof(self) weakSelf = self;
                [_blockOperation addExecutionBlock:^{
                    [weakSelf loadImageWithIndex:1 block:nil];
                    NSLog(@"this is block operation execut 1, thread = %@", [NSThread currentThread]);
                }];
                [_blockOperation addExecutionBlock:^{
                    [weakSelf loadImageWithIndex:2 block:nil];
                    NSLog(@"this block operation execut 2 ,thread = %@",[NSThread currentThread]);
                }];
            }
        }
            break;
            
        case 3:
        {
            if (!_customOperation){
                _customOperation = [[CustomOperation alloc] init];
                _customOperation.name = @"custom operation";
            }
        }
            break;
            
        default:
            break;
    }

    
}

- (IBAction)startOperation:(id)sender {
    // 开启operation
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            if (!_invocationOperation){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"线程还未创建" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            [_invocationOperation start];
        }
            break;
            
        case 2:
        {
            if (!_blockOperation){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"线程还未创建" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            [_blockOperation start];
        }
            break;
            
        case 3:
        {
            if (!_customOperation){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"线程还未创建" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
//            [_customOperation start];
            [_customOperation loadImageView:self.images.lastObject url:[NSURL URLWithString:self.imageUrls.lastObject]];
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)cancelOperation:(id)sender {
    // 取消operation
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            [_invocationOperation cancel];
        }
            break;
            
        case 2:
        {
            [_blockOperation cancel];
        }
            break;
            
        case 3:
        {
            [_customOperation cancel];
        }
            break;
            
        default:
            break;
    }
    
}
- (IBAction)createQueue:(id)sender {
    _backQueue = nil;
    
    _backQueue = [[NSOperationQueue alloc] init];
    _backQueue.qualityOfService = NSQualityOfServiceDefault;
    __weak typeof(self) weakSelf = self;    __block NSBlockOperation *first = nil;
    for (int i = 0; i < 4; i ++) {
        NSBlockOperation *block = [[NSBlockOperation alloc] init];
        block.name = [NSString stringWithFormat:@"operation_%ld", (long)i];
        __weak typeof(block) weakBlock = block;
        [block addExecutionBlock:^{
            // block 只有再这个任务将要start时，这里的代码才会执行
            [NSThread sleepForTimeInterval:i == 2 ? 3 : 1];
            [weakSelf loadImageWithIndex:i block:weakBlock];
            
        }];
        if (i == 2){
            first = block;

        }

        if (first != nil && i != 2){
            // 依赖必须必须不为nil
            [block addDependency:first];
        }
        [_backQueue addOperation:block];
    }
    /*
     阻塞线程
     [_backQueue waitUntilAllOperationsAreFinished];
     NSLog(@"把当前线程阻塞，然后真滴要结束了");
     */

}



- (IBAction)cancelQueue:(id)sender {
    if (_backQueue){
        [_backQueue cancelAllOperations];
    }
}
- (IBAction)clearImages:(id)sender {
    
    for (UIImageView *imageView in self.images) {
        imageView.image = nil;
    }
    
    [_backQueue waitUntilAllOperationsAreFinished];
}

- (void)invocation:(id)obj{
    [self loadImageWithIndex:0 block:nil];
    NSLog(@"this is invocation operation mehtod body, thread = %@",[NSThread currentThread]);
}

- (void)loadImageWithIndex:(NSInteger)index block:(NSBlockOperation *)block{
    NSLog(@"加载图片任务 thread = %@, block operation = %@", [NSThread currentThread], block.name);
    
    UIImageView *imageView = [self.images objectAtIndex:index];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrls[index]]];
    // 在主线程加载图片
    [imageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageWithData:imageData] waitUntilDone:NO];
    
    if ([block.name isEqualToString:@"operation_3"]){
        NSLog(@"队列所有任务完成了");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
