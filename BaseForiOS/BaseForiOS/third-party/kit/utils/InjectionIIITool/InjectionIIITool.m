//
//  InjectionIIITool.m
//  BaseForiOS
//
//  Created by 王旭 on 2020/7/20.
//  Copyright © 2020 王旭. All rights reserved.
//

#import "InjectionIIITool.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

@implementation InjectionIIITool

#if DEBUG

void injected(id self, SEL _cmd) {
	[self loadView];
	[self viewDidLoad];
	[self viewWillLayoutSubviews];
	[self viewWillAppear:NO];
}

+ (void)load
{
    //注册项目启动监听
    __block id observer =
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    
    //给UIViewController 注册injected 方法
    class_addMethod([UIViewController class], NSSelectorFromString(@"injected"), (IMP)injected, "v@:");
    
}

#endif

@end
