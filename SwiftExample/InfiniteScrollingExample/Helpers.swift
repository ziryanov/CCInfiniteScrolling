//
//  Helpers.swift
//  InfiniteScrollingExample
//
//  Created by ziryanov on 14/09/16.
//  Copyright © 2016 Cloud Castle. All rights reserved.
//

import UIKit

func delay(delay: Double = 0, closure: () -> ()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}