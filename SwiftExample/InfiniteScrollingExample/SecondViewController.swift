//
//  SecondViewController.swift
//  InfiniteScrollingExample
//
//  Created by ziryanov on 14/09/16.
//  Copyright © 2016 Cloud Castle. All rights reserved.
//

import UIKit
import CCInfiniteScrolling

final class SecondViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet private var tableView: UITableView!
    var numOfCells = 30

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addBottomInfiniteScrollingWithActionHandler { [unowned self] in
            delay(1) {
                self.numOfCells += 20
                if self.numOfCells >= 90 {
                    self.tableView.infiniteScrollingDisabled = true
                }
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func refreshPressed() {
        numOfCells = 20
        tableView.infiniteScrollingDisabled = false
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfCells
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "cell \(indexPath.row + 1)"
        return cell
    }
}
