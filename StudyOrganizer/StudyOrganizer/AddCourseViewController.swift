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

        if(course != nil) {
            nameField.text = course?.name
            if(course?.ECTS != nil) {
                ectsSlider.value = Float(course!.ECTS)
            }
            doneSwitch.enabled = (course?.done)!
            gradeField.text = String(course?.grade)
            datePicker.date = (course?.exam)!
        }
    }

    @IBAction func pressedSaveButton(sender: UIBarButtonItem) {
    }
    
    @IBAction func saveProfile(sender: UIBarButtonItem) {
        checkValidCourse()
        if(course != nil) {
            course?.name = nameField.text!
            course?.ECTS = Int(ectsSlider.value)
            course?.done = doneSwitch.enabled
            course?.grade = Double(gradeField.text!)!
            course?.exam = datePicker.date
        } else {
            course = Course(name: nameField.text!, ECTS: Int(ectsSlider.value), grade: Double(gradeField.text!)!, done: doneSwitch.enabled, todo: [], exam: datePicker.date)
        }
        if let success = delegate?.didPressSaveCourse(course!) where success {
            navigationController?.popViewControllerAnimated(true)
            print("Profile saved")
        }
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
    
    func checkValidCourse() {
        // Disable the Save button if the text field is empty.
        if (nameField.text == "" || gradeField.text == "") {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
}
