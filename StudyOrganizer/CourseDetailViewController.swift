//
//  CourseDetailViewController.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 01.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol SaveTodoDelegate: class {
    func didPressSaveTodo(course: Course) -> Bool
}

class CourseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titelLabel: UINavigationItem!
    @IBOutlet weak var ectsLabel: UILabel!
    @IBOutlet weak var examLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var course: Course!
    
    weak var delegate: SaveTodoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initView()
    }
    
    func initView() {
        titelLabel.title = course.name
        ectsLabel.text = "ECTS: \(course.ECTS)"
        let date = NSDateFormatter()
        date.dateStyle = NSDateFormatterStyle.ShortStyle
        examLabel.text = "Date of exam: \(date.stringFromDate(course.exam))"
        if(course.done) {
            gradeLabel.text = "Grade: \(String(course.grade))"
        } else {
            gradeLabel.text = ""
        }
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.todo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)
        
        // Fetches the appropriate String for the data source layout.
        cell.textLabel?.text = course.todo[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your TODO-List for \(course.name)"
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            course.todo.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            // do nothing
        }
        
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? AddCourseViewController
            where segue.identifier == "editCourse" {
                destinationViewController.course = course
                destinationViewController.delegate = self
        }
    }
    
    @IBAction func pressedCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CourseDetailViewController: SaveCourseDelegate {
    func didPressSaveCourse(course: Course) -> Bool {
        self.course = course
        initView()
        return true
    }
}
