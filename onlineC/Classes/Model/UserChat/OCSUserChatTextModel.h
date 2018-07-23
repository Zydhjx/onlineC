//
//  OCSUserChatTextModel.h
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import "OCSUserChatModel.h"

@interface OCSUserChatTextModel : OCSUserChatModel

// 是否存在敏感词 1.存在  0.不存在
//@property (copy, nonatomic) NSString *sensitiveWordsFlag;
// 文本内容
@property (copy, nonatomic) NSAttributedString *sensitiveWordContent;

@end
