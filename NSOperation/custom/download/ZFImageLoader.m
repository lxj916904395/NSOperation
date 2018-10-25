//
//  ZFImageLoader.m
//  NSOperation
//
//  Created by zhongding on 2018/10/24.
//

#import "ZFImageLoader.h"
#import "NSString+ImageCache.h"
#import "ZFImageDownloadOperation.h"

@interface ZFImageLoader()
//内存缓存
@property(strong ,nonatomic) NSMutableDictionary *imageDict;
//存储下载操作
@property(strong ,nonatomic) NSMutableDictionary *operationDict;

//存储同一下载地址的请求回调
@property(strong ,nonatomic) NSMutableDictionary *handleDict;


@property(strong ,nonatomic) NSOperationQueue *queue;

@end


@implementation ZFImageLoader

+ (instancetype)loader{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

// 只要调用单利,就会来到这里 那么我就可以在这里做一系列的初始化
- (instancetype)init{
    if (self=[super init]) {
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 3;
        // 注册内存警告通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)loadImageWithUrl:(NSString*)urlstring
              complement:(CompleteHandleBlock)complementBlock
                   title:(NSString*)title{
    
    if(urlstring == nil || urlstring.length<=0)return;
    
    UIImage *image = nil;
    
    //内存缓存有数据
    if (self.imageDict[urlstring]) {
        NSLog(@"内存读取数据");
        image = self.imageDict[urlstring];
        complementBlock(image,nil);
        return;
    }
    
    //沙盒存在下载好的数据
    NSData *data = [NSData dataWithContentsOfFile:[urlstring getDowloadImagePath]];
    if (data) {
        NSLog(@"沙盒读取数据");
        image = [UIImage imageWithData:data];
        self.imageDict[urlstring] = image;
        complementBlock(image,nil);
        return;
    }
    
    if (self.operationDict[urlstring]) {
        NSLog(@"正在下载...%@",title);
        
        NSMutableArray *array = self.handleDict[urlstring];
        if (!array) {
            array = [NSMutableArray new];
        }
        [array addObject:complementBlock];
        self.handleDict[urlstring] = array;
        return;
    }
    ZFImageDownloadOperation *op = [[ZFImageDownloadOperation alloc] initWithUrl:urlstring complementHandle:^(NSData *imageData, NSString *urlString) {
        UIImage * image = [UIImage imageWithData:imageData];
        if (image) {
            [self.operationDict removeObjectForKey:urlstring];
            self.imageDict[urlstring] = image;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                complementBlock(image,nil);
                NSMutableArray *array = self.handleDict[urlstring];
                for (CompleteHandleBlock block in array) {
                    block(image,urlstring);
                }
            }];
        }
        
    } title:title error:^(NSString *urlString) {
        [self cancelDownloadImageWithUrlString:urlString];
    }];
   
    [_queue addOperation:op];
    [self.operationDict setObject:op forKey:urlstring];
}

// 下载操作取消
- (void)cancelDownloadImageWithUrlString:(NSString *)urlString{
    ZFImageDownloadOperation *op = self.operationDict[urlString];
    [op cancel];
    
    // 对于那些简约的dog 这个下载决定后面的下载 如果第一张取消,意味着后面就没了!
    [self.operationDict removeObjectForKey:urlString];
    [self.handleDict removeObjectForKey:urlString];
    

    
    //    // 对于那些简约的dog 这个下载决定后面的下载 如果第一张取消,意味着后面就没了!
    //    [self.operationDict removeObjectForKey:urlString];
    //    [self.handleDict removeObjectForKey:urlString];
}

- (NSMutableDictionary*)imageDict{
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary new];
    }
    return _imageDict;
}

- (NSMutableDictionary*)operationDict{
    if (!_operationDict) {
        _operationDict = [NSMutableDictionary new];
    }
    return _operationDict;
}

- (NSMutableDictionary*)handleDict{
    if (!_handleDict) {
        _handleDict = [NSMutableDictionary new];
    }
    return _handleDict;
}


#pragma mark - memoryWarning
- (void)memoryWarning{
    NSLog(@"收到内存警告,你要清理内存了!!!");
    [self.imageDict removeAllObjects];
    //已经有内存警告就不能在执行操作
    [self.queue cancelAllOperations];
    //清空操作
    [self.operationDict removeAllObjects];
    //操作缓存也清除
    [self.handleDict removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}


@end
