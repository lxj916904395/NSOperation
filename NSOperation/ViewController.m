//
//  ViewController.m
//  NSOperation
//
//  Created by zhongding on 2018/10/23.
//

#import "ViewController.h"
#import "ZFOperation.h"

@interface ViewController ()

@property(assign ,nonatomic) int totalCount;
@property(strong ,nonatomic) NSLock *lock;
@property(strong ,nonatomic) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
        NSOperation 是抽象类不能直接使用,使用的是 NSInvocationOperation、NSBlockOperation,及其子类
     */
  
//    [self queuePriority];
    
    self.queue =  [NSOperationQueue new];
    self.queue.maxConcurrentOperationCount = 2;
//    [self.queue addOperationWithBlock:^{
//        //已经加入队列中的任务无法暂停、取消
//        for (int i = 0; i<1000; i++) {
//            sleep(1);
//            NSLog(@"%d=====%@",i,[NSThread currentThread]);
//        }
//    }];
   
    for (int i = 0; i<1000; i++) {
        [self.queue addOperationWithBlock:^{
            sleep(1);
            NSLog(@"%d=====%@",i,[NSThread currentThread]);
        }];
    }
    
    
}

//取消、暂停
- (IBAction)clickBtn1:(id)sender {
    if(self.queue.operationCount == 0){
        NSLog(@"没有操作执行");
        return;
    }
    
    self.queue.suspended = !self.queue.suspended;
    if (self.queue.suspended) {
       NSLog(@"暂停");
    }else{
        NSLog(@"继续执行");
    }
    
}

//取消全部
- (IBAction)cancelAll:(id)sender {
    [self.queue cancelAllOperations];
    NSLog(@"队列中的操作全部取消");
}

#pragma mark ***************** NSInvocationOperation
- (void)invocationOperation{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationAction) object:nil];
    //开始操作
    [operation start];
}

- (void)invocationAction{
    //在当前线程输出
    NSLog(@"%@",[NSThread currentThread]);
}

#pragma mark ***************** NSBlockOperation
- (void)blockOperation{
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //有可能在主线程或其他线程执行
        NSLog(@"1===%@",[NSThread currentThread]);
    }];
    
    //添加额外操作，操作个数多，则可能开辟新线程同时并发（包括blockOperationWithBlock），开辟线程数由系统决定
    
    //addExecutionBlock 会开辟新线程
    [operation addExecutionBlock:^{
        NSLog(@"2===%@",[NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        NSLog(@"3===%@",[NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        NSLog(@"4===%@",[NSThread currentThread]);
    }];
    
    [operation start];
}

#pragma mark ***************** 自定义operation
- (void)myselfOperation{
    ZFOperation *op = [ZFOperation new];
    [op start];
}

#pragma mark ***************** NSOperation、NSOperationQueue
- (void)operationAddToQueue1{
    /*
        NSOperationQueue 一共有两种队列：主队列、自定义队列。其中自定义队列同时包含了串行、并发功能。
     */
    
    // 主队列获取方法
//    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
//    NSBlockOperation * blockOP = [NSBlockOperation blockOperationWithBlock:^{
//        sleep(2);
//        NSLog(@"1===%@",[NSThread currentThread]);
//    }];
//
//    //即使添加到主队列，也会开辟新线程
//    [blockOP addExecutionBlock:^{
//         NSLog(@"2===%@",[NSThread currentThread]);
//    }];
//
//    [mainQueue addOperation:blockOP];
    
    //自定义queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *invocaop = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocatest) object:nil];
    
    NSBlockOperation *blockop = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2===%@",[NSThread currentThread]);
    }];
    
    [blockop addExecutionBlock:^{
        NSLog(@"3===%@",[NSThread currentThread]);
    }];
    
    //添加操作后，能开辟线程并发执行
    [queue addOperation:invocaop];
    [queue addOperation:blockop];
}

- (void)operationAddToQueue2{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    //会开辟新线程并发
    [queue addOperationWithBlock:^{
        NSLog(@"1===%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"2===%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"3===%@",[NSThread currentThread]);
    }];
}

#pragma mark ***************** 最大并发数

- (void)queueMaxcount{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    /*
     maxConcurrentOperationCount: 最大并发数，maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。
     maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
     maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行。
     maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值
    */
    queue.maxConcurrentOperationCount = 1;

    
    //会开辟新线程并发
    [queue addOperationWithBlock:^{
        NSLog(@"1===%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"2===%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"3===%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"4===%@",[NSThread currentThread]);
    }];
    
    NSInvocationOperation *invocaop = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocatest) object:nil];
    
    NSBlockOperation *blockop = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"6===%@",[NSThread currentThread]);
    }];
    
    [blockop addExecutionBlock:^{
        NSLog(@"7===%@",[NSThread currentThread]);
    }];
    
    
    [queue addOperation:invocaop];
    [queue addOperation:blockop];
}

#pragma mark ***************** 操作依赖、依次执行
- (void)addDependency{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"1===%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(1);
        NSLog(@"2===%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3===%@",[NSThread currentThread]);
        //回到主线程，属于线程之间的通讯
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"回到主线程");
        }];
    }];
    
    //添加依赖，op2依赖op1，即op1执行完才能执行op2
    [op2 addDependency:op1];
    [op3 addDependency:op2];

    //waitUntilFinished 是否等待执行：YES,执行完上面的任务、后面的任务才会执行;NO,直接执行后面的任务，无需等待
    [queue addOperations:@[op1,op2,op3] waitUntilFinished:NO];
    
    NSLog(@"执行完成");
}

#pragma mark ***************** 优先级
- (void)queuePriority{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1===%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2===%@",[NSThread currentThread]);
    }];

    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3===%@",[NSThread currentThread]);
    }];
    
    //添加依赖
    [op3 addDependency:op2];
    
    /*
     queuePriority属性适用于同一操作队列中的操作，不适用于不同操作队列中的操作。
     默认情况下，所有新创建的操作对象优先级都是NSOperationQueuePriorityNormal
     
     NSOperationQueuePriorityVeryLow = -8L,
     NSOperationQueuePriorityLow = -4L,
     NSOperationQueuePriorityNormal = 0,//默认
     NSOperationQueuePriorityHigh = 4,
     NSOperationQueuePriorityVeryHigh = 8
     */
    
    //设置优先级
    op1.queuePriority = NSOperationQueuePriorityNormal;
    op2.queuePriority = NSOperationQueuePriorityVeryLow;
    op3.queuePriority = NSOperationQueuePriorityVeryHigh;
    /*
     1、 op1、op2 无依赖关系， 进入准备就绪状态，op3依赖op2，需等待op2执行；op2的优先级比op1的高，op2优先执行
     2、op2执行完，op3进入准备就绪状态；虽然op1早就处于就绪状态，但op3的优先级>op1，op3先于op1执行
     ***** 优先级只代表 谁先“开始执行”的顺序，而并不是谁先“执行完成”的顺序。
     因为1，2没有依赖关系，所以优于3执行，对于1,2而言，有可能1内部的NSLog执行速度比2快，所以虽然1的优先级低，但执行速度更快一些。所以1、2的输出顺序不确定，但3必定在2后面输出
     */
    
    [queue addOperations:@[op1,op2,op3] waitUntilFinished:YES];
}

#pragma mark ***************** 线程安全
- (void)sellTiket{
    self.totalCount = 50;
    self.lock = [NSLock new];
    
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self sell];
    }];
    
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self sell];
    }];
    
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

- (void)sell{
    //存在不同线程同时调用同一段代码块，造成数据错乱
    while (1) {
        //加锁，同一时间只能一个线程访问
//        [self.lock lock];
        @synchronized (self) {
            
            if (self.totalCount > 0) {
                //如果还有票，继续售卖
                self.totalCount--;
                NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%d 窗口:%@", self.totalCount, [NSThread currentThread]]);
            }
        }
        
        
        // 解锁
//        [self.lock unlock];
        
        if (self.totalCount <= 0) {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
    
}


- (void)invocatest{
    NSLog(@"5===%@",[NSThread currentThread]);
}

@end
