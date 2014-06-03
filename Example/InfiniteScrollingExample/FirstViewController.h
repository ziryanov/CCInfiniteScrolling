//
//  FirstViewController.h
//  CCInfiniteScrollingExample
//
//  Created by ziryanov on 02/06/14.
//  Copyright (c) 2014 ziryanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)refreshPressed;

@end

@interface ThirdController : FirstViewController
@end

@interface FourthController : FirstViewController
@end