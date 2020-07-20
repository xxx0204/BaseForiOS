//
//  XImageLoopView.m
//  Pods
//
//  Created by 王旭 on 2020/7/13.
//

#import "XImageLoopView.h"
#import "XProxy.h"

@interface XImageLoopView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl       *m_pageControl;
@property (nonatomic, weak) UIScrollView        *m_scrollView;
@property (nonatomic, copy) NSMutableArray      *m_imagesArray;
@property (nonatomic, weak) NSTimer             *m_timer;
@end

@implementation XImageLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		_duration = 1;
        [self UIConfig];
    }
    return self;
}

- (void)UIConfig {
    //创建scrollView
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    _m_scrollView = scrollView;
    [self addSubview:scrollView];
    
    //创建pageControl
    UIPageControl * pageControl = [[UIPageControl alloc]init];
    pageControl.userInteractionEnabled=NO;
    pageControl.currentPageIndicatorTintColor =[UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _m_pageControl = pageControl;
    [self addSubview:pageControl];
}

#pragma mark - 点击轮播图中任意一个图片的时候
-(void)clickScrollViewImage:(UITapGestureRecognizer *)tap{
    //设置tag
    NSInteger tag =(NSInteger)tap.view.tag-100;
    if (tag==self.m_imagesArray.count-1) {
        tag=1;
    } else if (tag==0){
        tag=(NSInteger)self.m_imagesArray.count-2;
    } else {
        
    }
    
    //通知代理做事情
    if (_delegate && [_delegate respondsToSelector:@selector(clickCircleSliderView:)]) {
        [_delegate clickCircleSliderView:tag];
    }
}

#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = x / self.bounds.size.width -1;
    self.m_pageControl.currentPage = page;
    
    CGPoint point =scrollView.contentOffset;
    
    if (point.x==0) {
        [self.m_scrollView setContentOffset:CGPointMake(self.bounds.size.width*(self.m_imagesArray.count-2), 0) animated:NO];
    } else if (point.x==self.bounds.size.width*(self.m_imagesArray.count-1)) {
        [self.m_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

#pragma mark - Timer
//添加计时器
- (void)addTimer {
	self.m_timer = [NSTimer scheduledTimerWithTimeInterval:_duration < 1 ? 1 : _duration target:[XProxy proxyWithTarget:self] selector:@selector(runTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.m_timer forMode:NSRunLoopCommonModes];
}

//移除计时器
- (void)removeTimer {
    [self.m_timer invalidate];
    self.m_timer = nil;
}

- (void)dealloc {
	[self removeTimer];
}

//计时器运行的方法
- (void)runTimer {
    NSInteger page = self.m_pageControl.currentPage;
    CGFloat x = 0;
    if (page == self.m_imagesArray.count - 3) {
        x = self.bounds.size.width * (self.m_imagesArray.count-1);
    } else {
        x = self.bounds.size.width * (page+2);
    }
    [self.m_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    if (self.imageArray.count==0) {
        return;
    }
    for (int i=0; i<self.imageArray.count; i++) {
        NSString * imageString =self.imageArray[i];
        [self.m_imagesArray addObject:imageString];
    }
    if (self.imageArray.count==1) {
        //填充scrollView的contentSize
        [self setupScrollViewSubviews];
        return ;
    }
    
    //把最后一个图片添加到这个数组的第一个位置
    NSString * imageString1 = [self.imageArray lastObject];
    [self.m_imagesArray insertObject:imageString1 atIndex:0];
    
    //把原本第一张的图片 添加到这个数组的末尾
    NSString * imageString2 = [self.imageArray firstObject];
    [self.m_imagesArray addObject:imageString2];
    
    //填充scrollView的contentSize
    [self setupScrollViewSubviews];
}

- (void)setDuration:(NSUInteger)duration {
	_duration = duration;
}

//填充scrollView的contentSize
-(void)setupScrollViewSubviews{
    //给scrollView添加图片
    for (int i = 0; i < self.m_imagesArray.count; i++) {
        UIImageView *myImageView = [[UIImageView alloc]init];
        NSString *imageName = self.m_imagesArray[i];
        myImageView.image = [UIImage imageNamed:imageName];
        myImageView.userInteractionEnabled=YES;
        myImageView.tag=i+100;
        [self.m_scrollView addSubview:myImageView];
        
        //添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickScrollViewImage:)];
        [myImageView addGestureRecognizer:tap];
    }
    
    if (self.m_imagesArray.count==1) {
        self.m_scrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
        self.m_scrollView.scrollEnabled=NO;
        [self removeTimer];
        self.m_pageControl.numberOfPages=1;
    } else {
        self.m_scrollView.contentSize = CGSizeMake(self.bounds.size.width * self.m_imagesArray.count, 0);
        [self.m_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
        self.m_pageControl.numberOfPages= self.m_imagesArray.count-2;
        [self addTimer];
    }
}


-(NSMutableArray *)m_imagesArray{
    if (_m_imagesArray==nil) {
        _m_imagesArray =[NSMutableArray array];
    }
    return _m_imagesArray;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //轮播图的frame
    self.m_scrollView.frame=self.bounds;
    //pageControl的frame
    CGFloat pageControlH = 20;
    CGFloat pageControlW = self.bounds.size.width;
    CGFloat pageControlY = self.frame.size.height - pageControlH;
    CGFloat pageControlX = 0;
    self.m_pageControl.frame=CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    
    //scrollView添加的图片的frame
    for (UIImageView *myImageView in self.m_scrollView.subviews) {
        int i =(int)myImageView.tag-100;
        myImageView.frame=CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    }
}

@end
