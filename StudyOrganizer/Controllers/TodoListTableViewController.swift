//
//  TodoListTableViewController.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 01.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var courses: [Course]!
    var filledIndex = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCourses()
        getAmountOfSections()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // add edit button and customize color
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        // load data before showing tab
        setCourses()
        numberOfSectionsInTableView(self.tableView)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        checkForAddingTasks()
    }
    
    private func setCourses() {
        // initialize courses from CoreData
        if let savedCourses = loadCourses() {
            courses = savedCourses
        } else {
            courses = []
        }
    }
    
    private func getAmountOfSections() {
        var index = 0
        filledIndex = []
        for course in courses {
            if(course.todo.count > 0) {
                filledIndex.append(index)
            }
            index++
        }
    }
    
    private func checkForAddingTasks() {
        // only enable add tasks if there are open courses added and send alert if not
        addButton.enabled = false
        for course in courses {
            if(!course.done) {
                addButton.enabled = true
                break
            }
        }
        if(!addButton.enabled) {
            let alertController = UIAlertController(title: "No courses added yet.", message: "Please add a course before using the TODO Tab", preferredStyle: .Alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filledIndex.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses[filledIndex[section]].todo.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoItem", forIndexPath: indexPath) as?
        TodoItemTableViewCell
        
        // set delegate for cell
        cell!.delegate = self
        
        // Fetches the appropriate course for the data source layout.
        // sets data to cell
        let course = courses[filledIndex[indexPath.section]]
        cell!.todoItemLabel.text = course.todo[indexPath.row].descript
        cell!.courseName = course.name
        if(course.todo[indexPath.row].done) {
            cell!.checkButton.setState(true)
        } else {
            cell!.checkButton.setState(false)
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
            filledIndex.removeAtIndex(indexPath.section)
            getAmountOfSections()
            saveCourses()
            
            if(courses[filledIndex[indexPath.section]].todo.count == 1) {
                // last element in section being deleted
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            viewWillAppear(true)
            self.tableView.reloadData()
        }
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
    
    // MARK: Navigation 
    
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
        getAmountOfSections()
        
        // Save the course.
        saveCourses()
        
        // Reload table view
        self.tableView.reloadData()
        return true
    }
}

extension TodoListTableViewController: TodoItemCheckedDelegate {
    func didUpdateTodoList(todoName: String, courseName: String) -> Bool {
        // find matching course
        for course in courses {
            if(courseName == course.name) {
                // find matching todo item in matching course
                for todoItem in course.todo {
                    if(todoName == todoItem.descript) {
                        // update todo item
                        if(todoItem.done) {
                            todoItem.done = false
                        } else {
                            todoItem.done = true
                        }
                        break
                    }
                }
                break
            }
        }
        saveCourses()
        return true
    }
}
