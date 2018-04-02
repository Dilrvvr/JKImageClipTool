//
//  ClipCircleViewController.m
//  JKClipImageTool
//
//  Created by albert on 2018/4/2.
//  Copyright © 2018年 安永博. All rights reserved.
//

#import "ClipCircleViewController.h"
#import "JKImageClipTool.h"

@interface ClipCircleViewController ()

@end

@implementation ClipCircleViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"圆形裁剪";
    
    __weak typeof(self) weakSelf = self;
    
    [JKImageClipTool showWithImage:self.pickImage superView:self.view imageClipType:(JKImageClipTypeCircle) autoSavaToAlbum:NO complete:^(UIImage *image) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        !weakSelf.complete ? : weakSelf.complete(image);
        
    } cancel:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        !weakSelf.cancel ? : weakSelf.cancel();
    }];
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
