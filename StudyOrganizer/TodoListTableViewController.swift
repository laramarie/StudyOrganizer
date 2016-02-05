//
//  TodoListTableViewController.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 01.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    var courses: [Course]!
    var filledIndex = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCourses()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        setCourses()
        self.tableView.reloadData()
    }
    
    func setCourses() {
        if let savedCourses = loadCourses() {
            courses = savedCourses
        } else {
            courses = []
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 0
        var index = 0
        for course in courses {
            if(course.todo.count > 0) {
                count++
                filledIndex.append(index)
            }
            index++
        }
        
        return count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses[filledIndex[section]].todo.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoItem", forIndexPath: indexPath)
        
        // Fetches the appropriate course for the data source layout.
        let course = courses[filledIndex[indexPath.section]]
        cell.textLabel?.text = course.todo[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(courses[section].name)"
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            courses[indexPath.section].todo.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            // do nothing
        }
        
        saveCourses()
        self.tableView.reloadData()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? AddTaskViewController
            where segue.identifier == "addTask" {
                destinationViewController.delegate = self
                destinationViewController.courses = courses
        }
    }
}

extension TodoListTableViewController: SaveTaskDelegate {
    func didPressSaveTask(course: [Course]) -> Bool {
        courses = course
        
        // Save the course.
        saveCourses()
        
        // Reload table view
        self.tableView.reloadData()
        return true
    }
}
