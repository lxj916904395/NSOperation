//
//  ZFViewController.m
//  NSOperation
//
//  Created by zhongding on 2018/10/24.
//

#import "ZFViewController.h"

#import "CollectionViewProxy.h"
#import <YYKit.h>

@interface ZFViewController ()
@property(strong ,nonatomic) UICollectionView *collectionView;
@property(strong ,nonatomic) CollectionViewProxy *proxy;
@property(strong ,nonatomic) CollectionViewModel *viewModel;

@end

@implementation ZFViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initUI];
}

- (void)_initUI{
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self)weakSelf = self;
    [self.viewModel loadData:^(NSArray *datas) {
        weakSelf.proxy.datas = datas;
        [weakSelf.collectionView reloadData];
    }];
}


- (CollectionViewProxy*)proxy{
    if (!_proxy) {
        _proxy = [CollectionViewProxy new];
    }
    return _proxy;
}

- (CollectionViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [CollectionViewModel new];
    }
    return _viewModel;
}

- (UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing      = 5;
        layout.minimumLineSpacing           = 5;
        layout.itemSize                     = CGSizeMake((kScreenWidth-15)/2.0, 260);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth-10, kScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate = self.proxy;
        _collectionView.dataSource = self.proxy;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:iden];
    }
    return _collectionView;
}

@end
