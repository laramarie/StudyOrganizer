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

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var fieldField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    weak var delegate: SaveProfileDelegate?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        universityField.delegate = self
        fieldField.delegate = self
        
        nameField.text = user?.name
        universityField.text = user?.university
        fieldField.text = user?.fieldOfStudies
        userImageView.image = user?.image
        
        checkValidProfile()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        saveButton.enabled = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidProfile() {
        // Disable the Save button if the text field is empty.
        if (nameField.text == "" || universityField.text == "" || fieldField.text == "") {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        nameField.resignFirstResponder()
        universityField.resignFirstResponder()
        fieldField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func cancelEditingPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        nameField.text = user?.name
        universityField.text = user?.university
        fieldField.text = user?.fieldOfStudies
        userImageView.image = user?.image
        print("Editing cancelled")
    }
    
    @IBAction func saveProfile(sender: UIBarButtonItem) {
        if (nameField.text == "" || universityField.text == "" || fieldField.text == "") {
        } else {
            user?.name = nameField!.text!
            user?.university = universityField!.text!
            user?.fieldOfStudies = fieldField!.text!
            user?.image = userImageView!.image
            if let success = delegate?.didPressSaveProfile(user!) where success {
                self.dismissViewControllerAnimated(true, completion: nil)
                print("Profile saved")
            }
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
        
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Cancelled")
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
        
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
        // Set userImageView to display the selected image.
        userImageView.contentMode = .ScaleAspectFit
        user?.image = selectedImage
        userImageView.image = user?.image
        print(user)
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
}

