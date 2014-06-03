//
//  UIScrollView+infiniteScrolling.h
//  Overhear
//
//  Created by ziryanov on 02/11/13.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (infiniteScrolling)

/// Add the action handler that will be triggered when scrollview has been scrolled to top.
/// This action handler will be triggered once unless you call -infiniteScrollViewContentUpdated.
- (void)addTopInfiniteScrollingWithActionHandler:(void (^)())actonHandler;

/// Add the action handler that will trigger when scrollview has been scrolled to bottom.
/// This action handler will be triggered once unless you call -(void)infiniteScrollViewContentUpdated.
- (void)addBottomInfiniteScrollingWithActionHandler:(void (^)())actonHandler;

/// Temporary disable infinity scroll
@property (nonatomic) BOOL infiniteScrollingDisabled;

/// Set infiniteScrollingBlockFailed to YES to show infiniteScrollingCustomFailedView instead of infiniteScrollingCustomView.
/// If infiniteScrollingBlockFailed is YES, then action handler will not be triggered by scrolling.
@property (nonatomic) BOOL infiniteScrollingBlockFailed;

/// Call this method to allow action handler been triggered for the next time
/// This method is called from [UITableView reloadData] and [UICollectionView reload], so in most cases you do not have to call it directly
- (void)infiniteScrollViewContentUpdated;



//---------------------------------------------------------------------------------------
// Customization
//---------------------------------------------------------------------------------------

/// The view that will be shown on top/bottom of scrollView.
/// Default infinityScrollingCustomView is transparent view with UIActivityIndicatorView.
@property (nonatomic) IBOutlet UIView *infiniteScrollingCustomView;

/// The view that will be shown on top/bottom of scrollView if infiniteScrollingBlockFailed is YES.
/// Default infiniteScrollingCustomFailedView is button with reload image, clicking this button triggers action handler.
/// You can change this image in all infiniteScrollingCustomFailedViews by +(void)setInfinityScrollingCustomBlockFailedImage:
@property (nonatomic) IBOutlet UIView *infiniteScrollingCustomFailedView;

/// Change button image in all infiniteScrollingCustomFailedViews
+ (void)setInfinityScrollingCustomBlockFailedImage:(UIImage *)image;



//---------------------------------------------------------------------------------------
// Use these methods only if you want use top and bottom infinity scrolling simultaneously
//---------------------------------------------------------------------------------------
// If you added topActionHandeler and bottomActionHandler on the scrollView you should use these methods
// instead of infiniteScrollingDisabled/infiniteScrollingBlockFailed/infiniteScrollingCustomView/infiniteScrollingCustomFailedView

/// See infiniteScrollingCustomView
@property (nonatomic) IBOutlet UIView *topInfiniteScrollingCustomView;
@property (nonatomic) IBOutlet UIView *bottomInfiniteScrollingCustomView;

/// See infiniteScrollingCustomFailedView
@property (nonatomic) IBOutlet UIView *topInfiniteScrollingCustomFailedView;
@property (nonatomic) IBOutlet UIView *bottomInfiniteScrollingCustomFailedView;

/// See infiniteScrollingDisabled
@property (nonatomic) BOOL topInfiniteScrollingDisabled;
@property (nonatomic) BOOL bottomInfiniteScrollingDisabled;

/// See infiniteScrollingBlockFailed
@property (nonatomic) BOOL topInfiniteScrollingBlockFailed;
@property (nonatomic) BOOL bottomInfiniteScrollingBlockFailed;

@end

@interface UIScrollView (infiniteScrollingHelper)

- (void)scrollToBottom;

@end

@interface UITableView (infiniteScrollingHelper)

- (void)reloadDataKeepBottomOffset;

@end

@interface UICollectionView (infiniteScrollingHelper)

- (void)reloadDataKeepBottomOffset;

@end
