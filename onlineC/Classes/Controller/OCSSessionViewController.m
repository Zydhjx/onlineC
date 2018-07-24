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
#import "OCSMoreMediaEmoticonView.h"

#import "UIColor+OCSExtension.h"
#import "UIView+OCSFrame.h"
#import "UITableViewCell+OCSExtension.h"
#import "UITableView+OCSExtension.h"
#import "NSString+OCSExtension.h"
#import "NSDictionary+OCSExtension.h"
#import "UIImage+OCSExtension.h"
#import "NSTextAttachment+OCSExtension.h"
#import "NSAttributedString+OCSExtension.h"

#import <MJRefresh.h>
#import <Masonry.h>
#import <SocketRocket.h>
#import <NSAttributedString+YYText.h>
#import <TZImagePickerController.h>
//#import <GDTMediator/GDTMediator+FrameWork.h>

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Is_iPhoneX (SCREEN_HEIGHT == 812)
#define kStatusBarAndNavgationBarHeight (Is_iPhoneX ? 88 : 64)
#define kBottomHeight (Is_iPhoneX ? 34 : 0)

NSString * const OCSSessionHandleLinksEventNotification = @"OCSSessionHandleLinksEventNotification";

/// 工具栏高度
static CGFloat const kMoreMediaToolViewHeight = 120;
/// 表情栏高度
static CGFloat const kEmoticonViewHeight      = 200;

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


@interface OCSSessionViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, OCSTimingDelegate, SRWebSocketDelegate, OCSMoreMediaToolViewDelegate, OCSMoreMediaPictureActionSheetDelegate, TZImagePickerControllerDelegate, OCSMoreMediaEmoticonViewDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) OCSSessionTableView *tableView;
@property (strong, nonatomic) MJRefreshHeader *refreshHeader;
@property (strong, nonatomic) OCSInputToolBar *inputToolBar;
@property (strong, nonatomic) OCSMoreMediaToolView *moreMediaToolView;
@property (strong, nonatomic) OCSMoreMediaEmoticonView *emoticonView;
@property (copy, nonatomic) NSArray *models;
@property (assign, nonatomic) BOOL isShowingKeyboard;

// 相机
@property (strong, nonatomic) UIImagePickerController *cameraController;
// 相册
@property (strong, nonatomic) TZImagePickerController *photoController;

// 排队计时器
@property (strong, nonatomic) OCSTiming *timing;

// websocket
@property (strong, nonatomic) SRWebSocket *webSocket;

// 临时变量 队伍编号
@property (copy, nonatomic) NSString *queueId;
// 坐席状态
@property (assign, nonatomic) BOOL hasSeatID;
// 会话唯一标识
@property (copy, nonatomic) NSString *sessionUid;


// 用户唯一标识
@property (copy, nonatomic) NSString *userId;
// 用户优先级等级
@property (copy, nonatomic) NSString *vipLevel;
// 行政区域编号
@property (copy, nonatomic) NSString *adress;
// 用户登陆IP地址
@property (copy, nonatomic) NSString *ip;
// 业务类别
@property (copy, nonatomic) NSString *queueUri;

@end

@implementation OCSSessionViewController

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    if (self.webSocket.readyState != SR_CLOSED || self.webSocket.readyState != SR_CLOSING) {
//        [self.webSocket close];
//    }
}

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    self = [super init];
    if (!self) { return nil; }
    
    _userId = [parameters valueForKey:@"userId"];
    _vipLevel = [parameters valueForKey:@"vipLevel"];
    _adress = [parameters valueForKey:@"adress"];
    _ip = [parameters valueForKey:@"ip"];
    _queueUri = [parameters valueForKey:@"queueUri"];
    
    return self;
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
    
//    // test
    [self.moreMediaToolView setToolType:OCSMoreMediaToolTypeHumanService];
    
    /*
     *  接入
     */
    [self accessEvent];
}

- (void)accessEvent {
    self.userId = @"lily";
    NSDictionary *parameters = @{@"userId": self.userId,
                                 @"nickName": @"小黑鼠",
                                 @"userTel": @"15636001234",
                                 @"vipLevel": @10,
                                 @"adress": @"110102",
                                 @"remarks": @"2342356|32101"};
    __weak __typeof(self) weakSelf = self;
    [OCSNetworkManager accessWithParameters:parameters completion:^(id responseObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (responseObject) {
            [strongSelf insertModel:responseObject completion:^{
                [strongSelf robotChatEventWithModel:responseObject];
            }];
        }
    }];
}

- (void)robotChatEventWithModel:(OCSWelcomeModel *)model {
    /*
     *  欢迎语获取
     */
    self.sessionUid = model.sessionUid;
    NSDictionary *parameters = @{@"chatId": model.chatId,
                                 @"userId": self.userId,
                                 @"consNo": @"",
                                 @"sessionCount": @"01",
                                 @"question": @"welcomMobMsg"};
    __weak __typeof(self) weakSelf = self;
    [OCSNetworkManager robotChatWithParameters:parameters completion:^(id responseObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (responseObject) {
            [strongSelf insertModel:responseObject completion:nil];
        }
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

- (void)addSubviews {
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.moreMediaToolView];
    [self.view addSubview:self.emoticonView];
    [self.backgroundView addSubview:self.tableView];
    [self.backgroundView addSubview:self.inputToolBar];
    
    [self.tableView setMj_header:self.refreshHeader];
}

- (void)layout {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
        make.height.equalTo(@(kMoreMediaToolViewHeight + kBottomHeight));
    }];
    [self.emoticonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreMediaToolView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(kEmoticonViewHeight + kBottomHeight));
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
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.models indexOfObject:model] inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollToBottomDelay:NO animated:YES];
    }
    
    completion ? completion() : nil;
}

- (void)insertModels:(NSArray *)models completion:(dispatch_block_t)completion {
    if (models && self.tableView) {
        NSMutableArray *mutableArray = [self.models mutableCopy];
        [mutableArray addObjectsFromArray:models];
        self.models = [mutableArray copy];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < models.count; i++) {
            id model = [models objectAtIndex:i];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.models indexOfObject:model] inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        [self.tableView insertRowsAtIndexPaths:[indexPaths copy] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollToBottomDelay:NO animated:YES];
    }
}

#pragma mark - 键盘和更多菜单显示隐藏相关方法

- (BOOL)isShowingMoreMediaToolView {
    return (self.backgroundView.height != self.view.height) && (self.moreMediaToolView.isHidden == NO);
}

- (BOOL)isShowingEmoticonView {
    return (self.backgroundView.height != self.view.height) && (self.emoticonView.isHidden == NO);
}

- (void)showMoreMediaToolView {
    self.moreMediaToolView.hidden = NO;
    
    // 120是MoreMediaToolView的高度
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kMoreMediaToolViewHeight - kBottomHeight);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)showEmoticonView {
    self.emoticonView.hidden = NO;
    
    // 200是EmoticonView的高度
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kMoreMediaToolViewHeight - kEmoticonViewHeight - kBottomHeight);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)showKeyboardWithHeight:(CGFloat)keyboardHeight duration:(NSTimeInterval)duration {
    self.moreMediaToolView.hidden = YES;
    self.emoticonView.hidden = YES;
    
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-keyboardHeight);//271
    }];

    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)recoverBackgroundViewWithDuration:(NSTimeInterval)duration {
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.emoticonView.hidden = YES;
        self.moreMediaToolView.hidden = YES;
    }];
}

#pragma mark - notification events

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self showKeyboardWithHeight:CGRectGetHeight(keyboardRect) duration:duration];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    if (![self isShowingMoreMediaToolView]) {
        [self recoverBackgroundViewWithDuration:duration];
    }
}

- (void)handleLinksEventNotification:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
    NSDictionary *dictionary = notification.object;
    OCSLinksEventType eventType = ((NSNumber *)[dictionary valueForKey:@"eventType"]).unsignedIntegerValue;
    NSString *actionType = [dictionary valueForKey:@"actionType"];
    NSString *href = [dictionary valueForKey:@"href"];
    
    // 用户动作记录
    NSDictionary *parameters = @{@"sessionUid": self.sessionUid,
                                 @"actionType": [NSString stringWithFormat:@"%@&-&%@", actionType, href]};
    [OCSNetworkManager actionRecordWithParameters:parameters completion:nil];
    
    if (eventType == OCSLinksEventTypeTurnToHumanService &&
        self.moreMediaToolView.toolType == OCSMoreMediaToolTypeRobotService) {
        [self handleMoreMediaToolServiceTypeTurnToHumanEvent];
    } else if (eventType == OCSLinksEventTypeAppInner) {
//        [[GDTMediator sharedInstance] GDTMediator_GDTPushToMicroAppAction:@{@"appname": href}];
    } else if (eventType == OCSLinksEventTypeAssociatedProblem &&
               self.moreMediaToolView.toolType == OCSMoreMediaToolTypeRobotService) {
        NSString *question = [href substringFromIndex:2];
        [self robotChatWithQuestion:question];
    } else if (eventType == OCSLinksEventTypeURL) {
        NSString *URLString = [href substringFromIndex:2];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    } else if (eventType == OCSLinksEventTypeLeave &&
               self.moreMediaToolView.toolType == OCSMoreMediaToolTypeRobotService) {
        if (self.queueId) {
            NSDictionary *parameters = @{@"queueId": self.queueId,
                                         @"endReason": @"01"};
            [OCSNetworkManager dequeueHumanServiceWithParameters:parameters completion:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    __weak __typeof(self) weakSelf = self;
    [OCSNetworkManager chatRecordWithParameters:parameters completion:^(id responseObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (responseObject) {
            NSMutableArray *chatRecordModels = [[NSMutableArray alloc] init];
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger index, BOOL * _Nonnull stop) {
                if (!dictionary) {
                    return;
                }
                
                NSString *empFlag = [dictionary valueForKey:@"empFlag"];
                NSString *content = [dictionary valueForKey:@"content"];
                NSString *imgUrl = [dictionary valueForKey:@"imgUrl"];
                NSString *contentType = nil;
                if (imgUrl.length == 0) {
                    // 记录为图片
                    contentType = @"01";
                } else if (content.length == 0) {
                    // 记录为文本
                    contentType = @"02";
                } else {
                    // 记录为图文
                    contentType = @"08";
                }
                NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
                [mutableDictionary setValue:contentType forKey:@"contentType"];
                // 客户
                if ([empFlag isEqualToString:@"01"]) {
                    OCSUserChatModel *model = [OCSUserChatModel modelWithDictionary:[mutableDictionary copy]];
                    [chatRecordModels addObject:model];
                } else if ([empFlag isEqualToString:@"02"] || [empFlag isEqualToString:@"03"]) {
                    OCSRobotModel *model = [OCSRobotModel modelWithDictionary:[mutableDictionary copy]];
                    [chatRecordModels addObject:model];
                }
            }];
            [refreshHeader endRefreshing];
            
            if (strongSelf.tableView) {
                [chatRecordModels addObjectsFromArray:strongSelf.models];
                strongSelf.models = [chatRecordModels copy];
                [strongSelf.tableView reloadData];
            }
        }
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
                
                NSDictionary *parameters = @{@"sessionUid": @"",
                                             @"actionType": @"03&-&解决"};
                [OCSNetworkManager actionRecordWithParameters:parameters completion:nil];
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
                
                NSDictionary *parameters = @{@"sessionUid": @"",
                                             @"actionType": @"03&-&未解决"};
                [OCSNetworkManager actionRecordWithParameters:parameters completion:nil];
                
                // 未解决调用
                NSString *string = @"很抱歉！问题未得到解决。\n\n是否转接【<a href='转人工'>人工在线客服</a>】";
                NSAttributedString *content = [OCSLinksHandler attributedStringWithLinkString:string];
                OCSPromptModel *humanServicePromptModel = [OCSPromptModel modelWithDictionary:@{@"content": content}];
                if (humanServicePromptModel) {
                    [strongSelf insertModel:humanServicePromptModel completion:nil];
                }
            }];
            
            model.content = [attributedString copy];
            [strongSelf insertModels:@[responseObject, model] completion:nil];
        }
    }];
}

#pragma mark - block

- (void)handleInputToolBarSendButtonCallbackWithContent:(NSAttributedString *)content {
    // 校验输入内容是否为空
    if (content.length == 0) { return; }

    if (self.hasSeatID) {
        // 用户发送信息上传并校验
        NSDictionary *userChatParameters = @{@"chatId": @"131023345567",
                                             @"toNo": @"131023345567",
                                             @"fromNo": @"",
                                             @"contentType": @"01",
                                             @"content": content.plainString,
                                             @"empFlag": @"03"};
        __weak __typeof(self) weakSelf = self;
        [OCSNetworkManager userChatWithParameters:userChatParameters completion:^(NSDictionary *responseObject, NSError *error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (responseObject) {
                NSMutableDictionary *mutableResponseObject = [responseObject mutableCopy];
                [mutableResponseObject setValue:@"01" forKey:@"contentType"];
                // 上传并校验成功展示发送文本
                OCSUserChatTextModel *model = [OCSUserChatTextModel modelWithDictionary:[mutableResponseObject copy]];
                if (model) {
                    [strongSelf insertModel:model completion:nil];
                }
                
                // 人工客服聊天
                NSDictionary *dictionary = @{@"command": @"message",
                                             @"clientID": @"client1",
                                             @"content": model.sensitiveWordContent};
                NSError *error = nil;
                NSString *message = [dictionary JSONStringWithOptions:NSJSONWritingPrettyPrinted encoding:NSUTF8StringEncoding error:&error];
                [strongSelf.webSocket send:message];
            }
        }];
    } else {
        NSDictionary *dictionary = @{@"contentType": @"01",
                                     @"sensitiveWordContent": content.plainString};
        OCSUserChatTextModel *model = [OCSUserChatTextModel modelWithDictionary:dictionary];
        if (model) {
            [self insertModel:model completion:nil];
        }
        [self robotChatWithQuestion:model.sensitiveWordContent.string];
    }
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
        [OCSNetworkManager dequeueHumanServiceWithParameters:parameters completion:nil];
    }
}

- (void)timing:(OCSTiming *)timing didFinishWithNum:(NSInteger)num {
    [self refreshCellWithTiming:timing num:num];
    
    // 先断开websocket连接
    [self.webSocket close];
    // 提示用户离开
    NSString *contentString = @"【系统提醒】对不起，人工在线客服繁忙，是否要<a href='离开'>离开</a>？";
    NSAttributedString *content = [OCSLinksHandler attributedStringWithLinkString:contentString];
    OCSPromptModel *model = [OCSPromptModel modelWithDictionary:@{@"content": content}];
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
}

#pragma mark - OCSMoreMediaPictureActionSheetDelegate

- (void)actionSheet:(OCSMoreMediaPictureActionSheet *)actionSheet clickedItemAtIndex:(NSInteger)index {
    if (index == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.cameraController animated:YES completion:nil];
    } else if (index == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self presentViewController:self.photoController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 返回的图片
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (originalImage) {
        NSData *originalImageData = UIImageJPEGRepresentation(originalImage, 1.0);
        NSDictionary *dictionary = @{@"contentType": @"02",
                                     @"uploadImage": originalImageData};
        OCSUserChatPictureModel *model = [OCSUserChatPictureModel modelWithDictionary:dictionary];
        [self insertModel:model completion:nil];
        NSDictionary *parameters = @{@"uploadImages": @[originalImageData]};
        [OCSNetworkManager uploadPictureWithParameters:parameters completion:^(id responseObject, NSError *error) {
        }];
    }
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSMutableArray *photoDataArray = [[NSMutableArray alloc] init];
    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        if (image) {
            NSData *originalImageData = UIImageJPEGRepresentation(image, 1.0);
            NSDictionary *dictionary = @{@"contentType": @"02",
                                         @"uploadImage": originalImageData};
            OCSUserChatPictureModel *model = [OCSUserChatPictureModel modelWithDictionary:dictionary];
            [self insertModel:model completion:nil];
            [photoDataArray addObject:originalImageData];
        }
    }];
    
    NSDictionary *parameters = @{@"uploadImages": [photoDataArray copy]};
    [OCSNetworkManager uploadPictureWithParameters:parameters completion:^(id responseObject, NSError *error) {
    }];
}

#pragma mark - OCSMoreMediaToolViewDelegate

- (void)didSelectServiceType:(OCSMoreMediaToolServiceType)serviceType {
    if (serviceType == OCSMoreMediaToolServiceTypeTurnToHuman) {
        [self handleMoreMediaToolServiceTypeTurnToHumanEvent];
    } else if (serviceType == OCSMoreMediaToolServiceTypeEmoticon) {
        [self showEmoticonView];
        [self.tableView scrollToBottomDelay:NO animated:NO];
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

#pragma mark - OCSMoreMediaEmoticonViewDelegate

- (void)moreMediaEmoticonView:(OCSMoreMediaEmoticonView *)emoticonView didSelectModel:(NSString *)model {
    NSMutableAttributedString *attributedText = [self.inputToolBar.attributedText mutableCopy];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *image = [UIImage imageNamed:model];
    textAttachment.image = image;
    textAttachment.imageTag = [NSString stringWithFormat:@"[:%@]", [model substringFromIndex:@"emoticon_".length]];
    
    UIFont *font = self.inputToolBar.font;
    UIColor *textColor = self.inputToolBar.textColor;
    CGFloat imgH = font.pointSize + 2;
    CGFloat imgW = (image.size.width / image.size.height) * imgH;
    //计算文字padding-top ，使图片垂直居中
    CGFloat textPaddingTop = (font.lineHeight - font.pointSize) / 2;
    textAttachment.bounds = CGRectMake(0, -textPaddingTop - 2, imgW, imgH);
    NSMutableAttributedString *attributedString = [[NSAttributedString attributedStringWithAttachment:textAttachment] mutableCopy];
    [attributedString addAttributes:@{NSFontAttributeName: font,
                                      NSForegroundColorAttributeName: textColor} range:NSMakeRange(0, attributedString.length)];
    [attributedText insertAttributedString:attributedString atIndex:self.inputToolBar.location];
    NSUInteger oldLocation = self.inputToolBar.location;
    self.inputToolBar.attributedText = [attributedText copy];
    self.inputToolBar.location = oldLocation + attributedString.length;
}

- (void)moreMediaEmoticonViewDidCancel {
    if (self.inputToolBar.location == 0) {
        return;
    }
    
    NSMutableAttributedString *attributedText = [self.inputToolBar.attributedText mutableCopy];
    NSUInteger oldLocation = self.inputToolBar.location;
    [attributedText deleteCharactersInRange:NSMakeRange(oldLocation - 1, 1)];
    self.inputToolBar.attributedText = [attributedText copy];
    self.inputToolBar.location = oldLocation - 1;
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
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
        if (seatID) {
            [self.timing cancelTiming];
            [self.moreMediaToolView setToolType:OCSMoreMediaToolTypeHumanService];
            // 后台记录会话接入请求
            NSDictionary *parameters = @{@"sessionUid": @"",
                                         @"toNo": @"",
                                         @"fromNo": seatID};
            __weak __typeof(self) weakSelf = self;
            [OCSNetworkManager sessionWithParameters:parameters completion:^(NSDictionary *responseObject, NSError *error) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.hasSeatID = YES;
            }];
        }
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
        _backgroundView = [[UIView alloc] init];
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
        __weak __typeof(self) weakSelf = self;
        [inputToolBar setMoreMediaButtonCallback:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf isShowingEmoticonView]) {
                [strongSelf recoverBackgroundViewWithDuration:0.35];
            } else if ([strongSelf isShowingMoreMediaToolView]) {
                [strongSelf recoverBackgroundViewWithDuration:0.25];
            } else {
                [strongSelf showMoreMediaToolView];
                [strongSelf.tableView scrollToBottomDelay:YES animated:NO];
            }
        }];
        [inputToolBar setTextViewDidBeginEditing:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView scrollToBottom];
//            [strongSelf.tableView scrollToBottomDelay:YES animated:YES];
//            CGPoint offset = CGPointMake(0, strongSelf.tableView.contentSize.height-strongSelf.tableView.frame.size.height);
//            [strongSelf.tableView setContentOffset:offset animated:NO];
        }];
//        [inputToolBar setSendButtonCallback:^(id model) {
//            [OCSEvaluationView show];
//        }];
        [inputToolBar setSendButtonCallback:^(NSAttributedString *content) {
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

- (OCSMoreMediaEmoticonView *)emoticonView {
    if (!_emoticonView) {
        OCSMoreMediaEmoticonView *emoticonView = [[OCSMoreMediaEmoticonView alloc] init];
        [emoticonView setHeight:YES];
        [emoticonView setDelegate:self];
        _emoticonView = emoticonView;
    }
    return _emoticonView;
}

- (UIImagePickerController *)cameraController {
    if (!_cameraController) {
        UIImagePickerController *cameraController = UIImagePickerController.new;
        cameraController.delegate = self;
        _cameraController = cameraController;
    }
    return _cameraController;
}

- (TZImagePickerController *)photoController {
    if (!_photoController) {
        TZImagePickerController *photoController = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:self];
        _photoController = photoController;
    }
    return _photoController;
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
