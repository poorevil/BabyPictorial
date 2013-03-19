//
//  CycleScrollView.h
//  CycleScrollDemo
//  循环滚动ScrollView
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CycleDirectionPortait,          // 垂直滚动
    CycleDirectionLandscape         // 水平滚动
}CycleDirection;

@protocol CycleScrollViewDelegate;

@interface CycleScrollView : UIView <UIScrollViewDelegate> {
    
    UIScrollView *scrollView;
//    UIImageView *curImageView;
    
    int totalPage;  
    int curPage;
    CGRect scrollFrame;
    
    CycleDirection scrollDirection;     // scrollView滚动的方向
    NSArray *viewsArray;               // 存放所有需要滚动的view
    NSMutableArray *curViews;          // 存放当前滚动的三个view
    
    id delegate;
}

@property (nonatomic, assign) id delegate;

- (int)validPageValue:(NSInteger)value;
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction views:(NSArray *)customViewsArray;
- (NSArray *)getDisplayViewsWithCurpage:(int)page;
- (void)refreshScrollView;
-(void)showNextPage;//显示下一页

@end

@protocol CycleScrollViewDelegate <NSObject>
@optional
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollView:(int)index;

@end