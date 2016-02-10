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
    
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        updateView()
    }
    
    private func initializeData() {
        // Load any saved meals, otherwise load sample data.
        if let savedUser = loadUser() {
            user = savedUser
        } else {
            // Load the sample data.
            loadSampleUser()
        }
    }
    
    private func updateView() {
        nameLabel.text = user?.name
        universityLabel.text = user?.university
        fieldLabel.text = user?.fieldOfStudies
        userImageView.image = user?.image
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? ProfileViewController
            where segue.identifier == "editProfile" {
                destinationViewController.user = user
                destinationViewController.delegate = self
            }
    }
    
    // MARK: NSCoding
    func saveUser() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user!, toFile: User.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save user...")
        }
    }
    
    func loadUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? User
    }
    
    func loadSampleUser() {
        user = User(name: "Your name", university: "Your university", fieldOfStudies: "Your field of studies",
            image: UIImage(named: "defaultImage")!)
    }
}

extension OverviewController: SaveProfileDelegate {
    func didPressSaveProfile(user: User) -> Bool {
        self.user = user
        
        // Save the user.
        saveUser()
        
        updateView()
        
        return true
    }
}