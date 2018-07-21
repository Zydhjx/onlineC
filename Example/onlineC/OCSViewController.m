//
//  OCSViewController.m
//  onlineC
//
//  Created by Zydhjx on 07/12/2018.
//  Copyright (c) 2018 Zydhjx. All rights reserved.
//

#import "OCSViewController.h"
#import <onlineC/OCSSessionViewController.h>

@interface OCSViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *models;

@end

@implementation OCSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 配置内部属性
    [self setupSelf];
    
    // 添加子视图
    [self addSubviews];
    
    // 配置数据
    self.models = @[@"在线客服"];
}

- (void)setupSelf {
    self.view.backgroundColor = UIColor.whiteColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    cell.textLabel.text = self.models[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OCSSessionViewController *sessionViewController = OCSSessionViewController.new;
    [self.navigationController pushViewController:sessionViewController animated:YES];
}

#pragma mark - getter methods

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView.new;
        
        [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        
        _tableView = tableView;
    }
    return _tableView;
}

@end
