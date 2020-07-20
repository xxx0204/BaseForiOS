//
//  XImageLoopView.h
//  Pods
//
//  Created by 王旭 on 2020/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

@protocol XImageLoopDelegate <NSObject>

@optional
- (void)clickCircleSliderView:(NSInteger)index;

@end

@interface XImageLoopView : UIView

@property (nonatomic, weak) id<XImageLoopDelegate>delegate;

@property (nonatomic, assign) NSUInteger duration;

@property (nonatomic, strong) NSArray *imageArray;

@end

NS_ASSUME_NONNULL_END
