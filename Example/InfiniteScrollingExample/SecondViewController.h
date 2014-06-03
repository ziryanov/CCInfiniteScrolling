//
//  SecondViewController.h
//  CCInfiniteScrollingExample
//
//  Created by ziryanov on 02/06/14.
//  Copyright (c) 2014 ziryanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (nonatomic) IBOutlet UITableView *tableView;
- (IBAction)refreshPressed;

@end
