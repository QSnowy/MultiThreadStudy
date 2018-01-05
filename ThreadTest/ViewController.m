//
//  ViewController.m
//  ThreadTest
//
//  Created by ChatLink on 2018/1/3.
//  Copyright © 2018年 ChatLink. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSArray arrayWithObjects:@"pthead", @"NSThead", @"NSOperation", @"GCD", nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated{
    NSDate *date = [NSDate date];
//    NSLog(@"end time = %@",date);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        { [self performSegueWithIdentifier:@"pthread" sender:nil]; }
            break;
            
        case 1:
        { [self performSegueWithIdentifier:@"thread" sender:nil]; }
            break;
            
        case 2:
        { [self performSegueWithIdentifier:@"operation" sender:nil]; }
            break;
            
        case 3:
        { [self performSegueWithIdentifier:@"gcd" sender:nil]; }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
