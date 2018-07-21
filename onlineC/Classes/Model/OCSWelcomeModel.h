//
//  OCSWelcomeModel.h
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "OCSModel.h"

@interface OCSWelcomeModel : OCSModel

// 全局会话唯一标识
@property (copy, nonatomic) NSString *sessionUid;
// 会话聊天唯一标识
@property (copy, nonatomic) NSString *chatId;
// 欢迎语
@property (copy, nonatomic) NSString *resultText;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
