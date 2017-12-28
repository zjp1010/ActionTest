//
//  FirstViewController.m
//  ActionTest
//
//  Created by 张 君鹏 on 2017/12/9.
//  Copyright © 2017年 general. All rights reserved.
//

#import "FirstViewController.h"
#import <Foundation/Foundation.h>
#import "SecondViewController.h"

@interface FirstViewController ()

@property (nonatomic,strong) NSBlockOperation * blockOp ;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRequest];
    
    
    self.blockOp = [NSBlockOperation blockOperationWithBlock:
                                  ^{
                                      [self testThread5];
                                  }];
    
    [self testTheThread];
    
    [self.blockOp start];


    
//    [self testDispatch];
}


-(void)setRequest
{
    NSString * urlString = @"https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_17125774454092323546%22%7D&n_type=0&p_from=1" ;
    NSURL * url = [NSURL URLWithString: urlString];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url
                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                               timeoutInterval:20];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    NSURLSession * urlsession = [NSURLSession sharedSession] ;
//    NSURLSession * urlsession = [NSURLSession sessionWithConfiguration:configuration] ;
    NSURLSession * urlsession = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    // 当把session的delegatequeue添加到主队列后 返回数据block为主线程  否则为其他线程
    NSURLSessionDataTask * dataTask =  [urlsession dataTaskWithRequest:request
                                                     completionHandler:
                                        ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            NSLog(@"+++++ %@",[NSThread currentThread]);
                                            if (error.code == 0)
                                            {
                                                if (response) {
                                                    NSHTTPURLResponse * re = (NSHTTPURLResponse *)response;
                                                    NSLog(@"-------response = %ld",re.statusCode);
                                                }
                                                
                                            }
                                            else
                                            {
                                                
                                            }
                                        }];
    [dataTask resume ];
    
    
}


-(void)testTheThread
{
//    NSOperationQueue * queue = [NSOperationQueue currentQueue] ;
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
//    [queue setMaxConcurrentOperationCount: 1];
    
    NSInvocationOperation * invocationOpera = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testThread1) object:nil];
    
    NSInvocationOperation * invocationOpera2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testThread2) object:nil];
    
    NSBlockOperation * blockOp = [NSBlockOperation blockOperationWithBlock:
                                  ^{
                                      
                                      [self testThread3];
                                  }];
    
    NSBlockOperation * blockOp2 = [NSBlockOperation blockOperationWithBlock:
                                  ^{
                                      [NSThread sleepForTimeInterval:3];
                                      [self testThread4];
                                  }];
    
    // 添加依赖
    [blockOp addDependency:blockOp2];
    [invocationOpera2 addDependency:blockOp];
    [invocationOpera addDependency:invocationOpera2];
    
    
//    [queue addOperation:invocationOpera];
    [queue addOperation:invocationOpera2];
    [queue addOperation:blockOp];
    [queue addOperation:blockOp2];
    
    [[NSOperationQueue mainQueue] addOperation:invocationOpera];
    
    // 添加等待 之后的代码要等待队列执行完后 才能执行
    [queue waitUntilAllOperationsAreFinished];
    
    NSLog(@"lsdjflasjflsajdfj");
    
}

-(void)testThread1
{

    NSLog(@"testThread1 ---------- %@",[NSThread currentThread]);
}

-(void)testThread2
{
    NSLog(@"testThread2 ---------- %@",[NSThread currentThread]);

}

-(void)testThread3
{
    NSLog(@"testThread3 ---------- %@",[NSThread currentThread]);

}

-(void)testThread4
{
    NSLog(@"testThread4 ---------- %@",[NSThread currentThread]);

}

-(void)testThread5
{
    NSLog(@"testThread5 ---------- %@",[NSThread currentThread]);
    
}


-(void)testDispatch
{
//    dispatch_queue_t  queue_t = dispatch_get_global_queue(@"com.sdalfsalfj.sdafsdf", DISPATCH_TARGET_QUEUE_DEFAULT );
    dispatch_queue_t  queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0 );
//    dispatch_queue_t queue_t = dispatch_get_main_queue();
    
    for (int i = 0; i < 30; i++)
    {
        dispatch_async(queue_t, ^{
            NSLog(@" %@",[NSThread currentThread]);
        });
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
