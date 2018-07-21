//
//  OCSSessionViewController.m
//  onlineC
//
//  Created by zyd on 2018/7/11.
//

#import "OCSSessionViewController.h"
#import "OCSMessageCell.h"
#import "OCSWelcomeCell.h"
#import "OCSLinksCell.h"
#import "OCSTextCell.h"
#import "OCSPictureCell.h"
#import "OCSPictureWordCell.h"
#import "OCSUserChatTextCell.h"
#import "OCSQueueTextCell.h"
#import "OCSPromptCell.h"
#import "OCSSessionEndCell.h"
#import "OCSUserChatPictureCell.h"
#import "OCSInputToolBar.h"
#import "OCSEvaluationView.h"
#import "OCSNetworkManager.h"
#import "OCSModel.h"
#import "OCSLinksModel.h"
#import "OCSWelcomeModel.h"
#import "OCSUserChatTextModel.h"
#import "OCSTextModel.h"
#import "OCSQueueTextModel.h"
#import "OCSPromptModel.h"
#import "OCSSessionEndModel.h"
#import "OCSUserChatPictureModel.h"
#import "OCSMoreMediaToolView.h"
#import "OCSMoreMediaPictureActionSheet.h"
#import "OCSTiming.h"
#import "OCSLinksHandler.h"
#import "OCSMoreMediaPictureActionSheet.h"

#import "UIColor+OCSExtension.h"
#import "UIView+OCSFrame.h"
#import "UITableViewCell+OCSExtension.h"
#import "UITableView+OCSExtension.h"
#import "NSString+OCSExtension.h"
#import "NSDictionary+OCSExtension.h"
#import "UIImage+OCSExtension.h"

#import <MJRefresh.h>
#import <Masonry.h>
#import <SocketRocket.h>
#import <NSAttributedString+YYText.h>

NSString * const OCSSessionHandleLinksEventNotification = @"OCSSessionHandleLinksEventNotification";

@interface OCSSessionTableView : UITableView

@property (copy, nonatomic) dispatch_block_t touchesEnded;

@end

@implementation OCSSessionTableView

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchesEnded) {
        self.touchesEnded();
    }
}

@end


@interface OCSSessionViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, OCSTimingDelegate, SRWebSocketDelegate, OCSMoreMediaToolViewDelegate, OCSMoreMediaPictureActionSheetDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) OCSSessionTableView *tableView;
@property (strong, nonatomic) MJRefreshHeader *refreshHeader;
@property (strong, nonatomic) OCSInputToolBar *inputToolBar;
@property (strong, nonatomic) OCSMoreMediaToolView *moreMediaToolView;
@property (copy, nonatomic) NSArray *models;
@property (assign, nonatomic) BOOL isShowingKeyboard;

// 相片
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

// 排队计时器
@property (strong, nonatomic) OCSTiming *timing;

// websocket
@property (strong, nonatomic) SRWebSocket *webSocket;

// 临时变量 队伍编号
@property (copy, nonatomic) NSString *queueId;

// 坐席状态
@property (assign, nonatomic) BOOL hasSeatID;

@end

@implementation OCSSessionViewController

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // 注册链接通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLinksEventNotification:)
                                                 name:OCSSessionHandleLinksEventNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 销毁排队计时器
    [self.timing destroy];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OCSSessionHandleLinksEventNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 配置内部属性
    [self setupSelf];
    
    // 配置导航栏
    [self setupNavigationItem];
    
    // 添加子视图
    [self addSubviews];
    
    // 布局
    [self layout];
    
    // 初始化数据
    self.models = @[];
    
    // test
    [self.moreMediaToolView setToolType:OCSMoreMediaToolTypeHumanService];
    
    /*
     *  接入
     */
    NSDictionary *parameters = @{@"userId": @"lily",
                                 @"nickName": @"小黑鼠",
                                 @"userTel": @"15636001234",
                                 @"vipLevel": @10,
                                 @"adress": @"110102",
                                 @"remarks": @"2342356|32101"};
    __weak __typeof(self) weakSelf = self;
    [OCSNetworkManager accessWithParameters:parameters completion:^(id responseObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf insertModel:responseObject completion:^{
            [strongSelf robotChatEvent];
        }];
    }];
}

- (void)robotChatEvent {
    /*
     *  欢迎语获取
     */
    NSDictionary *parameters = @{@"chatId": @"131023345567",
                                 @"userId": @"131023345567",
                                 @"consNo": @"",
                                 @"sessionCount": @"01",
                                 @"question": @"welcomMobMsg"};
    __weak __typeof(self) weakSelf = self;
    [OCSNetworkManager robotChatWithParameters:parameters completion:^(id responseObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf insertModel:responseObject completion:nil];
    }];
}

- (void)setupSelf {
    self.view.backgroundColor = UIColor.whiteColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)setupNavigationItem {
    UILabel *label = UILabel.new;
    label.text = @"在线客服";
    label.font = [UIFont systemFontOfSize:18.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    self.navigationItem.titleView = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:CGSizeMake(44, 44)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button setImage:[[UIImage imageNamed:@"back_button_icon"] imageScaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleLeftBarButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    self.imagePickerController.sourceType = sourceType;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)addSubviews {
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.moreMediaToolView];
    [self.backgroundView addSubview:self.tableView];
    [self.backgroundView addSubview:self.inputToolBar];
    
    [self.tableView setMj_header:self.refreshHeader];
}

- (void)layout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backgroundView);
        make.bottom.equalTo(self.inputToolBar.mas_top);
    }];
    [self.inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.backgroundView);
        make.height.equalTo(@44.0f);
    }];
    [self.moreMediaToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
}

#pragma mark - 插入模型

- (void)insertSessionEndModel {
    NSMutableAttributedString *totalAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [NSString stringWithFormat:@"%@\n\n", [dateFormatter stringFromDate:date]];
    NSDictionary *dateAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f],
                                     NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#5C5C5C"]};
    NSAttributedString *dateAttributedString = [[NSAttributedString alloc] initWithString:dateString attributes:dateAttributes];
    [totalAttributedString appendAttributedString:dateAttributedString];
    
    NSDictionary *contentAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                        NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FC6D53"]};
    NSAttributedString *contentAttributedString = [[NSAttributedString alloc] initWithString:@"会话结束" attributes:contentAttributes];
    [totalAttributedString appendAttributedString:contentAttributedString];
    
    OCSSessionEndModel *model = [OCSSessionEndModel modelWithDictionary:@{@"content": [totalAttributedString copy]}];
    [self insertModel:model completion:nil];
}

- (void)insertModel:(id)model completion:(dispatch_block_t)completion {
    if (model && self.tableView) {
        NSMutableArray *models = [self.models mutableCopy];
        [models addObject:model];
        self.models = [models copy];
        
        NSInteger row = [self.tableView numberOfRowsInSection:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    completion ? completion() : nil;
}

#pragma mark - 键盘和更多菜单显示隐藏相关方法

- (BOOL)isShowingMoreMediaToolView {
    return (self.backgroundView.height == self.view.height - 184) && (self.moreMediaToolView.isHidden == NO);
}

- (void)showMoreMediaToolView {
    // 184 = 64 + 120   120是MoreMediaToolView的高度
    self.moreMediaToolView.hidden = NO;
    self.backgroundView.height = self.view.height - 184;
}

- (void)showKeyboardWithHeight:(CGFloat)KeyboardHeight {
    self.moreMediaToolView.hidden = YES;
    self.backgroundView.height = self.view.height - KeyboardHeight - 64;
}

- (void)recoverBackgroundView {
    BOOL isShowing = [self isShowingMoreMediaToolView];
    self.moreMediaToolView.hidden = !isShowing;
    self.backgroundView.height = self.view.height - 64;
}

#pragma mark - notification events

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardRect);
    
    [self showKeyboardWithHeight:keyboardHeight];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    [self recoverBackgroundView];
}

- (void)handleLinksEventNotification:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
    NSDictionary *dictionary = notification.object;
    OCSLinksEventType eventType = ((NSNumber *)[dictionary valueForKey:@"eventType"]).unsignedIntegerValue;
    NSString *actionType = [dictionary valueForKey:@"actionType"];
    NSString *href = [dictionary valueForKey:@"href"];
    
    if (eventType == OCSLinksEventTypeTurnToHumanService &&
        self.moreMediaToolView.toolType == OCSMoreMediaToolTypeRobotService) {
        [self handleMoreMediaToolServiceTypeTurnToHumanEvent];
    } else if (eventType == OCSLinksEventTypeAppInner) {
        
    } else if (eventType == OCSLinksEventTypeAssociatedProblem &&
               self.moreMediaToolView.toolType == OCSMoreMediaToolTypeRobotService) {
        NSString *question = [href substringFromIndex:2];
        [self robotChatWithQuestion:question];
    } else if (eventType == OCSLinksEventTypeURL) {
        NSString *URLString = [href substringFromIndex:2];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
    
    // 用户动作记录
    NSDictionary *parameters = @{@"sessionUid": @"",
                                 @"actionType": [NSString stringWithFormat:@"%@&-&%@", actionType, href]};
    
}

#pragma mark - button events

- (void)handleLeftBarButtonItemEvent:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleRefreshHeaderEvent:(MJRefreshNormalHeader *)refreshHeader {
    NSDictionary *parameters = @{@"chatDetailId": @"1531813464404",
                                 @"contentType": @"01",
                                 @"content": @"",
                                 @"toNo": @"1234",
                                 @"fromNo": @"2345",
                                 @"selectCount": @1};
    [OCSNetworkManager chatRecordWithParameters:parameters completion:^(id responseObject, NSError *error) {
        [refreshHeader endRefreshing];
    }];
}

#pragma mark - url request

- (void)robotChatWithQuestion:(NSString *)question {
    // 请求机器人问题答案
    NSDictionary *robotChatParameters = @{@"chatId": @"131023345567",
                                          @"userId": @"131023345567",
                                          @"consNo": @"",
                                          @"sessionCount": @"02",
                                          @"question": question};
    __weak __typeof(self) weakSelf = self;
    [OCSNetworkManager robotChatWithParameters:robotChatParameters completion:^(id responseObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (responseObject) {
            [strongSelf insertModel:responseObject completion:nil];
            
            NSString *string = @"您好！您可以拨打95598热线，或登录95598智能互动网站、掌上电力APP进行电费查询。\n\n是否为您解决问题： 解决   未解决";
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                         NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]};
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
            OCSPromptModel *model = [OCSPromptModel modelWithDictionary:@{@"content": [attributedString copy]}];
            
            NSRange solvedRange = [string rangeOfString:@"解决 "];
            solvedRange = NSMakeRange(solvedRange.location, 2);
            NSRange notSolvedRange = [string rangeOfString:@"未解决" options:NSBackwardsSearch];
            [attributedString yy_setTextHighlightRange:solvedRange color:[UIColor colorWithHexString:@"#0C82F1"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSMutableAttributedString *mutableText = [text mutableCopy];
                [mutableText yy_setTextHighlightRange:range color:[UIColor colorWithHexString:@"#CCCCCC"] backgroundColor:nil tapAction:nil];
                [mutableText yy_setTextHighlightRange:notSolvedRange color:[UIColor colorWithHexString:@"#0C82F1"] backgroundColor:nil tapAction:nil];
                
                model.content = mutableText;
                NSUInteger row = [strongSelf.models indexOfObject:model];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                UITableViewCell *cell = [strongSelf.tableView cellForRowAtIndexPath:indexPath];
                [cell refreshWithModel:model];
            }];
            
            [attributedString yy_setTextHighlightRange:notSolvedRange color:[UIColor colorWithHexString:@"#0C82F1"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSMutableAttributedString *mutableText = [text mutableCopy];
                [mutableText yy_setTextHighlightRange:range color:[UIColor colorWithHexString:@"#CCCCCC"] backgroundColor:nil tapAction:nil];
                [mutableText yy_setTextHighlightRange:solvedRange color:[UIColor colorWithHexString:@"#0C82F1"] backgroundColor:nil tapAction:nil];
                
                model.content = mutableText;
                NSUInteger row = [strongSelf.models indexOfObject:model];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                UITableViewCell *cell = [strongSelf.tableView cellForRowAtIndexPath:indexPath];
                [cell refreshWithModel:model];
                
                // 未解决调用
                NSString *string = @"很抱歉！问题未得到解决。\n\n是否转接【人工在线客服】";
                NSRange humanServiceRange = [string rangeOfString:@"人工在线客服"];
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                             NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]};
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
                [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:humanServiceRange];
                [attributedString yy_setTextHighlightRange:humanServiceRange color:[UIColor colorWithHexString:@"#0C82F1"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    // 当前为人工客服则不能点击
                    if (strongSelf.moreMediaToolView.toolType == OCSMoreMediaToolTypeRobotService) {
                        [strongSelf handleMoreMediaToolServiceTypeTurnToHumanEvent];
                    }
                }];
                OCSPromptModel *humanServicePromptModel = [OCSPromptModel modelWithDictionary:@{@"content": [attributedString copy]}];
                if (humanServicePromptModel) {
                    [strongSelf insertModel:humanServicePromptModel completion:nil];
                }
            }];
            
            model.content = [attributedString copy];
            if (model) {
                [strongSelf insertModel:model completion:nil];
            }
        }
    }];
}

#pragma mark - block

- (void)handleInputToolBarSendButtonCallbackWithContent:(NSString *)content {
    // 校验输入内容是否为空
    if (content.length == 0) { return; }

    // 用户发送信息上传并校验
    NSDictionary *userChatParameters = @{@"chatId": @"131023345567",
                                         @"toNo": @"131023345567",
                                         @"fromNo": @"",
                                         @"contentType": @"01",
                                         @"content": content,
                                         @"empFlag": @"03"};
    __weak __typeof(self) weakSelf = self;
    [OCSNetworkManager userChatWithParameters:userChatParameters completion:^(NSDictionary *responseObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        // 上传并校验成功展示发送文本
        OCSUserChatTextModel *model = [OCSUserChatTextModel modelWithDictionary:responseObject];
        if (model) {
            [strongSelf insertModel:model completion:nil];
        }

        if (strongSelf.hasSeatID) {
            // 人工客服聊天
            NSDictionary *dictionary = @{@"command": @"message",
                                         @"clientID": @"client1",
                                         @"content": model.sensitiveWordContent};
            NSError *error = nil;
            NSString *message = [dictionary JSONStringWithOptions:NSJSONWritingPrettyPrinted encoding:NSUTF8StringEncoding error:&error];
            [strongSelf.webSocket send:message];
        } else {
            [strongSelf robotChatWithQuestion:model.sensitiveWordContent];
        }
    }];
}

#pragma mark - OCSTimingDelegate

- (void)refreshCellWithTiming:(OCSTiming *)timing num:(NSInteger)num {
    OCSQueueTextModel *model = timing.referenceObject;
    if (model) {
        NSString *string = [NSString stringWithFormat:@"%@%ld秒", model.prefix, num];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FC6D53"]} range:NSMakeRange(model.prefix.length, string.length - model.prefix.length)];
        model.content = [attributedString copy];
        
        NSUInteger row = [self.models indexOfObject:model];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell refreshWithModel:model];
    }
}

- (void)timing:(OCSTiming *)timing didStartTimingWithNum:(NSInteger)num {
    [self refreshCellWithTiming:timing num:num];
}

- (void)timing:(OCSTiming *)timing beingTimingWithNum:(NSInteger)num {
    [self refreshCellWithTiming:timing num:num];
}

- (void)timing:(OCSTiming *)timing didCancelTimingWithNum:(NSInteger)num {
    [self refreshCellWithTiming:timing num:num];

    // 退出排队
    if (self.queueId) {
        NSDictionary *parameters = @{@"queueId": self.queueId,
                                     @"endReason": @"02"};
        [OCSNetworkManager dequeueHumanServiceWithParameters:parameters completion:^(NSDictionary *responseObject, NSError *error) {
            NSLog(@"%s--%@", __PRETTY_FUNCTION__, responseObject);
        }];
    }
}

- (void)timing:(OCSTiming *)timing didFinishWithNum:(NSInteger)num {
    [self refreshCellWithTiming:timing num:num];
    
    // 先断开websocket连接
    [self.webSocket close];
    // 提示用户离开
    NSString *contentString = @"【系统提醒】对不起，人工在线客服繁忙，是否要离开？";
    NSRange range = [contentString rangeOfString:@"离开"];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString attributes:attributes];
    __weak __typeof(self) weakSelf = self;
    [attributedString yy_setTextHighlightRange:range color:[UIColor colorWithHexString:@"#0C82F1"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.queueId) {
            NSDictionary *parameters = @{@"queueId": strongSelf.queueId,
                                         @"endReason": @"01"};
            [OCSNetworkManager dequeueHumanServiceWithParameters:parameters completion:^(NSDictionary *responseObject, NSError *error) {
                NSLog(@"%s--%@", __PRETTY_FUNCTION__, responseObject);
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
    OCSPromptModel *model = [OCSPromptModel modelWithDictionary:@{@"content": [attributedString copy]}];
    if (model) {
        [self insertModel:model completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OCSModel *model = self.models[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellIdentifier];
    [cell setTableView:tableView];
    [cell refreshWithModel:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputToolBar endEditing:YES];
    [self recoverBackgroundView];
}

#pragma mark - OCSMoreMediaPictureActionSheetDelegate

- (void)actionSheet:(OCSMoreMediaPictureActionSheet *)actionSheet clickedItemAtIndex:(NSInteger)index {
    if (index == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    } else if (index == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 返回的图片
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *dictionary = @{@"uploadImage": originalImage};
    OCSUserChatPictureModel *model = [OCSUserChatPictureModel modelWithDictionary:dictionary];
    [self insertModel:model completion:nil];
    NSDictionary *parameters = @{@"uploadImages": originalImage};
    [OCSNetworkManager uploadPictureWithParameters:parameters completion:^(id responseObject, NSError *error) {
    }];
}

#pragma mark - OCSMoreMediaToolViewDelegate

- (void)didSelectServiceType:(OCSMoreMediaToolServiceType)serviceType {
    if (serviceType == OCSMoreMediaToolServiceTypeTurnToHuman) {
        [self handleMoreMediaToolServiceTypeTurnToHumanEvent];
    } else if (serviceType == OCSMoreMediaToolServiceTypeEmoticon) {
        
    } else if (serviceType == OCSMoreMediaToolServiceTypePicture) {
        [OCSMoreMediaPictureActionSheet showWithDelegate:self];
    } else if (serviceType == OCSMoreMediaToolServiceTypePosition) {
        
    } else if (serviceType == OCSMoreMediaToolServiceTypeEnd) {
        // 客户端挂断
        NSDictionary *dictionary = @{@"command": @"hangup",
                                     @"clientID": @"client1"};
        NSError *error = nil;
        NSString *message = [dictionary JSONStringWithOptions:NSJSONWritingPrettyPrinted encoding:NSUTF8StringEncoding error:&error];
        [self.webSocket send:message];
        
        [self.webSocket close];
        [self.moreMediaToolView setToolType:OCSMoreMediaToolTypeRobotService];
        
        // 提示会话结束
        [self insertSessionEndModel];
        
        // 显示评价页面
        [OCSEvaluationView show];
    }
}

- (void)handleMoreMediaToolServiceTypeTurnToHumanEvent {
    if (self.timing.isTiming) {
        return;
    }
    
    // 转人工客服
    NSDictionary *parameters = @{@"sessionUid": @""};
    __weak __typeof(self) weakSelf = self;
    [OCSNetworkManager enqueueHumanServiceWithParameters:parameters completion:^(NSDictionary *responseObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (responseObject) {
                NSString *returnFlag = [responseObject valueForKey:@"returnFlag"];
                if ([returnFlag isEqualToString:@"01"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"排队失败" message:@"未在工作时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                } else if ([returnFlag isEqualToString:@"02"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"排队失败" message:@"无可用坐席" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                } else if ([returnFlag isEqualToString:@"03"]) {
                    OCSQueueTextModel *model = [OCSQueueTextModel modelWithDictionary:responseObject];
                    model.content = [[NSAttributedString alloc] initWithString:model.prefix];
                    if (model) {
                        [strongSelf insertModel:model completion:nil];
                    }
                    
                    strongSelf.queueId = [responseObject valueForKey:@"queueId"];
                    // 服务可用, 排队计时40s, 暂时使用40s, 后面根据接口返回值
                    [strongSelf.timing setDuration:40];
                    [strongSelf.timing setReferenceObject:model];
                    [strongSelf.timing startTiming];
                    [strongSelf.webSocket open];
                }
            } else if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"排队失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"排队失败" message:@"未知原因" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [self.timing cancelTiming];
    [self.moreMediaToolView setToolType:OCSMoreMediaToolTypeHumanService];
    
    // 订阅排队信息
    NSDictionary *dictionary = @{@"clientID": @"client1",
                                 @"command": @"join",
                                 @"skillID": @"1"};
    NSError *error = nil;
    NSString *message = [dictionary JSONStringWithOptions:NSJSONWritingPrettyPrinted encoding:NSUTF8StringEncoding error:&error];
    [webSocket send:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSError *error = nil;
    NSDictionary *dictionary = [message JSONObjectWithOptions:NSJSONReadingMutableContainers encoding:NSUTF8StringEncoding error:&error];
    NSNumber *position = [dictionary valueForKey:@"position"];
    NSString *command = [dictionary valueForKey:@"command"];
    if ([command isEqualToString:@"position"] && position.integerValue == -1) {
        // 排队完成信息
        NSString *seatID = [dictionary valueForKey:@"seatID"];
        // 后台记录会话接入请求
        NSDictionary *parameters = @{@"sessionUid": @"",
                                     @"toNo": @"",
                                     @"fromNo": seatID};
        __weak __typeof(self) weakSelf = self;
        [OCSNetworkManager sessionWithParameters:parameters completion:^(NSDictionary *responseObject, NSError *error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.hasSeatID = YES;
        }];
    } else if ([command isEqualToString:@"message"]) {
        // 聊天信息
        NSString *content = [dictionary valueForKey:@"content"];
        
        // content为信息ID, 通过信息ID查询消息
        NSDictionary *parameters = @{@"chatDetailId": content};
        __weak __typeof(self) weakSelf = self;
        [OCSNetworkManager chatContentWithParameters:parameters completion:^(NSDictionary *responseObject, NSError *error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (responseObject) {
                NSString *content = [responseObject valueForKey:@"content"];
                NSDictionary *dictionary = @{@"contentType": @"01",
                                             @"content": content};
                OCSTextModel *model = [OCSTextModel modelWithDictionary:dictionary];
                [strongSelf insertModel:model completion:nil];
            }
        }];
    } else if ([command isEqualToString:@"close"]) {
        [self insertSessionEndModel];
        // 坐席端挂断
        [OCSEvaluationView show];
    } else if ([command isEqualToString:@"timeout"]) {
        // 120s超时挂断
        [self insertSessionEndModel];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    self.webSocket = nil;
    // 计时器读秒时间内握手失败则再次握手
    [self.webSocket open];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    self.webSocket = nil;
}

#pragma mark - getter methods

- (UIView *)backgroundView {
    if (!_backgroundView) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.frame  =CGRectMake(0, 64, self.view.width, self.view.height - 64);
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

- (OCSSessionTableView *)tableView {
    if (!_tableView) {
        OCSSessionTableView *tableView = [[OCSSessionTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView.new;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak __typeof(self) weakSelf = self;
        [tableView setTouchesEnded:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.inputToolBar endEditing:YES];
            [strongSelf recoverBackgroundView];
        }];
        
        for (Class aClass in @[OCSMessageCell.class,
                               OCSWelcomeCell.class,
                               OCSLinksCell.class,
                               OCSTextCell.class,
                               OCSPictureCell.class,
                               OCSPictureWordCell.class,
                               OCSUserChatTextCell.class,
                               OCSQueueTextCell.class,
                               OCSPromptCell.class,
                               OCSSessionEndCell.class,
                               OCSUserChatPictureCell.class]) {
            [tableView registerClass:aClass forCellReuseIdentifier:NSStringFromClass(aClass)];
        }
        
        _tableView = tableView;
    }
    return _tableView;
}

- (MJRefreshHeader *)refreshHeader {
    if (!_refreshHeader) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleRefreshHeaderEvent:)];
        refreshHeader.stateLabel.hidden = YES;
        _refreshHeader = refreshHeader;
    }
    return _refreshHeader;
}

- (OCSInputToolBar *)inputToolBar {
    if (!_inputToolBar) {
        OCSInputToolBar *inputToolBar = [[OCSInputToolBar alloc] initWithFrame:CGRectZero];
//        inputToolBar.frame = CGRectMake(0, self.view.height - OCSInputToolBarHeight, self.view.width, OCSInputToolBarHeight);
        __weak __typeof(self) weakSelf = self;
        [inputToolBar setMoreMediaButtonCallback:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf isShowingMoreMediaToolView]) {
                [strongSelf recoverBackgroundView];
            } else {
                [strongSelf showMoreMediaToolView];
                [strongSelf.tableView scrollToBottom:NO];
            }
        }];
        [inputToolBar setTextViewDidBeginEditing:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView scrollToBottom:NO];
        }];
//        [inputToolBar setSendButtonCallback:^(id model) {
//            [OCSEvaluationView show];
//        }];
        [inputToolBar setSendButtonCallback:^(NSString *content) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf handleInputToolBarSendButtonCallbackWithContent:content];
        }];
        [inputToolBar setSizeDidChange:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            CGFloat maxY = CGRectGetMaxY(strongSelf.tableView.bounds);
            [strongSelf.tableView setContentOffset:CGPointMake(0, maxY) animated:NO];
        }];
        _inputToolBar = inputToolBar;
    }
    return _inputToolBar;
}

- (OCSMoreMediaToolView *)moreMediaToolView {
    if (!_moreMediaToolView) {
        OCSMoreMediaToolView *moreMediaToolView = [[OCSMoreMediaToolView alloc] init];
        [moreMediaToolView setHidden:YES];
        [moreMediaToolView setDelegate:self];
        _moreMediaToolView = moreMediaToolView;
    }
    return _moreMediaToolView;
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        UIImagePickerController *imagePickerController = UIImagePickerController.new;
        imagePickerController.delegate = self;
        _imagePickerController = imagePickerController;
    }
    return _imagePickerController;
}

- (OCSTiming *)timing {
    if (!_timing) {
        OCSTiming *timing = [[OCSTiming alloc] initWithDelegate:self duration:40];
        _timing = timing;
    }
    return _timing;
}

- (SRWebSocket *)webSocket {
    if (!_webSocket) {
        NSString *URLString = @"ws://192.168.8.151:8081/websocket";
        NSURL *url = [NSURL URLWithString:URLString];
        SRWebSocket *webSocket = [[SRWebSocket alloc] initWithURL:url];
        webSocket.delegate = self;
        _webSocket = webSocket;
    }
    return _webSocket;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
