//
//  OCSNetworkManager.m
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import "OCSNetworkManager.h"
#import "OCSWelcomeModel.h"
#import "OCSRobotModel.h"

#import <AFNetworking.h>

static NSString * const kBaseURLString = @"http://192.168.8.117:8500/";//@"http://211.160.62.32:18000/osg-os0001/"

static NSString * const kAccessSuffix = @"member/c1/f1";  // 接入
static NSString * const kRobotChatSuffix = @"member/c1/f15";  // 机器人聊天
static NSString * const kEnqueueHumanServiceSuffix = @"member/c1/f6";  // 入队人工服务排队
static NSString * const kDequeueHumanServiceSuffix = @"member/c1/f7";  // 出队人工服务排队
static NSString * const kSatisfactionSuffix = @"member/c1/f8";  // 满意度
static NSString * const kChatRecordSuffix = @"member/c1/f19";  // 聊天记录
static NSString * const kUserChatSuffix = @"member/c1/f3";  // 用户聊天内容上传和校验
static NSString * const kSessionSuffix = @"member/c1/f2";  // 会话接入
static NSString * const kChatContentSuffix = @"member/c1/f14";  //  通过信息ID查询聊天内容
static NSString * const kUploadPictureSuffix = @"member/c1/f16";  // 上传图片


/** 存储所有的URL路径类型 **/
static NSDictionary * (^ const URLPathsKeyedByType)(void) = ^NSDictionary *{
    return @{
             @(OCSNetworkURLPathTypeAccess): @"member/c1/f1",
             @(OCSNetworkURLPathTypeRobotChat): @"member/c1/f15",
             @(OCSNetworkURLPathTypeEnqueueHumanService): @"member/c1/f6",
             @(OCSNetworkURLPathTypeDequeueHumanService): @"member/c1/f7",
             @(OCSNetworkURLPathTypeSatisfaction): @"member/c1/f8",
             @(OCSNetworkURLPathTypeChatRecord): @"member/c1/f19",
             @(OCSNetworkURLPathTypeUserChat): @"member/c1/f3",
             @(OCSNetworkURLPathTypeSession): @"member/c1/f2",
             @(OCSNetworkURLPathTypeChatContent): @"member/c1/f14"
             };
};

@implementation OCSNetworkManager

+ (void)postWithURLPathType:(OCSNetworkURLPathType)type parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:URLPathsKeyedByType()[@(type)]];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataDictionary = [responseDictionary valueForKey:@"data"];
        if (!(dataDictionary && [dataDictionary isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        completion ? completion(dataDictionary, nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

+ (void)accessWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kAccessSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataDictionary = [responseDictionary valueForKey:@"data"];
        if (!(dataDictionary && [dataDictionary isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        OCSWelcomeModel *model = [OCSWelcomeModel modelWithDictionary:dataDictionary];
        completion ? completion(model, nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

/*
 {
 code = 1;
 data =     {
 content = "<a href='http://www.baidu.com'>(1)\U505c\U7535\U6545\U969c\U62a5\U4fee</a>&-&<a href='http://www.baidu.com'>(2)\U505c\U7535\U4fe1\U606f\U67e5\U8be2</a>&-&<a href='http://www.baidu.com'>(3)\U5145\U503c\U7f34\U8d39</a>&-&<a href='http://www.baidu.com'>(4)\U7535\U91cf\U7535\U8d39\U67e5\U8be2</a>&-&<a href='http://www.baidu.com'>(5)\U8425\U4e1a\U7f51\U70b9\U67e5\U8be2</a>&-&<a href='http://www.baidu.com'>(6)\U7528\U6237\U6863\U6848\U67e5\U8be2</a>&-&<a href='http://www.baidu.com'>(7)\U529e\U7535\U7533\U8bf7</a>&-&<a href='http://www.baidu.com'>(8)\U5e38\U89c1\U95ee\U9898</a>&-&<a href='http://www.baidu.com'>(0)\U4eba\U5de5\U5728\U7ebf\U5ba2\U670d(\U670d\U52a1\U65f6\U95f48:00-22:00)</a>&-&";
 contentType = 09;
 resultcode = 1;
 };
 message = "\U6210\U529f";
 }
 */

+ (void)robotChatWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kRobotChatSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataDictionary = [responseDictionary valueForKey:@"data"];
        if (!(dataDictionary && [dataDictionary isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        OCSRobotModel *model = [OCSRobotModel modelWithDictionary:dataDictionary];
        completion ? completion(model, nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSDictionary *dataDictionary = @{@"imgUrl": @"http://e.hiphotos.baidu.com/image/h%3D300/sign=8dca0d22dd43ad4bb92e40c0b2005a89/03087bf40ad162d9a62a929b1ddfa9ec8b13cd75.jpg"};
//        OCSRobotModel *model = [OCSRobotModel modelWithDictionary:dataDictionary];
//        completion ? completion(model, nil) : nil;
        
        completion ? completion(nil, error) : nil;
    }];
}

+ (void)enqueueHumanServiceWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kEnqueueHumanServiceSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataDictionary = [responseDictionary valueForKey:@"data"];
        if (!(dataDictionary && [dataDictionary isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        completion ? completion(dataDictionary, nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

+ (void)dequeueHumanServiceWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kDequeueHumanServiceSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataDictionary = [responseDictionary valueForKey:@"data"];
        if (!(dataDictionary && [dataDictionary isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        completion ? completion(dataDictionary, nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

+ (void)satisfactionWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kSatisfactionSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+ (void)chatRecordWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kChatRecordSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataArray = [responseDictionary valueForKey:@"data"];
        if (!(dataArray && [dataArray isKindOfClass:NSArray.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        completion ? completion([dataArray lastObject], nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

+ (void)userChatWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kUserChatSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataDictionary = [responseDictionary valueForKey:@"data"];
        if (!(dataDictionary && [dataDictionary isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        // 不好判断返回数据是文本、图片或文件，字典转模型的操作推迟进行
        completion ? completion(dataDictionary, nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

+ (void)sessionWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kSessionSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataDictionary = [responseDictionary valueForKey:@"data"];
        if (!(dataDictionary && [dataDictionary isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        completion ? completion(dataDictionary, nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

+ (void)chatContentWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kChatContentSuffix];
    [[AFHTTPSessionManager manager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataArray = [responseDictionary valueForKey:@"data"];
        if (!(dataArray && [dataArray isKindOfClass:NSArray.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        completion ? completion([dataArray lastObject], nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

+ (void)uploadPictureWithParameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion {
    NSString *URLString = [kBaseURLString stringByAppendingString:kUploadPictureSuffix];
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    [requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"content-Type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = requestSerializer;
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!(responseObject && [responseObject isKindOfClass:NSDictionary.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        id dataArray = [responseDictionary valueForKey:@"data"];
        if (!(dataArray && [dataArray isKindOfClass:NSArray.class])) {
            completion ? completion(nil, nil) : nil;
            return;
        }
        
        completion ? completion([dataArray lastObject], nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

@end
