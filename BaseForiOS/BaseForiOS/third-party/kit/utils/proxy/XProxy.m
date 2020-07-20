//
//  XProxy.m
//  Pods
//
//  Created by 王旭 on 2020/7/13.
//

#import "XProxy.h"

@implementation XProxy

+ (instancetype)proxyWithTarget:(id)target {
	XProxy * proxy = [XProxy alloc];
	proxy.target = target;
	return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
	return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	[invocation invokeWithTarget:self.target];
}

@end
