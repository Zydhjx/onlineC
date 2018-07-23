//
//  OCSNetworkManager.h
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import <Foundation/Foundation.h>

/**
 * 请求网络数据
 */

typedef NS_ENUM(NSUInteger, OCSNetworkURLPathType) {
    OCSNetworkURLPathTypeAccess, // 接入
    OCSNetworkURLPathTypeRobotChat, // 机器人聊天
    OCSNetworkURLPathTypeEnqueueHumanService, // 入队人工服务排队
    OCSNetworkURLPathTypeDequeueHumanService, // 出队人工服务排队
    OCSNetworkURLPathTypeSatisfaction, // 满意度
    OCSNetworkURLPathTypeChatRecord, // 聊天记录
    OCSNetworkURLPathTypeUserChat, // 用户聊天内容上传和校验
    OCSNetworkURLPathTypeSession, // 会话接入
    OCSNetworkURLPathTypeChatContent, // 通过信息ID查询聊天内容
};

@interface OCSNetworkManager : NSObject

+ (void)postWithURLPathType:(OCSNetworkURLPathType)type parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 接入
+ (void)accessWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 机器人聊天
+ (void)robotChatWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 入队人工服务排队
+ (void)enqueueHumanServiceWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 出队人工服务排队
+ (void)dequeueHumanServiceWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 满意度
+ (void)satisfactionWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 聊天记录
+ (void)chatRecordWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 用户聊天内容上传和校验
+ (void)userChatWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 会话接入
+ (void)sessionWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 通过信息ID查询聊天内容
+ (void)chatContentWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 上传图片
+ (void)uploadPictureWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

// 客户动作信息记录
+ (void)actionRecordWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;

@end
