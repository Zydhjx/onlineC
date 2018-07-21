//
//  OCSMoreMediaToolView.m
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import "OCSMoreMediaToolView.h"
#import "OCSMoreMediaCollectionViewCell.h"
#import "OCSMoreMediaModel.h"

#import "UICollectionViewCell+OCSExtension.h"
#import "UIColor+OCSExtension.h"
#import "UIView+OCSFrame.h"

#import <Masonry.h>

@interface OCSMoreMediaCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat maximumInteritemSpacing;

@end

@implementation OCSMoreMediaCollectionViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    // 横向间隔
    CGFloat widthSpacing = (self.collectionView.width - layoutAttributes.count*self.itemSize.width)/(layoutAttributes.count + 1);
    // 纵向间隔
    CGFloat heightSpacing = (self.collectionView.height - self.itemSize.height)/2;
    
    [layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull layoutAttributes, NSUInteger index, BOOL * _Nonnull stop) {
        CGRect frame = layoutAttributes.frame;
        frame.origin.x = index*(self.itemSize.width + widthSpacing) + widthSpacing;
        frame.origin.y = heightSpacing;
        layoutAttributes.frame = frame;
    }];
    return layoutAttributes;
}

@end


@interface OCSMoreMediaToolView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *topSeparator;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy, nonatomic) NSArray *models;
@property (assign, nonatomic) OCSMoreMediaToolType type;

@end

@implementation OCSMoreMediaToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addSubviews];
    [self layout];
    [self setType:OCSMoreMediaToolTypeRobotService];
    
    return self;
}

- (void)setType:(OCSMoreMediaToolType)type {
    _type = type;
    [self setupDataWithType:type];
    [self.collectionView reloadData];
}

- (void)setupDataWithType:(OCSMoreMediaToolType)type {
    NSArray *dataArray = nil;
    if (type == OCSMoreMediaToolTypeRobotService) {
        dataArray = @[@{@"imageName": @"media_emoticon_icon", @"text": @"转人工"}];
    } else {
        dataArray = @[@{@"imageName": @"media_emoticon_icon", @"text": @"表情"},
                      @{@"imageName": @"media_picture_icon", @"text": @"图片"},
                      @{@"imageName": @"media_positioning_icon", @"text": @"定位"},
                      @{@"imageName": @"media_ending_icon", @"text": @"结束"}];
    }
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger index, BOOL * _Nonnull stop) {
        OCSMoreMediaModel *model = [OCSMoreMediaModel modelWithDictionary:dictionary];
        [models addObject:model];
    }];
    self.models = [models copy];
}

- (void)addSubviews {
    [self addSubview:self.collectionView];
    [self addSubview:self.topSeparator];
}

- (void)layout {
    [self.topSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@.5f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setToolType:(OCSMoreMediaToolType)toolType {
    self.type = toolType;
}

- (OCSMoreMediaToolType)toolType {
    return self.type;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OCSMoreMediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(OCSMoreMediaCollectionViewCell.class) forIndexPath:indexPath];
    [cell refreshWithModel:self.models[indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OCSMoreMediaToolServiceType serviceType = OCSMoreMediaToolServiceTypeNone;
    if (indexPath.item == 0) {
        serviceType = (self.type == OCSMoreMediaToolTypeRobotService) ? OCSMoreMediaToolServiceTypeTurnToHuman : OCSMoreMediaToolServiceTypeEmoticon;
    } else if (indexPath.item == 1) {
        serviceType = OCSMoreMediaToolServiceTypePicture;
    } else if (indexPath.item == 2) {
        serviceType = OCSMoreMediaToolServiceTypePosition;
    } else if (indexPath.item == 3) {
        serviceType = OCSMoreMediaToolServiceTypeEnd;
    }
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didSelectServiceType:)]) {
        [self.delegate didSelectServiceType:serviceType];
    }
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
        OCSMoreMediaCollectionViewFlowLayout *flowLayout = [[OCSMoreMediaCollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(60, 80);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        [collectionView registerClass:OCSMoreMediaCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(OCSMoreMediaCollectionViewCell.class)];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
