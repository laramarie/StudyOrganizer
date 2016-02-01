//
//  AddTaskViewController.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 01.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol SaveTaskDelegate: class {
    func didPressSaveTask(courses: [Course]) -> Bool
}

class AddTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var descriptionLabel: UITextField!
    
    var courses: [Course]!
    
    weak var delegate: SaveTaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.coursePicker.dataSource = self;
        self.coursePicker.delegate = self;
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses[row].name
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        descriptionLabel.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        saveButton.enabled = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    @IBAction func cancelAddingPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        descriptionLabel.text = ""
        print("Editing cancelled")
    }
    
    @IBAction func savebuttonPressed(sender: UIBarButtonItem) {
        if (descriptionLabel.text == "") {
        } else {
            let index = coursePicker.selectedRowInComponent(0)
            courses[index].todo.append(descriptionLabel.text!)
            if let success = delegate?.didPressSaveTask(courses!) where success {
                self.dismissViewControllerAnimated(true, completion: nil)
                print("Profile saved")
            }
        }
    }
}
