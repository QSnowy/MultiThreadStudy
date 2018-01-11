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
@end

@implementation OperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSOperationQueue *backQueue = [[NSOperationQueue alloc] init];
    backQueue.qualityOfService = NSQualityOfServiceBackground;
    backQueue.maxConcurrentOperationCount = 1;
    __weak typeof(self) weakSelf = self;

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i < 5; i ++){
        // @"http://cowo123.com/wp-content/uploads/2018/01/head_03.png"
        NSString *url = [NSString stringWithFormat:@"http://cowo123.com/wp-content/uploads/2018/01/head_0%ld.png",(long)i];
        [array addObject:url];

    }
    _imageUrls = array;

    for (int i = 0; i < 4; i ++) {
        NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf loadImageWithIndex:i];
        }];
        [backQueue addOperation:block];
    }

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
                    [weakSelf loadImageWithIndex:1];
                    NSLog(@"this is block operation execut 1, thread = %@", [NSThread currentThread]);
                }];
                [_blockOperation addExecutionBlock:^{
                    [weakSelf loadImageWithIndex:2];
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
            [_customOperation start];
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

- (void)invocation:(id)obj{
    [self loadImageWithIndex:0];
    NSLog(@"this is invocation operation mehtod body, thread = %@",[NSThread currentThread]);
}

- (void)loadImageWithIndex:(NSInteger)index{
    NSLog(@"加载图片任务 thread = %@", [NSThread currentThread]);
    
    UIImageView *imageView = [self.images objectAtIndex:index];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrls[index]]];
    // 在主线程加载图片
    [imageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageWithData:imageData] waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
