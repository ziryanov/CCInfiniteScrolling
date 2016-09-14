//
//  FirstViewController.swift
//  InfiniteScrollingExample
//
//  Created by ziryanov on 14/09/16.
//  Copyright © 2016 Cloud Castle. All rights reserved.
//

import UIKit
import CCInfiniteScrolling
import UIView_TKGeometry

final class Cell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.purpleColor().CGColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}

class FirstViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    let maxOfCells = 100
    var numOfCells = 0
    var cellOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIScrollView.setInfinityScrollingTriggerOffset(100)
        refreshPressed()
        setupLoadMore()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.scrollToBottom()
    }
    
    @IBAction func refreshPressed() {
        cellOffset = maxOfCells / 2
        numOfCells = 20
        collectionView.reloadData()
        collectionView.infiniteScrollingDisabled = false
        delay {
            self.collectionView.setContentOffsetY((self.collectionView.contentHeight() - self.collectionView.height())  / 2)
        }
    }

    func setupLoadMore() {
        collectionView.addTopInfiniteScrollingWithActionHandler { [unowned self] in
            delay(1) {
                let additional = min(20, self.cellOffset)
                self.cellOffset -= additional
                self.numOfCells += additional
                if self.cellOffset == 0 {
                    self.collectionView.infiniteScrollingDisabled = true
                }
                self.collectionView.reloadDataKeepBottomOffset()
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCells
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        (cell.viewWithTag(1) as? UILabel)?.text = "cell \(cellOffset + indexPath.row + 1)"
        return cell
    }
}

final class ThirdController: FirstViewController {
    
    private var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.addSubview(refresh)
        refresh.addTarget(self, action: "refreshAction", forControlEvents: .ValueChanged)
    }
    
    var jj = 0
    override func setupLoadMore() {
        self.collectionView.addBottomInfiniteScrollingWithActionHandler {
            if ++self.jj % 2 == 0 {
                delay(1) {
                    self.numOfCells += 20
                    if self.numOfCells > self.maxOfCells {
                        self.collectionView.infiniteScrollingDisabled = true
                    }
                    self.collectionView.reloadData()
                }
            }
            else {
                delay(1) {
                    self.collectionView.infiniteScrollingBlockFailed = true
                }
            }
        }
    }
    
    func refreshAction() {
        delay(1) {
            self.refreshPressed()
            self.refresh.endRefreshing()
        }
    }
}

