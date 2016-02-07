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
        numberOfSectionsInTableView(self.tableView)
        self.tableView.reloadData()
    }
    
    private func setCourses() {
        // initialize courses from CoreData
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
        filledIndex = []
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
        let cell = tableView.dequeueReusableCellWithIdentifier("todoItem", forIndexPath: indexPath) as?
        TodoItemTableViewCell
        
        cell!.delegate = self
        
        // Fetches the appropriate course for the data source layout.
        let course = courses[filledIndex[indexPath.section]]
        cell!.todoItemLabel.text = course.todo[indexPath.row].descript
        if(course.todo[indexPath.row].done) {
            cell!.checkButton.setState(true)
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(courses[filledIndex[section]].name)"
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            courses[filledIndex[indexPath.section]].todo.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        
        saveCourses()
        self.tableView.reloadData()
    }
    
    // MARK: NSCoding
    func saveCourses() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(courses!, toFile: Course.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save courses...")
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

extension TodoListTableViewController: TodoItemCheckedDelegate {
    func didUpdateTodoList(todoName: String) -> Bool {
        for course in courses {
            for todoItem in course.todo {
                if todoName == todoItem.descript {
                    if todoItem.done {
                        todoItem.done = false
                    } else {
                        todoItem.done = true
                    }
                }
            }
        }
        return true
    }
}
