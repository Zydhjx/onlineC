//
//  OCSEvaluationView.m
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import "OCSEvaluationView.h"
#import "OCSNetworkManager.h"
#import "OCSEvaluationStarView.h"
#import "OCSEvaluationOptionsView.h"
#import "OCSEvaluationTextView.h"
#import "OCSEvaluationOptionModel.h"
#import "OCSEvaluationTitleModel.h"

#import "UIColor+OCSExtension.h"
#import "UIView+OCSFrame.h"

#import <Masonry.h>
#import <YYText.h>

/**
 * 评价结果
 */

@interface OCSEvaluationResultView : UIView

@property (strong, nonatomic) UIImageView *resultStatusView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) OCSEvaluationStarView *starView;
@property (strong, nonatomic) OCSEvaluationOptionsView *optionsView;
@property (strong, nonatomic) YYTextView *textView;
@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation OCSEvaluationResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // 添加子视图
    [self addSubviews];
    // 布局
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.resultStatusView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.starView];
    [self addSubview:self.optionsView];
//    [self addSubview:self.textView];
    [self addSubview:self.textLabel];
}

- (void)layout {
    [self.resultStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(33);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultStatusView.mas_bottom).offset(20);
        make.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(23);
        make.left.right.equalTo(self);
        make.height.equalTo(@47);
    }];
    [self.optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.mas_bottom).offset(13);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.optionsView.mas_bottom).offset(5);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.height.mas_greaterThanOrEqualTo(20);
//        make.bottom.equalTo(self.mas_bottom).offset(-15);
//    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.optionsView.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_greaterThanOrEqualTo(20);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
}

#pragma mark - getter methods

- (UIImageView *)resultStatusView {
    if (!_resultStatusView) {
        UIImageView *resultStatusView = [[UIImageView alloc] init];
        resultStatusView.image = [UIImage imageNamed:@"evaluation_status_success_icon"];
        _resultStatusView = resultStatusView;
    }
    return _resultStatusView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"感谢您的评价";
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (OCSEvaluationStarView *)starView {
    if (!_starView) {
        OCSEvaluationStarView *starView = [[OCSEvaluationStarView alloc] init];
        starView.userInteractionEnabled = NO;
        _starView = starView;
    }
    return _starView;
}

- (OCSEvaluationOptionsView *)optionsView {
    if (!_optionsView) {
        OCSEvaluationOptionsView *optionsView = [[OCSEvaluationOptionsView alloc] init];
        optionsView.userInteractionEnabled = NO;
        _optionsView = optionsView;
    }
    return _optionsView;
}

- (YYTextView *)textView {
    if (!_textView) {
        YYTextView *textView = [[YYTextView alloc] init];
        textView.text = @"评价内容：";
//        [textView setTitle:@"评价内容："];
        _textView = textView;
    }
    return _textView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = @"评价内容：";
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _textLabel = textLabel;
    }
    return _textLabel;
}

@end


/**
 * 评价编辑
 */

@interface OCSEvaluationEditView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) OCSEvaluationStarView *starView;
@property (strong, nonatomic) OCSEvaluationOptionsView *optionsView;
@property (strong, nonatomic) OCSEvaluationTextView *textView;
@property (strong, nonatomic) UIView *separatorLine;
@property (strong, nonatomic) UIButton *submitButton;

@property (copy, nonatomic) void (^willSubmitCallback)(void);

@end

@implementation OCSEvaluationEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // 添加子视图
    [self addSubviews];
    // 布局
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.starView];
    [self addSubview:self.optionsView];
    [self addSubview:self.textView];
    [self addSubview:self.separatorLine];
    [self addSubview:self.submitButton];
}

- (void)layout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(24);
        make.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self);
        make.height.equalTo(@47);
    }];
    [self.optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.mas_bottom).offset(6);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.lessThanOrEqualTo(self.optionsView.mas_bottom).offset(16);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@106);
    }];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(14);
        make.left.right.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorLine.mas_bottom).offset(0);
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@50);
    }];
}

#pragma mark - button event

- (void)handleSubmitButtonEvent:(UIButton *)button {
    if (self.willSubmitCallback) {
        self.willSubmitCallback();
    }
}

#pragma mark - getter methods

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = UILabel.new;
        titleLabel.text = @"服务评价";
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (OCSEvaluationStarView *)starView {
    if (!_starView) {
        __weak __typeof(self) weakSelf = self;
        OCSEvaluationStarView *starView = [[OCSEvaluationStarView alloc] init];
        [starView setCallback:^(BOOL shouldHide, NSString *result) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.optionsView.hidden = shouldHide;
            strongSelf.height = shouldHide ? 280 : 390;
            // 重置按钮的状态
            shouldHide ? [strongSelf.optionsView reset] : nil;
        }];
        _starView = starView;
    }
    return _starView;
}

- (OCSEvaluationOptionsView *)optionsView {
    if (!_optionsView) {
        // 暂时由客户端提供数据(数据量小不用担心解析时阻塞的问题)
        NSDictionary *titleDataDictionary = @{@"text": @"请选择不满意项：", @"width": @125, @"height": @20};
        NSArray *optionDataArray = @[@{@"text": @"客服态度不满意", @"width": @128, @"height": @30, @"notSatisfaction": @"01"},
                                     @{@"text": @"问题未解决", @"width": @100, @"height": @30, @"notSatisfaction": @"02"},
                                     @{@"text": @"客服对业务不熟悉", @"width": @140, @"height": @30, @"notSatisfaction": @"03"}];
        NSMutableArray *models = [[NSMutableArray alloc] init];
        
        OCSEvaluationTitleModel *titleModel = [OCSEvaluationTitleModel modelWithDictionary:titleDataDictionary];
        [models addObject:titleModel];
        
        [optionDataArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dictionary, NSUInteger index, BOOL * _Nonnull stop) {
            OCSEvaluationOptionModel *model = [OCSEvaluationOptionModel modelWithDictionary:dictionary];
            [models addObject:model];
        }];
        
        OCSEvaluationOptionsView *optionsView = [[OCSEvaluationOptionsView alloc] init];
        [optionsView setModels:models];
        [optionsView setHidden:YES];
        _optionsView = optionsView;
    }
    return _optionsView;
}

- (OCSEvaluationTextView *)textView {
    if (!_textView) {
        OCSEvaluationTextView *textView = [[OCSEvaluationTextView alloc] init];
        [textView setTitle:@"请输入评价内容："];
        _textView = textView;
    }
    return _textView;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        UIView *separatorLine = UIView.new;
        separatorLine.backgroundColor = [UIColor colorWithHexString:@"#EFF0F0"];
        _separatorLine = separatorLine;
    }
    return _separatorLine;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [submitButton setTitleColor:[UIColor colorWithHexString:@"#0C82F1"] forState:UIControlStateNormal];
        [submitButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [submitButton addTarget:self action:@selector(handleSubmitButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _submitButton = submitButton;
    }
    return _submitButton;
}

@end


@interface OCSEvaluationView ()

@property (strong, nonatomic) OCSEvaluationEditView *editView;
@property (strong, nonatomic) OCSEvaluationResultView *resultView;
@property (assign, nonatomic) CGFloat movedDistance;

@end

@implementation OCSEvaluationView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

+ (instancetype)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    id view = [[self alloc] initWithFrame:window.bounds];
    [window addSubview:view];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // 配置内部属性
    [self setupSelf];
    
    // 添加子视图
    [self addSubviews];
    
    // 布局
    [self layout];
    
    // 添加通知
    [self addNotification];
    
    return self;
}

- (void)setupSelf {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5f];
}

- (void)addSubviews {
    [self addSubview:self.editView];
    [self addSubview:self.resultView];
}

- (void)layout {
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@285);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Notification

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardMinY = CGRectGetMinY(keyboardRect);
    CGFloat selfMaxY = CGRectGetMaxY(self.editView.frame);
    
    if (selfMaxY > keyboardMinY) {
        self.movedDistance = selfMaxY - keyboardMinY;
        self.editView.y -= self.movedDistance;
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    if (self.movedDistance > 0) {
        self.editView.y += self.movedDistance;
    }
}

//#pragma mark - touches
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint location = [[touches anyObject] locationInView:self];
//    CGPoint pointInEditView = [self.editView convertPoint:location fromView:self];
//    CGPoint pointInResultView = [self.resultView convertPoint:location fromView:self];
//    if ([self.editView pointInside:pointInEditView withEvent:event]) {
//        [self.editView endEditing:YES];
//    } if ([self.resultView pointInside:pointInResultView withEvent:event]) {
//
//    } else {
//        [self removeFromSuperview];
//    }
//}

#pragma mark - hit test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
//    CGPoint pointInEditView = [self.editView convertPoint:point fromView:self];
//    if ([self.editView pointInside:pointInEditView withEvent:event]) {
//        [self.editView endEditing:YES];
//        return view;
//    }

    if ([view isEqual:self]) {
        [self removeFromSuperview];
    } else {
        [self.editView endEditing:YES];
    }
//    CGPoint pointInEditView = [self convertPoint:point toView:self.editView];
//    CGPoint pointInResultView = [self convertPoint:point toView:self.resultView];
//    if (CGRectContainsPoint(self.editView.bounds, pointInEditView)) {
//        [self.editView endEditing:YES];
//    } else if (CGRectContainsPoint(self.resultView.bounds, pointInResultView)) {
//
//    } else {
//        [self removeFromSuperview];
//    }

    return view;
}

#pragma mark - getter methods

- (OCSEvaluationEditView *)editView {
    if (!_editView) {
        OCSEvaluationEditView *editView = [[OCSEvaluationEditView alloc] init];
        editView.frame = CGRectMake(0, 0, 285, 280);
        editView.center = self.center;
        editView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        editView.layer.cornerRadius = 5.0f;
        editView.layer.masksToBounds = YES;
        
        __weak __typeof(self) weakSelf = self;
        [editView setWillSubmitCallback:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            // 获取满意度类型(一定有值)
            NSString *satisfactionType = strongSelf.editView.starView.satisfactionType;
            // 获取不满意选项
            NSString *notSatisfaction = strongSelf.editView.optionsView.notSatisfaction;
            // 获取评价内容
            NSString *appraiseContent = strongSelf.editView.textView.appraiseContent;
            
//            NSUUID *uuid = [NSUUID UUID];
//            NSDictionary *parameters = @{@"empNo": @"s00000",
//                                         @"chatId": uuid.UUIDString,
//                                         @"fromNo": @"1234",
//                                         @"satisfactionSourse": @"03",
//                                         @"satisfactionType": satisfactionType,
//                                         @"notSatisfaction": notSatisfaction,
//                                         @"appraiseContent": appraiseContent};
//            [OCSNetworkManager satisfactionWithParameters:parameters completion:^(id responseObject, NSError *error) {
//
//            }];
            
            NSMutableArray *models = [[NSMutableArray alloc] init];
            NSDictionary *titleDataDictionary = @{@"text": @"不满意项：", @"width": @75, @"height": @20};
            NSDictionary *optionDataDictionary= @{@"01": @{@"text": @"客服态度不满意", @"width": @128, @"height": @30, @"notSatisfaction": @"01"},
                                                  @"02": @{@"text": @"问题未解决", @"width": @100, @"height": @30, @"notSatisfaction": @"02"},
                                                  @"03": @{@"text": @"客服对业务不熟悉", @"width": @140, @"height": @30, @"notSatisfaction": @"03"}};
            OCSEvaluationTitleModel *titleModel = [OCSEvaluationTitleModel modelWithDictionary:titleDataDictionary];
            [models addObject:titleModel];
            if (notSatisfaction.length > 0) {
                NSArray *notSatisfactionArray = [notSatisfaction componentsSeparatedByString:@"&-&"];
                [notSatisfactionArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger index, BOOL * _Nonnull stop) {
                    NSDictionary *dictionary = [optionDataDictionary valueForKey:key];
                    OCSEvaluationOptionModel *model = [OCSEvaluationOptionModel modelWithDictionary:dictionary];
                    [models addObject:model];
                }];
            }
            
            strongSelf.resultView.starView.satisfactionType = satisfactionType;
            [strongSelf.resultView.optionsView setModels:models];
            [strongSelf.resultView.optionsView reloadData];
            [strongSelf.resultView.optionsView allSelected];
            appraiseContent = [strongSelf.resultView.textLabel.text stringByAppendingString:appraiseContent];
            [strongSelf.resultView.textLabel setText:appraiseContent];
            strongSelf.editView.hidden = YES;
            strongSelf.resultView.hidden = NO;
        }];
        
        _editView = editView;
    }
    return _editView;
}

- (OCSEvaluationResultView *)resultView {
    if (!_resultView) {
        OCSEvaluationResultView *resultView = [[OCSEvaluationResultView alloc] init];
        resultView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        resultView.layer.cornerRadius = 5.0f;
        resultView.layer.masksToBounds = YES;
        resultView.hidden = YES;
        _resultView = resultView;
    }
    return _resultView;
}

@end
