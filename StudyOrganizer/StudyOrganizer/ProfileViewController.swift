//
//  ProfileViewController.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 23.01.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol SaveProfileDelegate: class {
    func didPressSaveProfile(user: User) -> Bool
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var fieldField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    weak var delegate: SaveProfileDelegate?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.text = user?.name
        universityField.text = user?.university
        fieldField.text = user?.fieldOfStudies
        userImageView.image = user?.image
    }

    @IBAction func saveQuestion(sender: UIBarButtonItem) {
        if (nameField.text == "" || universityField.text == "" || fieldField.text == "") {
        } else {
            user?.name = nameField!.text!
            user?.university = universityField!.text!
            user?.fieldOfStudies = fieldField!.text!
            user?.image = userImageView!.image
            if let success = delegate?.didPressSaveProfile(user!) where success {
                navigationController?.popViewControllerAnimated(true)
                print("Profile saved")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

