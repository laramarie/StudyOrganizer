//
//  CoursesTableViewController.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 27.01.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    
    var courses: [Course]!
    var actualIndex = [Int]()
    var oldIndex = [Int]()
    var numOfActualCourses : Int!
    var numOfOldCourses : Int!
    
    var viewControllers: [UIViewController]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        initializeData()
        self.tableView.reloadData()
    }
    
    func initializeData() {
        // Load any saved courses, otherwise create array.
        if let savedCourses = loadCourses() {
            courses = savedCourses
            getAmountOftCourses()
        } else {
            courses = []
            numOfActualCourses = 0
            numOfOldCourses = 0
        }

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return numOfActualCourses
        } else {
            return numOfOldCourses
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("coursesCell", forIndexPath: indexPath)

        // Fetches the appropriate course for the data source layout.
        let course: Course!
        switch(indexPath.section) {
        case 0:
            course = courses[actualIndex[indexPath.row]]
            let date = NSDateFormatter()
            date.dateStyle = NSDateFormatterStyle.ShortStyle
            cell.detailTextLabel?.text = "Exam date: " + date.stringFromDate(course.exam)
            break
        case 1:
            course = courses[oldIndex[indexPath.row]]
            cell.detailTextLabel?.text = String(course.grade)
            break
        default: return cell
        }
        
        cell.textLabel?.text = course.name
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Current Courses"
        case 1:
            return "Passed Courses"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if(actualIndex.count > 0 && courses[indexPath.row] == courses[actualIndex[indexPath.row]]) {
                courses.removeAtIndex(indexPath.row)
            } else {
                courses.removeAtIndex(oldIndex[indexPath.row])
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            getAmountOftCourses()
            
        }
        
        saveCourses()
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? AddCourseViewController
            where segue.identifier == "addCourse" {
                destinationViewController.delegate = self
        } else if let destinationViewController = segue.destinationViewController as? CourseDetailViewController
            where segue.identifier == "courseDetail" {
                let cell = sender as? UITableViewCell
                let indexPath = tableView.indexPathForCell(cell!)
                destinationViewController.delegate = self
                switch(indexPath!.section) {
                case 0:
                    destinationViewController.course = courses[actualIndex[indexPath!.row]]
                    break
                case 1:
                    destinationViewController.course = courses[oldIndex[indexPath!.row]]
                    break
                default:
                    break
                }
                
        }
    }
    
    // MARK: NSCoding
    func saveCourses() {
        // sort before saving
        courses.sortInPlace { $0.name < $1.name }
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(courses!, toFile: Course.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save user...")
        }
    }
    
    func loadCourses() -> [Course]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Course.ArchiveURL.path!) as? [Course]
    }
    
    // MARK: Get the number of actual/old courses
    func getAmountOftCourses() {
        courses.sortInPlace { $0.name < $1.name }
        numOfOldCourses = 0
        numOfActualCourses = 0
        oldIndex = []
        actualIndex = []
        var counter = 0
        for course in courses {
            if(course.done) {
                numOfOldCourses?++
                oldIndex.append(counter)
            } else {
                numOfActualCourses?++
                actualIndex.append(counter)
            }
            counter++
        }
    }
}

extension CoursesTableViewController: SaveCourseDelegate {
    func didPressSaveCourse(course: Course) -> Bool {
        // Add course and update counter
        courses.append(course)
        getAmountOftCourses()
        
        // Save the course.
        saveCourses()
        
        // Reload table view
        self.tableView.reloadData()
        return true
    }
}

extension CoursesTableViewController: SaveTodoDelegate {
    func didPressSaveTodo(course: Course) -> Bool {
        // Find course and update it
        for cours in courses {
            if(cours.name == course.name) {
                courses.removeAtIndex(courses.indexOf(cours)!)
                courses.append(course)
                break
            }
        }
        getAmountOftCourses()
        
        // Save the course.
        saveCourses()
        
        // Reload table view
        self.tableView.reloadData()
        return true
    }
}
