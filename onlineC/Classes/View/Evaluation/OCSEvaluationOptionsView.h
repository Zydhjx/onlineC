//
//  OCSEvaluationOptionsView.h
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import <UIKit/UIKit.h>

@interface OCSEvaluationOptionsView : UIView

// 获取所有选项(多个时使用&-&拼接)
@property (copy, readonly, nonatomic) NSString *notSatisfaction;

// 设置数据
- (void)setModels:(NSArray *)models;
// 重置内容
- (void)reset;
// 全部选中
- (void)allSelected;
// 刷新
- (void)reloadData;

@end
