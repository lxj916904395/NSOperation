//
//  CollectionViewProxy.m
//  NSOperation
//
//  Created by zhongding on 2018/10/24.
//

#import "CollectionViewProxy.h"

#import "UIImageView+ImageCache.h"


@implementation CollectionViewProxy

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    
    CollectionModel *model = self.datas[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.moneyLabel.text = model.money;
    [cell.imageView zf_setImageWithURL:model.imageUrl title:model.title];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return self.datas.count;
}

@end
