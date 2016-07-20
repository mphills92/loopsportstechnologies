//
//  SidebarMenuViewController.swift
//  carpoolApp_v1.0
//
//  Created by Matt Hills on 6/6/16.
//  Copyright © 2016 Matthew Hills. All rights reserved.
//

import UIKit

class SidebarMenuViewController: UIViewController {
    
    @IBOutlet weak var caddieMenuOptionButton: UIButton!
    
    let userAccount = UserAccount()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCaddieMenuOptionButton()
        
    }
}

extension SidebarMenuViewController {
    
    func setCaddieMenuOptionButton() {
        if (userAccount.userHasCaddieAccount == false) {
            caddieMenuOptionButton.setTitle("Become a Caddie", forState: .Normal)
        } else {
            caddieMenuOptionButton.setTitle("Go To Caddie Mode", forState: .Normal)
            caddieMenuOptionButton.titleLabel!.font = UIFont(name: "AvenirNext-Regular", size: 20)
            caddieMenuOptionButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            caddieMenuOptionButton.backgroundColor = UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1.0)
            //caddieMenuOptionButton.layer.borderColor = UIColor.yellowColor().CGColor
            //caddieMenuOptionButton.layer.borderWidth = 1
            caddieMenuOptionButton.layer.cornerRadius = 20 //caddieMenuOptionButton.bounds.height / 2
        }
    }
    
    @IBAction func caddieMenuOptionButtonPressed(sender: AnyObject) {
        if (userAccount.userHasCaddieAccount == false) {
            performSegueWithIdentifier("toBecomeCaddieSegue", sender: self)
        } else {
            performSegueWithIdentifier("toCaddieModeSegue", sender: self)
        }
    }
    
}
