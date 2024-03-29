//
//  AddCourseViewController.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 25.01.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol SaveCourseDelegate: class {
    func didPressSaveCourse(course: Course) -> Bool
}

class AddCourseViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ectsLabel: UILabel!
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var ectsSlider: UISlider!
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var course: Course?
    
    weak var delegate: SaveCourseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // cannot save before adding information
        saveButton.enabled = false
        
        initializeView()
        
        nameField.delegate = self
        gradeField.delegate = self
        
        
        self.addBottomLineToTextField(nameField)
        self.addBottomLineToTextField(gradeField)
    }
    
    private func initializeView() {
        if(course != nil) {
            nameField.text = course?.name
            if(course?.ECTS != nil) {
                ectsSlider.value = Float(course!.ECTS)
                ectsLabel.text = String(course!.ECTS)
            }
            doneSwitch.on = (course?.done)!
            gradeField.text = String((course?.grade)!)
            datePicker.date = (course?.exam)!
            
            // enable save button for saving changes on UISwitch or DatePicker
            saveButton.enabled = true
        }
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
    
    // MARK: IBActions
    
    @IBAction func changedECTS(sender: UISlider) {
        ectsLabel.text = String(Int(sender.value))
    }
    
    @IBAction func cancelAddingCourse(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        nameField.text = ""
        ectsSlider.value = 1
        ectsLabel.text = "1"
        doneSwitch.on = false
        gradeField.text = ""
        datePicker.date = NSDate.init()
        print("Adding cancelled")
    }
    
    @IBAction func saveProfile(sender: UIBarButtonItem) {
        checkValidCourse()
        
        if(course != nil) {
            //update existing course
            course?.name = nameField.text!
            course?.ECTS = Int(ectsSlider.value)
            course?.done = doneSwitch.on
            course?.grade = Double(gradeField.text!)!
            course?.exam = datePicker.date
        } else if(gradeField.text == ""){
            // add new course with default grade value (0.0)
            course = Course(name: nameField.text!, ECTS: Int(ectsSlider.value), grade: 0, done: doneSwitch.on,
                todo: [], exam: datePicker.date)
        } else {
            // add new course with empty todo list
            course = Course(name: nameField.text!, ECTS: Int(ectsSlider.value), grade: Double(gradeField.text!)!,
                done: doneSwitch.on, todo: [], exam: datePicker.date)
        }
        if let success = delegate?.didPressSaveCourse(course!) where success {
            self.dismissViewControllerAnimated(false, completion: nil)
            print("Course saved")
        }
    }
}

extension AddCourseViewController: UITextFieldDelegate {
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidCourse()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    private func checkValidCourse() {
        // Disable the Save button if the text field is empty.
        if (nameField.text == "") {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
}
