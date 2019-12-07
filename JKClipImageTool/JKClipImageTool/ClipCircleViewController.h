//
//  ClipCircleViewController.h
//  JKClipImageTool
//
//  Created by albert on 2018/4/2.
//  Copyright © 2018年 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClipCircleViewController : UIViewController
/** pickImage */
@property (nonatomic, strong) UIImage *pickImage;

/** completeHandler */
@property (nonatomic, copy) void (^complete)(UIImage *image);

/** cancelHandler */
@property (nonatomic, copy) void (^cancel)(void);
@end
