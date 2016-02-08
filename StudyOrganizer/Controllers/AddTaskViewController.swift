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
    var notFinishedCourses = [Int]()
    
    weak var delegate: SaveTaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = ""

        // Do any additional setup after loading the view.
        self.coursePicker.dataSource = self
        self.coursePicker.delegate = self
        
        self.addBottomLineToTextField(descriptionLabel)
    }
    
    private func addBottomLineToTextField(textField : UITextField) {
        // change appearance of the text input fields to bottom line
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height)
        border.borderWidth = borderWidth
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }

    // MARK: UIPIckerViewDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // only create tasks for courses which aren't done yet
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        var index = 0
        notFinishedCourses = []
        for course in courses {
            if(!course.done) {
                count++
                notFinishedCourses.append(index)
            }
            index++
        }
        return count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses[notFinishedCourses[row]].name
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
        print("Adding cancelled")
    }
    
    @IBAction func savebuttonPressed(sender: UIBarButtonItem) {
        if !(descriptionLabel.text == "") {
            let index = coursePicker.selectedRowInComponent(0)
            let newTask = Task(descript: descriptionLabel.text!, done: false)
            courses[notFinishedCourses[index]].todo.append(newTask)
            if let success = delegate?.didPressSaveTask(courses!) where success {
                self.dismissViewControllerAnimated(true, completion: nil)
                print("Task saved")
            }
        }
    }
}
