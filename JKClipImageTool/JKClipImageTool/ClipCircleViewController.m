//
//  ClipCircleViewController.m
//  JKClipImageTool
//
//  Created by albert on 2018/4/2.
//  Copyright © 2018年 安永博. All rights reserved.
//

#import "ClipCircleViewController.h"
#import "JKClipImageTool.h"

@interface ClipCircleViewController ()

/** clipView */
@property (nonatomic, weak) id<JKImageClipProtocol> clipView;
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(verifyAction)];
    
    __weak typeof(self) weakSelf = self;
    
    _clipView = [JKClipImageTool showWithSuperView:self.view targetImage:self.pickImage clipImageType:(JKClipImageTypeCircle) clipImageSize:CGSizeZero isAutoSavaToAlbum:NO cancelHandler:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        !weakSelf.cancel ? : weakSelf.cancel();
        
    } completeHandler:^(UIImage *image) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        !weakSelf.complete ? : weakSelf.complete(image);
    }];
    
    [_clipView hideBottomView];
}

- (void)cancelAction{
    
    [_clipView cancelButtonClick];
}

- (void)verifyAction{
    
    [_clipView verifyButtonClick];
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
