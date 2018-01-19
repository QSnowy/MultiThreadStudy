//
//  GCDVC.m
//  ThreadTest
//
//  Created by ChatLink on 2018/1/3.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import "GCDVC.h"

@interface GCDVC ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;
@property (nonatomic, strong) NSMutableArray *urlArray;

@end

@implementation GCDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i < 5; i ++){

        NSString *url = [NSString stringWithFormat:@"http://cowo123.com/wp-content/uploads/2018/01/head_0%ld.png",(long)i];
        [array addObject:url];
    }
    _urlArray = array;
    
}
- (IBAction)createSer:(id)sender {
    dispatch_queue_t oneQueue = dispatch_queue_create("one", DISPATCH_QUEUE_SERIAL);
    dispatch_async(oneQueue, ^{

        for (int i = 0; i < _images.count; i ++) {
            UIImageView *imgview = _images[i];
            NSString *url = _urlArray[i];
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:[UIImage imageWithData:imgData]];
            });
        }
        NSLog(@"serial queue executing on thread = %@  and operation is done",[NSThread currentThread]);
    });
}



- (IBAction)createConcurrent:(id)sender {
    
    dispatch_queue_t oneQueue = dispatch_queue_create("one", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(oneQueue, ^{
        for (int i = 0; i < _images.count; i ++) {
            UIImageView *imgview = _images[i];
            NSString *url = _urlArray[i];
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:[UIImage imageWithData:imgData]];
            });
        }
        NSLog(@"concurrent queue executing on thread = %@  and operation is done",[NSThread currentThread]);
    });
}
- (IBAction)cleanImgs:(id)sender {
    for (UIImageView *imgView in _images) {
        [imgView setImage:nil];
    }
}

- (void)createThread{
    

    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
