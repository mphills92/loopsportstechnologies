//
//  MonthOneViewController.swift
//  carpoolApp_v1.0
//
//  Created by Matt Hills on 8/17/16.
//  Copyright © 2016 Matthew Hills. All rights reserved.
//

import UIKit

class MonthOneViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var calendarMonthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var generalCalendarData = GeneralCalendarData()
    var calendarMonthOne = CalendarMonthOne()
    
    var currentDay = Int()
    var currentMonth = Int()
    var currentYear = Int()
    var thisMonth = Int()
    var daysInThisMonth = [Int()]
    
    var cellToAdjustHighlight = NSIndexPath()
    var highlightedCell = NSIndexPath()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 8
        backgroundView.alpha = 0.5
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.delaysContentTouches = false
        
        currentDay = generalCalendarData.getCurrentDateInfo().currentDay
        currentMonth = generalCalendarData.getCurrentDateInfo().currentMonth
        currentYear = generalCalendarData.getCurrentDateInfo().currentYear
        
        //// Change for various Page View Controllers.
        thisMonth = currentMonth - 1
        //////////////////////////////////////////////
        
        //daysInThisMonth = generalCalendarData.setDaysOfMonth(thisMonth)
        
        calendarMonthLabel.text = "\(generalCalendarData.calendarMonths[thisMonth])" + " \(currentYear)"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userHasCanceledTimeSelection:", name: "userCanceledTimeSelectionNotificationMonthOne", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userCanceledTimeSelectionNotificationMonthOne", object: self.view.window)
    }
}

extension MonthOneViewController: UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return generalCalendarData.daysPerCalendarMonth[thisMonth]
        return calendarMonthOne.monthDates.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarCollectionViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.numericDate.text = calendarMonthOne.monthDates[indexPath.item]
        
        if (cell.numericDate.text == "") {
            cell.userInteractionEnabled = false
        }
        
        if (cell.numericDate.text != "") {
            if (Int(cell.numericDate.text!)! < Int(currentDay)) {
                cell.numericDate.textColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.75)
                cell.userInteractionEnabled = false
            }
        }
        
        cell.selectedDateView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        cell.selectedDateView.layer.cornerRadius = 8
        cell.selectedDateView.hidden = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 7), height: (collectionView.frame.width / 6))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalendarCollectionViewCell
        
        cellToAdjustHighlight = indexPath
        highlightedCell = NSIndexPath()
        highlightCell(cellToAdjustHighlight)
    }
    
    func highlightCell(cellToAdjustHighlight: NSIndexPath) -> NSIndexPath {
        let cell = collectionView.cellForItemAtIndexPath(cellToAdjustHighlight) as! CalendarCollectionViewCell
     
        cell.selectedDateView.layer.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        cell.selectedDateView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.selectedDateView.layer.borderWidth = 1
     
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            cell.selectedDateView.transform = CGAffineTransformMakeScale(1, 1)
            cell.selectedDateView.hidden = false
            }, completion: nil)
     
        highlightedCell = cellToAdjustHighlight
        
        let senderPageViewID = 1
        NSNotificationCenter.defaultCenter().postNotificationName("userHasSelectedAMonthNotification", object: senderPageViewID)
        
        let senderDayID = Int(cell.numericDate.text!)
        NSNotificationCenter.defaultCenter().postNotificationName("userHasSelectedADayNotification", object: senderDayID)
        return highlightedCell
    }

    func unhighlightCell(highlightedCell: NSIndexPath) -> NSIndexPath {
        let cell = collectionView.cellForItemAtIndexPath(highlightedCell) as! CalendarCollectionViewCell
     
        cell.selectedDateView.layer.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(1.0).CGColor
        cell.selectedDateView.layer.borderColor = UIColor.clearColor().CGColor
        cell.selectedDateView.layer.borderWidth = 0
     
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            cell.selectedDateView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            cell.selectedDateView.hidden = true
            }, completion: nil)
     
        cellToAdjustHighlight = NSIndexPath()
        return highlightedCell
    }
    
    func userHasCanceledTimeSelection(notification: NSNotification) {
        unhighlightCell(highlightedCell)
    }
}
