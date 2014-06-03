//
//  UIScrollView+infiniteScrolling.m
//  Overhear
//
//  Created by ziryanov on 02/11/13.
//
//

#import "UIScrollView+infiniteScrolling.h"
#import <UIView+TKGeometry.h>
#import <JRSwizzle.h>
#import <objc/runtime.h>

@implementation UIView (infiniteScrollRemoveAllSubviews)

- (void)is_removeAllSubviews
{
    for (UIView *view in [self.subviews copy])
        [view removeFromSuperview];
}

@end

static UIImage *is_blockFailedImage = 0;

@interface UIScrollView (infiniteScrollingPrivate)

@property (nonatomic, copy) void(^is_topBlock)();
@property (nonatomic, copy) void(^is_bottomBlock)();

@property (nonatomic) BOOL is_topBlockInProgress;
@property (nonatomic) BOOL is_topDisabled;
@property (nonatomic) BOOL is_bottomBlockInProgress;
@property (nonatomic) BOOL is_bottomDisabled;

@property (nonatomic) NSValue *is_contentSize;
@property (nonatomic) NSValue *is_contentInset;

@property (nonatomic) UIView *is_topBox;
@property (nonatomic) UIView *is_bottomBox;

@end

//--------------------------------------------------------------------------------------------------------------------------------------------

@implementation UIScrollView (infiniteScrollingPrivate)
@dynamic is_topBlock, is_topBlockInProgress, is_topDisabled, is_topBox;
@dynamic is_bottomBlock, is_bottomBlockInProgress, is_bottomDisabled, is_bottomBox;
@dynamic is_contentSize, is_contentInset;
@end

//--------------------------------------------------------------------------------------------------------------------------------------------

@implementation UIScrollView (infiniteScrolling)
@dynamic infiniteScrollingCustomView, infiniteScrollingCustomFailedView;
@dynamic infiniteScrollingDisabled, infiniteScrollingBlockFailed;
@dynamic topInfiniteScrollingCustomView, topInfiniteScrollingCustomFailedView;
@dynamic bottomInfiniteScrollingCustomView, bottomInfiniteScrollingCustomFailedView;

+ (void)setInfinityScrollingCustomBlockFailedImage:(UIImage *)image
{
    is_blockFailedImage = image;
}

- (UIView *)is_createDefaultInfiniteScrollingView 
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = view.center;
    [activity startAnimating];
    [view addSubview:activity];
    return view;
}

- (void)addTopInfiniteScrollingWithActionHandler:(void (^)())actonHandler
{
    self.is_topBlock = actonHandler;
    
    if (!self.topInfiniteScrollingCustomView)
        self.topInfiniteScrollingCustomView = self.infiniteScrollingCustomView ?: [self is_createDefaultInfiniteScrollingView ];
    if (!self.infiniteScrollingCustomView)
        self.infiniteScrollingCustomView = self.topInfiniteScrollingCustomView;
    if (!self.is_topBox)
        self.is_topBox = [[UIView alloc] initWithFrame:self.topInfiniteScrollingCustomView.bounds];
    
    [self.is_topBox is_removeAllSubviews];
    
    self.topInfiniteScrollingCustomView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.is_topBox addSubview:self.topInfiniteScrollingCustomView];
}

- (void)addBottomInfiniteScrollingWithActionHandler:(void (^)())actonHandler
{
    self.is_bottomBlock = actonHandler;
    
    if (!self.bottomInfiniteScrollingCustomView)
        self.bottomInfiniteScrollingCustomView = self.infiniteScrollingCustomView ?: [self is_createDefaultInfiniteScrollingView ];
    if (!self.infiniteScrollingCustomView)
        self.infiniteScrollingCustomView = self.bottomInfiniteScrollingCustomView;
    if (!self.is_bottomBox)
        self.is_bottomBox = [[UIView alloc] initWithFrame:self.bottomInfiniteScrollingCustomView.bounds];

    [self.is_bottomBox is_removeAllSubviews];
    
    self.bottomInfiniteScrollingCustomView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.is_bottomBox addSubview:self.bottomInfiniteScrollingCustomView];
}

//---------------------------------------------------------------------------------------------------------

+ (void)load
{
    [self jr_swizzleMethod:@selector(setContentOffset:) withMethod:@selector(is_setContentOffset:) error:nil];
    [self jr_swizzleMethod:@selector(setContentSize:) withMethod:@selector(is_setContentSize:) error:nil];
    [self jr_swizzleMethod:@selector(setContentInset:) withMethod:@selector(is_setContentInset:) error:nil];
}

- (void)infiniteScrollViewContentUpdated
{
    self.is_topBlockInProgress = NO;
    self.is_bottomBlockInProgress = NO;
}

- (BOOL)is_checkContentOffset:(BOOL *)top
{
    if (top)
        *top = self.is_topBlock != 0 && self.contentOffsetY < .75 * self.height;
    
    return (self.is_bottomBlock != 0 && self.contentOffsetY > self.contentHeight - 2 * self.height) ||
           (self.is_topBlock != 0 && self.contentOffsetY < .75 * self.height);
}

- (void)is_setContentOffset:(CGPoint)contentOffset
{
    [self is_setContentOffset:contentOffset];
    if (!self.is_topBlock && !self.is_bottomBlock)
        return;
    BOOL blocksEnabled = (self.is_topBlock != 0 && !self.topInfiniteScrollingDisabled) ||
                         (self.is_bottomBlock != 0 && !self.bottomInfiniteScrollingDisabled);
    if (!blocksEnabled)
        return;

    if (!self.height || self.contentSize.height <= self.height)
        return;
    
    if ([self is_checkContentOffset:0])
    {
        double delayInSeconds = .05;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            BOOL top;
            if (![self is_checkContentOffset:&top])
                return;
            if (top && !self.is_topBlockInProgress && !self.topInfiniteScrollingBlockFailed)
            {
                self.is_topBlockInProgress = YES;
                self.is_topBlock();
            }
            else if (!top && !self.is_bottomBlockInProgress && !self.bottomInfiniteScrollingBlockFailed)
            {
                self.is_bottomBlockInProgress = YES;
                self.is_bottomBlock();
            }
        });
    }
}

- (void)is_setContentInset:(UIEdgeInsets)contentInset
{
    self.is_contentInset = [NSValue valueWithUIEdgeInsets:contentInset];
    [self is_updateContent];
}

- (void)is_setContentSize:(CGSize)contentSize
{
    self.is_contentSize = [NSValue valueWithCGSize:contentSize];
    [self is_updateContent];
}

- (void)is_updateContent
{
    CGSize contentSize = [self.is_contentSize CGSizeValue];
    UIEdgeInsets contentInset = [self.is_contentInset UIEdgeInsetsValue];
    
    BOOL topISViewVisible = self.is_topBlock != 0 && !self.topInfiniteScrollingDisabled && contentSize.height > self.height;
    BOOL bottomISViewVisible = self.is_bottomBlock != 0 && !self.bottomInfiniteScrollingDisabled && contentSize.height > self.height;

    if (topISViewVisible)
    {
        contentInset.top += self.is_topBox.height;
        
        if (!self.is_topBox.superview)
            [self addSubview:self.is_topBox];
        self.is_topBox.maxY = 0;
    }
    else
    {
        if (self.is_topBox.superview)
            [self.is_topBox removeFromSuperview];
    }
    
    if (bottomISViewVisible)
    {
        contentSize.height += self.is_bottomBox.height;
        
        if (!self.is_bottomBox.superview)
            [self addSubview:self.is_bottomBox];
        self.is_bottomBox.maxY = contentSize.height;
    }
    else
    {
        if (self.is_bottomBox.superview)
            [self.is_bottomBox removeFromSuperview];
    }
    
    [self is_setContentSize:contentSize];
    [self is_setContentInset:contentInset];
}

//--------------------------------------------------------------------------------------------------------------------------------------------

- (void)setInfiniteScrollingDisabled:(BOOL)infiniteScrollingDisabled
{
    if (self.is_topBlock != 0)
        self.topInfiniteScrollingDisabled = infiniteScrollingDisabled;
    else if (self.is_bottomBlock != 0)
        self.bottomInfiniteScrollingDisabled = infiniteScrollingDisabled;
}

- (BOOL)infiniteScrollingDisabled
{
    if (self.is_topBlock != 0)
        return self.topInfiniteScrollingDisabled;
    else if (self.is_bottomBlock != 0)
        return self.bottomInfiniteScrollingDisabled;
    return NO;
}

- (void)setInfiniteScrollingBlockFailed:(BOOL)infiniteScrollingBlockFailed
{
    if (self.is_topBlock != 0)
        self.topInfiniteScrollingBlockFailed = infiniteScrollingBlockFailed;
    else if (self.is_bottomBlock != 0)
        self.bottomInfiniteScrollingBlockFailed = infiniteScrollingBlockFailed;
}

- (BOOL)infiniteScrollingBlockFailed
{
    if (self.is_topBlock != 0)
        return self.topInfiniteScrollingBlockFailed;
    else if (self.is_bottomBlock != 0)
        return self.bottomInfiniteScrollingBlockFailed;
    return NO;
}

//--------------------------------------------------------------------------------------------------------------------------------------------

- (void)setTopInfiniteScrollingDisabled:(BOOL)topInfiniteScrollingDisabled
{
    CGFloat contentOffsetY = self.contentOffsetY;
    CGFloat contentHeight = self.contentHeight;
    self.is_topDisabled = topInfiniteScrollingDisabled;
    [self performSelector:@selector(is_updateContent)];
    self.contentOffsetY = contentOffsetY + (self.contentHeight - contentHeight);
}

- (BOOL)topInfiniteScrollingDisabled
{
    return self.is_topDisabled;
}

- (void)setBottomInfiniteScrollingDisabled:(BOOL)bottomInfiniteScrollingDisabled
{
    CGFloat contentOffsetY = self.contentOffsetY;
    self.is_bottomDisabled = bottomInfiniteScrollingDisabled;
    [self is_updateContent];
    self.contentOffsetY = contentOffsetY;
}

- (BOOL)bottomInfiniteScrollingDisabled
{
    return self.is_bottomDisabled;
}

//--------------------------------------------------------------------------------------------------------------------------------------------

- (UIView *)is_createDefaultInfiniteScrollingBlockFailedView:(BOOL)top
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
    [button setImage:is_blockFailedImage ?: [UIImage imageNamed:@"CCInfiniteScrolling.bundle/infinite_scrolling_reload"] forState:UIControlStateNormal];
    [button addTarget:self action:(top ? @selector(topAction) : @selector(bottomAction)) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}
- (void)topAction
{
    self.topInfiniteScrollingBlockFailed = NO;
    self.is_topBlock();
}

- (void)bottomAction
{
    self.bottomInfiniteScrollingBlockFailed = NO;
    self.is_bottomBlock();
}

- (void)addView:(UIView *)viewToAdd toView:(UIView *)superview
{
    [superview is_removeAllSubviews];
    viewToAdd.translatesAutoresizingMaskIntoConstraints = YES;
    viewToAdd.frame = superview.bounds;
    [superview addSubview:viewToAdd];
}

- (void)setTopInfiniteScrollingBlockFailed:(BOOL)topInfiniteScrollingBlockFailed
{
    if (!self.topInfiniteScrollingCustomFailedView)
        self.topInfiniteScrollingCustomFailedView = (self.infiniteScrollingCustomFailedView && self.infiniteScrollingCustomFailedView != self.bottomInfiniteScrollingCustomFailedView) ? self.infiniteScrollingCustomFailedView : [self is_createDefaultInfiniteScrollingBlockFailedView:YES];
    if (!self.infiniteScrollingCustomFailedView)
        self.infiniteScrollingCustomFailedView = self.topInfiniteScrollingCustomFailedView;
    [self addView:topInfiniteScrollingBlockFailed ? self.topInfiniteScrollingCustomFailedView : self.topInfiniteScrollingCustomView toView:self.is_topBox];
}

- (BOOL)topInfiniteScrollingBlockFailed
{
    return [self.is_topBox subviews].count && [self.is_topBox subviews][0] == self.topInfiniteScrollingCustomFailedView;
}

- (void)setBottomInfiniteScrollingBlockFailed:(BOOL)bottomInfiniteScrollingBlockFailed
{
    if (!self.bottomInfiniteScrollingCustomFailedView)
        self.bottomInfiniteScrollingCustomFailedView = (self.infiniteScrollingCustomFailedView && self.infiniteScrollingCustomFailedView != self.topInfiniteScrollingCustomFailedView) ? self.infiniteScrollingCustomFailedView : [self is_createDefaultInfiniteScrollingBlockFailedView:NO];
    if (!self.infiniteScrollingCustomFailedView)
        self.infiniteScrollingCustomFailedView = self.bottomInfiniteScrollingCustomFailedView;
    [self addView:bottomInfiniteScrollingBlockFailed ? self.bottomInfiniteScrollingCustomFailedView : self.bottomInfiniteScrollingCustomView toView:self.is_bottomBox];
}

- (BOOL)bottomInfiniteScrollingBlockFailed
{
    return [self.is_bottomBox subviews].count && [self.is_bottomBox subviews][0] == self.bottomInfiniteScrollingCustomFailedView;
}

//--------------------------------------------------------------------------------------------------------------------------------------------

- (void)scrollToBottom
{
    self.contentOffsetY = MAX(-self.contentInsetTop, self.contentInsetBottom + self.contentSize.height - self.height);
}

@end

@implementation UITableView (infiniteScrollingHelper)

+ (void)load
{
    [self jr_swizzleMethod:@selector(reloadData) withMethod:@selector(is_reloadData) error:nil];
}

- (void)is_reloadData
{
    [self is_reloadData];
    [self infiniteScrollViewContentUpdated];
}

- (void)reloadDataKeepBottomOffset
{
    CGFloat contentOffsetY = self.contentOffsetY;
    CGFloat contentHeight = self.contentHeight;
    [self reloadData];
    self.contentOffsetY = contentOffsetY + (self.contentHeight - contentHeight);
}

@end

@implementation UICollectionView (infiniteScrollingHelper)

+ (void)load
{
    [self jr_swizzleMethod:@selector(reloadData) withMethod:@selector(is_reloadData) error:nil];
}

- (void)is_reloadData
{
    [self is_reloadData];
    [self infiniteScrollViewContentUpdated];
}

- (void)reloadDataKeepBottomOffset
{
    CGFloat contentOffsetY = self.contentOffsetY;
    CGFloat contentHeight = self.contentHeight;
    [self reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentOffsetY = contentOffsetY + (self.contentHeight - contentHeight);
    });
}

@end
