//
//  ZFOperation.m
//  NSOperation
//
//  Created by zhongding on 2018/10/23.
//

#import "ZFOperation.h"

@implementation ZFOperation
/*
    自定义继承自 NSOperation 的子类,可以通过重写 main 或者 start 方法 来定义自己的 NSOperation 对象。重写main方法比较简单，我们不需要管理操作的状态属性 isExecuting 和 isFinished。当 main 执行完返回的时候，这个操作就结束了
 */
- (void)main{
    //没有添加到 NSOperationQueue,自定义operation 默认在当前线程执行
    
    for (int i= 0; i < 40; i++) {
        
        NSLog(@"%d=====%@",i,[NSThread currentThread]);
    }
}

@end
