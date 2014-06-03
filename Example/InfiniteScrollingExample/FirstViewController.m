//
//  FirstViewController.m
//  CCInfiniteScrollingExample
//
//  Created by ziryanov on 02/06/14.
//  Copyright (c) 2014 ziryanov. All rights reserved.
//

#import "FirstViewController.h"

@interface Cell : UICollectionViewCell
@end

@implementation Cell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor purpleColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end

@interface FirstViewController ()

@property (nonatomic) NSUInteger numOfCells;
@property (nonatomic) NSUInteger cellOffset;

@end

@implementation FirstViewController

NSUInteger maxOfCells = 140;
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refreshPressed];
    [self setupLoadMore];
}

- (void)setupLoadMore
{
    __weak FirstViewController *wself = self;
    [_collectionView addTopInfiniteScrollingWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            wself.cellOffset = MAX(0, wself.cellOffset - 20);
            wself.numOfCells += 20;
            if (wself.numOfCells >= maxOfCells)
                wself.collectionView.infiniteScrollingDisabled = YES;
            [wself.collectionView reloadDataKeepBottomOffset];
        });
    }];
}

- (IBAction)refreshPressed
{
    _cellOffset = maxOfCells / 2;
    _numOfCells = 20;
    [_collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        _collectionView.contentOffsetY = (_collectionView.contentHeight -_collectionView.height)  / 2;
    });
    _collectionView.infiniteScrollingDisabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_collectionView scrollToBottom];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _numOfCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1]).text = [NSString stringWithFormat:@"cell %d", _cellOffset + (int)indexPath.row + 1];
    return cell;
}

@end

@implementation ThirdController

static UIRefreshControl *_refresh = 0;
- (void)setupLoadMore
{
    _refresh = [UIRefreshControl new];
    [self.collectionView addSubview:_refresh];
    [_refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    __block int jj = 0;
    __weak FirstViewController *wself = self;
    [self.collectionView addBottomInfiniteScrollingWithActionHandler:^{
        if (++jj % 2 == 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wself.numOfCells += 20;
                if (wself.numOfCells >= maxOfCells)
                    wself.collectionView.infiniteScrollingDisabled = YES;
                [wself.collectionView reloadData];
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wself.collectionView.infiniteScrollingBlockFailed = YES;
            });
        }
    }];
}

- (void)refresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshPressed];
        [_refresh endRefreshing];
    });
}

@end

@implementation FourthController

- (void)setupLoadMore
{
    __block int jj = 0, ij = 0;
    __weak FirstViewController *wself = self;
    [self.collectionView addTopInfiniteScrollingWithActionHandler:^{
        if (++jj % 2 == 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wself.cellOffset = MAX(0, wself.cellOffset - 20);
                wself.numOfCells += 20;
                if (wself.numOfCells >= maxOfCells)
                {
                    wself.collectionView.topInfiniteScrollingDisabled = YES;
                    wself.collectionView.bottomInfiniteScrollingDisabled = YES;
                }
                [wself.collectionView reloadDataKeepBottomOffset];
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wself.collectionView.topInfiniteScrollingBlockFailed = YES;
            });
        }
    }];
    [self.collectionView addBottomInfiniteScrollingWithActionHandler:^{
        if (++ij % 2 == 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wself.numOfCells += 20;
                if (wself.numOfCells >= maxOfCells)
                {
                    wself.collectionView.topInfiniteScrollingDisabled = YES;
                    wself.collectionView.bottomInfiniteScrollingDisabled = YES;
                }
                [wself.collectionView reloadData];
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wself.collectionView.bottomInfiniteScrollingBlockFailed = YES;
            });
        }
    }];
}

@end
