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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load any saved courses, otherwise create array.
        if let savedCourses = loadCourses() {
            courses = savedCourses
            getAmountOftCourses()
        } else {
            courses = []
            numOfActualCourses = 0
            numOfOldCourses = 0
        }
        tableView.dataSource = self
        tableView.delegate = self
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
        let cell = tableView.dequeueReusableCellWithIdentifier("coursesCell", forIndexPath: indexPath) as! CoursesTableViewCell

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
            return "Active Courses"
        case 1:
            return "Old Courses"
        default:
            return ""
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    /*private func updateView() {
        nameLabel.text = user?.name
        universityLabel.text = user?.university
        fieldLabel.text = user?.fieldOfStudies
        userImageView.image = user?.image
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? AddCourseViewController
            where segue.identifier == "addCourse" {
                destinationViewController.delegate = self
        }
    }
    
    // MARK: NSCoding
    func saveCourses() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(courses!, toFile: Course.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save user...")
        }
    }
    
    func loadCourses() -> [Course]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Course.ArchiveURL.path!) as? [Course]
    }
    
    //MARK: Get the number of actual/old courses
    func getAmountOftCourses() {
        numOfOldCourses = 0
        numOfActualCourses = 0
        var counter = 0
        for course in courses {
            if(course.done) {
                print(course.done)
                numOfOldCourses?++
                oldIndex.append(counter)
            } else {
                print(course.done)
                numOfActualCourses?++
                actualIndex.append(counter)
            }
            counter++
        }
    }
}

extension CoursesTableViewController: SaveCourseDelegate {
    func didPressSaveCourse(course: Course) -> Bool {
        courses.append(course)
        if(course.done) {
            numOfOldCourses? += 1
        } else {
            numOfActualCourses? += 1
        }
        // Save the course.
        saveCourses()
        return true
    }
}
