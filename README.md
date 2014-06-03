# CCInfiniteScrolling

These UIScrollView categories makes it super easy to add infinite scrolling functionalities to any UIScrollView (or any of its subclass). Instead of relying on delegates and/or subclassing `UIViewController`, CCInfiniteScrolling uses the Objective-C runtime to add the following 2 methods to `UIScrollView`:

```objective-c
- (void)addTopInfiniteScrollingWithActionHandler:(void (^)())actonHandler;
- (void)addBottomInfiniteScrollingWithActionHandler:(void (^)())actonHandler;
```

## Installation

### From CocoaPods

Add `pod 'CCInfiniteScrolling'` to your Podfile.

## Usage

(see sample Xcode project in `/Example`)

### Adding Infinite Scrolling

```objective-c
[_tableView addBottomInfiniteScrollingWithActionHandler:^{
    //this block will be trigger when user has been scrolled near to bottom of tableview;
    //you can start load more request or smth
    //simply call [_tableView reloadData] when your request finish
    }];
```

You can temporarily disable the infinite scrolling view by setting the `infiniteScrollingDisabled` property:

```objective-c
tableView.infiniteScrollingDisabled = YES;
```

#### Customization

The infinite scrolling view can be customized using the following methods:

```objective-c
@property (nonatomic) IBOutlet UIView *infiniteScrollingCustomView;
@property (nonatomic) IBOutlet UIView *infiniteScrollingCustomFailedView;
+ (void)setInfinityScrollingCustomBlockFailedImage:(UIImage *)image;

@property (nonatomic) IBOutlet UIView *topInfiniteScrollingCustomView;
@property (nonatomic) IBOutlet UIView *bottomInfiniteScrollingCustomView;
@property (nonatomic) IBOutlet UIView *topInfiniteScrollingCustomFailedView;
@property (nonatomic) IBOutlet UIView *bottomInfiniteScrollingCustomFailedView;
@property (nonatomic) BOOL topInfiniteScrollingDisabled;
@property (nonatomic) BOOL bottomInfiniteScrollingDisabled;
@property (nonatomic) BOOL topInfiniteScrollingBlockFailed;
@property (nonatomic) BOOL bottomInfiniteScrollingBlockFailed;
```
