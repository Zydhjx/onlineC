//
//  OCSEvaluationOptionsView.m
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import "OCSEvaluationOptionsView.h"
#import "OCSEvaluationOptionsCollectionViewOptionCell.h"
#import "OCSEvaluationOptionsCollectionViewTitleCell.h"
#import "OCSEvaluationModel.h"
#import "OCSEvaluationOptionModel.h"

#import "UIColor+OCSExtension.h"
#import "UICollectionViewCell+OCSExtension.h"

#import <Masonry.h>

/**
 * 布局类
 */

@interface OCSEvaluationOptionsCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat maximumInteritemSpacing;

@end

@implementation OCSEvaluationOptionsCollectionViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    [layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull currentLayoutAttributes, NSUInteger index, BOOL * _Nonnull stop) {
        if (index == 0) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = 0;
            currentLayoutAttributes.frame = frame;
        }
        
        if (index < layoutAttributes.count - 1) {
            NSInteger currentMaxX = CGRectGetMaxX(currentLayoutAttributes.frame);
            UICollectionViewLayoutAttributes *nextLayoutAttributes = layoutAttributes[index + 1];
            
            if (currentMaxX + self.maximumInteritemSpacing + nextLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
                //满足则给当前cell的frame属性赋值（不满足的cell会根据系统布局换行）
                CGRect frame = nextLayoutAttributes.frame;
                frame.origin.x = currentMaxX + self.maximumInteritemSpacing;
                nextLayoutAttributes.frame = frame;
            } else {
                CGRect frame = nextLayoutAttributes.frame;
                frame.origin.x = 0;
                nextLayoutAttributes.frame = frame;
            }
        }
    }];
    return layoutAttributes;
}

- (CGFloat)maximumInteritemSpacing {
    return MAX(_maximumInteritemSpacing, self.minimumInteritemSpacing);
}

@end


@interface OCSEvaluationOptionsCollectionView : UICollectionView

@end

@implementation OCSEvaluationOptionsCollectionView

// 自适应大小
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    return self.contentSize;
}

@end


@interface OCSEvaluationOptionsView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) OCSEvaluationOptionsCollectionView *collectionView;
@property (copy, nonatomic) NSArray *models;

@end

@implementation OCSEvaluationOptionsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.collectionView];
}

- (void)layout {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setModels:(NSArray *)models {
    _models = [models copy];
}

- (void)reset {
    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull indexPath, NSUInteger index, BOOL * _Nonnull stop) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }];
}

- (void)allSelected {
    [self.models enumerateObjectsUsingBlock:^(OCSEvaluationOptionModel * _Nonnull model, NSUInteger index, BOOL * _Nonnull stop) {
        if (index > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OCSEvaluationModel *model = self.models[indexPath.item];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:model.cellIdentifier forIndexPath:indexPath];
    [cell refreshWithModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    OCSEvaluationModel *model = self.models[indexPath.item];
    return CGSizeMake(model.width, model.height);
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item != 0;
}

#pragma mark - getter methods

- (OCSEvaluationOptionsCollectionView *)collectionView {
    if (!_collectionView) {
        OCSEvaluationOptionsCollectionViewFlowLayout *flowLayout = [[OCSEvaluationOptionsCollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 7;
        flowLayout.minimumInteritemSpacing = 7;
        flowLayout.maximumInteritemSpacing = 7;
        
        OCSEvaluationOptionsCollectionView *collectionView = [[OCSEvaluationOptionsCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.allowsMultipleSelection = YES;
        collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        [collectionView registerClass:OCSEvaluationOptionsCollectionViewTitleCell.class forCellWithReuseIdentifier:NSStringFromClass(OCSEvaluationOptionsCollectionViewTitleCell.class)];
        [collectionView registerClass:OCSEvaluationOptionsCollectionViewOptionCell.class forCellWithReuseIdentifier:NSStringFromClass(OCSEvaluationOptionsCollectionViewOptionCell.class)];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSString *)notSatisfaction {
    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull indexPath, NSUInteger index, BOOL * _Nonnull stop) {
        OCSEvaluationOptionModel *model = self.models[indexPath.item];
        [mutableString appendString:model.notSatisfaction];
        if (index < indexPaths.count - 1) {
            [mutableString appendString:@"&-&"];
        }
    }];
    return [mutableString copy];
}

@end
