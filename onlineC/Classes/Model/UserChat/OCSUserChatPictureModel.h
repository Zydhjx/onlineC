//
//  OCSUserChatPictureModel.h
//  onlineC
//
//  Created by zyd on 2018/7/21.
//

#import "OCSUserChatModel.h"

@interface OCSUserChatPictureModel : OCSUserChatModel

@property (strong, nonatomic) UIImage *uploadImage;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
