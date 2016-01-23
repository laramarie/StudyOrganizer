//
//  ViewController.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 22.01.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

class OverviewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user = User.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUser()
    }

    func initializeUser() {
        nameLabel.text = user.name
        universityLabel.text = user.university
        fieldLabel.text = user.fieldOfStudies
        userImageView.image = user.image
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? ProfileViewController
            where segue.identifier == "editProfile" {
                destinationViewController.user = user
                destinationViewController.delegate = self
            }
    }
    
    private func updateView() {
        nameLabel.text = user.name
        universityLabel.text = user.university
        fieldLabel.text = user.fieldOfStudies
        userImageView.image = user.image
    }
}

extension OverviewController: SaveProfileDelegate {
    func didPressSaveProfile(user: User) -> Bool {
        self.user = user
        updateView()
        return true
    }
}