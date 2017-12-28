//
//  SecondViewController.m
//  ActionTest
//
//  Created by 张 君鹏 on 2017/12/9.
//  Copyright © 2017年 general. All rights reserved.
//

#import "SecondViewController.h"

typedef void(^TestBlock)(int);

@interface SecondViewController ()

@property (nonatomic,assign)    NSInteger tag ;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonAction:(id)sender {
    
    [self setTheThreadTest];
    
    [self testTheBlock];
}

//-(void)setTheThreadTest
//{
//    NSLog(@"-----------------1111");
//    
//    dispatch_queue_t  queue = dispatch_get_main_queue();
//    dispatch_async(queue, ^{
//        NSLog(@"--------------22222");
//    });
//    NSLog(@"---------333333");
//}

-(void)setTheThreadTest
{
    NSLog(@"-----------------1111");
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"--------------22222");
    });
    NSLog(@"---------333333");
    
    
//    NSInteger teger = 1 ;
//    self.tag = 2 ;
//    __weak typeof (self) weakSelf = self ;
//    NSOperationQueue * que = [[NSOperationQueue alloc] init];
//    [que addOperationWithBlock:^{
//        
//        weakSelf.tag = 5;
//        teger = 2;
//    }];
    
    
    
}

-(void)testTheBlock
{
    NSMutableArray *mArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"abc",nil];
    NSMutableArray *mArrayCount = [NSMutableArray arrayWithCapacity:1];
    [mArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock: ^(id obj,NSUInteger idx, BOOL *stop){
        [mArrayCount addObject:[NSNumber numberWithInt:[obj length]]];
        
        NSLog(@"---------------aaaaa-- %@",mArrayCount);

    }];
    
    NSLog(@"%@",mArrayCount);
    
//    __block int multiplier = 7;
//
//    TestBlock testblock = ^(int num)
//    {
//        multiplier ++;//这样就可以了
//        NSLog(@"------- num = %zd",num * multiplier);
//    };
//    
//    testblock(3);
//     log 结果为24
    
    NSLog(@"%@",mArrayCount);
    
    int multiplier = 7;
    int *p = &multiplier;// 利用指针p存储a的地址
    
    TestBlock testblock = ^(int num)
    {
        *p = *p +1;// 通过a的地址设置a的值
        
        NSLog(@"-----*p = %zd-- num = %zd - all = %zd",*p,num,*p * num);
    };
    
    testblock(3);
    // log 结果为 24
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
