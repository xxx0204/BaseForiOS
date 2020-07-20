//
//  XProxy.h
//  Pods
//
//  Created by 王旭 on 2020/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XProxy : NSProxy

@property(nonatomic, weak)id target;

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
