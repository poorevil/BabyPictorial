//
//  CycleScrollView.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "CycleScrollView.h"

@implementation CycleScrollView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction views:(NSArray *)customViewsArray
{
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = frame;
        scrollDirection = direction;
        totalPage = customViewsArray.count;
        curPage = 1;                                    // 显示的是图片数组里的第一张图片
        curViews = [[NSMutableArray alloc] init];
        viewsArray = [[NSArray alloc] initWithArray:customViewsArray];
        
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.scrollsToTop = NO;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        // 在水平方向滚动
        if(scrollDirection == CycleDirectionLandscape) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动 
        if(scrollDirection == CycleDirectionPortait) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }
        
        [self addSubview:scrollView];
        [self refreshScrollView];
    }
    
    return self;
}

- (void)refreshScrollView {
    
    NSArray *subViews = [scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayViewsWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [curViews objectAtIndex:i];
        view.frame = scrollFrame;
        
        // 水平滚动
        if(scrollDirection == CycleDirectionLandscape) {
            view.frame = CGRectOffset(view.frame, scrollFrame.size.width * i, 0);
        }
        // 垂直滚动
        if(scrollDirection == CycleDirectionPortait) {
            view.frame = CGRectOffset(view.frame, 0, scrollFrame.size.height * i);
        }
        
        [scrollView addSubview:view];
    }
    if (scrollDirection == CycleDirectionLandscape) {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
    }
}

- (NSArray *)getDisplayViewsWithCurpage:(int)page {
    
    int pre = [self validPageValue:page-1];//curPage
    int last = [self validPageValue:page+1];//curPage
    
    if([curViews count] != 0) [curViews removeAllObjects];
    
    [curViews addObject:[viewsArray objectAtIndex:pre-1]];
    [curViews addObject:[viewsArray objectAtIndex:curPage-1]];
    [curViews addObject:[viewsArray objectAtIndex:last-1]];
    
    return curViews;
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

-(void)showNextPage
{
    CGPoint offsetPoint = scrollView.contentOffset;
    CGRect destRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    destRect.origin.x = offsetPoint.x + self.frame.size.width;
    
    [scrollView scrollRectToVisible:destRect animated:YES];
    
    [self scrollViewDidScroll:scrollView];
    
//    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
//    NSLog(@"did  x=%d  y=%d", x, y);
    
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(x <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(y <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollView:)]) {
        [delegate cycleScrollViewDelegate:self didScrollView:curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
//    int x = aScrollView.contentOffset.x;
//    int y = aScrollView.contentOffset.y;
//    
//    NSLog(@"--end  x=%d  y=%d", x, y);
    
    if (scrollDirection == CycleDirectionLandscape) {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
    }
}

- (void)dealloc
{
    [viewsArray release];
    [curViews release];
    
    [super dealloc];
}


@end
