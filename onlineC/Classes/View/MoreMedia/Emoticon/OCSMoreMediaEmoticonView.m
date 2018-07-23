//
//  OCSMoreMediaEmoticonView.m
//  onlineC
//
//  Created by zyd on 2018/7/22.
//

#import "OCSMoreMediaEmoticonView.h"
#import "OCSMoreMediaEmoticonCollectionViewCell.h"

#import "UIColor+OCSExtension.h"
#import "UICollectionViewCell+OCSExtension.h"
#import "UIView+OCSFrame.h"

#import <Masonry.h>

@interface OCSMoreMediaEmoticonView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *topSeparator;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (copy, nonatomic) NSArray *models;

@end

@implementation OCSMoreMediaEmoticonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addSubviews];
    [self layout];
    [self setupData];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.collectionView];
    [self addSubview:self.topSeparator];
    [self addSubview:self.pageControl];
}

- (void)layout {
    [self.topSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@.5f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.pageControl.mas_top);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@30);
    }];
}

- (void)setupData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *models = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 5; i++) {
            NSMutableArray *sectionModels = [[NSMutableArray alloc] init];
            for (NSInteger j = 0; j < 20; j++) {
                NSInteger index = i*20 + j + 1;
                NSString *emoticon = [NSString stringWithFormat:@"emoticon_bq%ld", index];
                [sectionModels addObject:emoticon];
                
//                if (index == 90) {
//                    break;
//                }
            }
            [sectionModels addObject:@"emoticon_delete"];
            [models addObject:[sectionModels copy]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.collectionView) {
                self.models = [models copy];
                [self.collectionView reloadData];
            }
        });
    });
}

#pragma mark - page control event

- (void)handlePageControlEvent:(UIPageControl *)pageControl {
    NSInteger index = pageControl.currentPage;
    CGPoint contentOffset = self.collectionView.contentOffset;
    self.collectionView.contentOffset = CGPointMake(index*self.collectionView.width, contentOffset.y);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.models.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionModels = [self.models objectAtIndex:section];
    return sectionModels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(OCSMoreMediaEmoticonCollectionViewCell.class) forIndexPath:indexPath];
    NSArray *sectionModels = [self.models objectAtIndex:indexPath.section];
    id model = [sectionModels objectAtIndex:indexPath.item];
    [cell refreshWithModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (collectionView.width-collectionViewLayout.itemSize.width*7)/8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (collectionView.height-collectionViewLayout.itemSize.height*3)/4;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat widthSpacing = (collectionView.width-collectionViewLayout.itemSize.width*7)/8;
    CGFloat heightSpacing = (collectionView.height-collectionViewLayout.itemSize.height*3)/4;
    return UIEdgeInsetsMake(heightSpacing, widthSpacing, heightSpacing, widthSpacing);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionModels  = [self.models objectAtIndex:indexPath.section];
    NSString *model = [sectionModels objectAtIndex:indexPath.item];
    
    
    if (indexPath.row == sectionModels.count - 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(moreMediaEmoticonViewDidCancel)]) {
            [self.delegate moreMediaEmoticonViewDidCancel];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(moreMediaEmoticonView:didSelectModel:)]) {
            [self.delegate moreMediaEmoticonView:self didSelectModel:model];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x + scrollView.width/2)/scrollView.width;
    self.pageControl.currentPage = index;
}

#pragma mark - getter methods

- (UIView *)topSeparator {
    if (!_topSeparator) {
        UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        topSeparator.backgroundColor = UIColor.lightGrayColor;
        topSeparator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topSeparator = topSeparator;
    }
    return _topSeparator;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(30, 30);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        [collectionView registerClass:OCSMoreMediaEmoticonCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(OCSMoreMediaEmoticonCollectionViewCell.class)];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = 5;
        pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#CCCCCC"];
        pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        [pageControl addTarget:self action:@selector(handlePageControlEvent:) forControlEvents:UIControlEventValueChanged];
        _pageControl = pageControl;
    }
    return _pageControl;
}

@end
