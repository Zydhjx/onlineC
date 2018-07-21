//
//  OCSMoreMediaPictureActionSheet.m
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import "OCSMoreMediaPictureActionSheet.h"
#import "OCSMoreMediaPictureActionSheetCell.h"

#import "UIColor+OCSExtension.h"
#import "UITableViewCell+OCSExtension.h"

#import <Masonry.h>

static CGFloat const kTableViewHeight = 162;

@interface OCSMoreMediaPictureActionSheet () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *models;
@property (weak, nonatomic) id<OCSMoreMediaPictureActionSheetDelegate> delegate;

@end

@implementation OCSMoreMediaPictureActionSheet

+ (void)showWithDelegate:(nullable id<OCSMoreMediaPictureActionSheetDelegate>)delegate {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    OCSMoreMediaPictureActionSheet *actionSheet = [[self alloc] initWithFrame:window.bounds];
    actionSheet.delegate = delegate;
    [window addSubview:actionSheet];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setupSelf];
    [self addSubviews];
    [self layout];
    [self setupCornerToTableViewWithBounds:CGRectMake(0, 0, frame.size.width, kTableViewHeight)];
    [self setupData];
    
    return self;
}

- (void)setupSelf {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5f];
}

- (void)addSubviews {
    [self addSubview:self.tableView];
}

- (void)layout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(kTableViewHeight));
    }];
}

- (void)setupCornerToTableViewWithBounds:(CGRect)bounds {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    self.tableView.layer.mask = maskLayer;
}

- (void)setupData {
    self.models = @[@[@"拍照", @"从手机相册选择"],
                    @[@"取消"]];
}

- (void)showInView:(UIView *)view {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

#pragma mark - touches

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.models objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OCSMoreMediaPictureActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(OCSMoreMediaPictureActionSheetCell.class)];
    NSArray *array = [self.models objectAtIndex:indexPath.section];
    NSString *model = [array objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kTableViewHeight - 10)/3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(UITableViewHeaderFooterView.class)];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = [UIColor colorWithHexString:@"#ECEEF1"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedItemAtIndex:)]) {
        if (indexPath.section == 0) {
            [self.delegate actionSheet:self clickedItemAtIndex:indexPath.row];
        } if (indexPath.section == 1) {
            [self.delegate actionSheet:self clickedItemAtIndex:2];
        }
    }
    
    [self removeFromSuperview];
}

#pragma mark - getter methods

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView.new;
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        tableView.scrollEnabled = NO;
        
        [tableView registerClass:OCSMoreMediaPictureActionSheetCell.class forCellReuseIdentifier:NSStringFromClass(OCSMoreMediaPictureActionSheetCell.class)];
        [tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(UITableViewHeaderFooterView.class)];
        
        _tableView = tableView;
    }
    return _tableView;
}

@end
