//
//  SecondViewController.m
//  CCInfiniteScrollingExample
//
//  Created by ziryanov on 02/06/14.
//  Copyright (c) 2014 ziryanov. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (nonatomic) NSUInteger numOfCells;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _numOfCells = 30;
    
    _tableView.estimatedRowHeight = _tableView.rowHeight;
    [_tableView setInfinityScrollingTriggerOffset:500];
    __weak SecondViewController *wself = self;
    [_tableView addBottomInfiniteScrollingWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            wself.numOfCells += 30;
            if (wself.numOfCells >= 90)
                wself.tableView.infiniteScrollingDisabled = YES;
            [wself.tableView reloadData];
        });
    }];
}

- (IBAction)refreshPressed
{
    _numOfCells = 30;
    _tableView.infiniteScrollingDisabled = NO;
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableView.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"cell %d", (int)indexPath.row + 1];
    return cell;
}

@end
