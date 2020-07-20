//
//  ViewController.m
//  BaseForiOS
//
//  Created by 王旭 on 2020/7/20.
//  Copyright © 2020 王旭. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong)UILabel *l;
@end

@implementation ViewController

- (void)loadView {
	[super loadView];
	self.l.text = @"12122";
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:self.l];
	// Do any additional setup after loading the view.
}

- (UILabel *)l {
	if (!_l) {
		_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 40)];
	}
	return _l;
}

@end
