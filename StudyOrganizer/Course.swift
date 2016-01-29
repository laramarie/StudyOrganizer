//
//  Course.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 25.01.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import Foundation
import UIKit

class Course: NSObject, NSCoding {
    var name: String
    var ECTS: Int
    var grade: Double
    var done: Bool
    var todo: [String]
    var exam: NSDate
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("course")
    
    init?(name: String, ECTS: Int, grade: Double, done: Bool, todo: [String], exam: NSDate){
        self.name = name
        self.ECTS = ECTS
        self.grade = grade
        self.done = done
        self.todo = todo
        self.exam = exam
        
        super.init()
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropKey.nameKey)
        aCoder.encodeObject(ECTS, forKey: PropKey.ECTSKey)
        aCoder.encodeObject(grade, forKey: PropKey.gradeKey)
        aCoder.encodeObject(done, forKey: PropKey.doneKey)
        aCoder.encodeObject(todo, forKey: PropKey.todoKey)
        aCoder.encodeObject(exam, forKey: PropKey.examKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropKey.nameKey) as! String
        let ECTS = aDecoder.decodeObjectForKey(PropKey.ECTSKey) as! Int
        let grade = aDecoder.decodeObjectForKey(PropKey.gradeKey) as! Double
        let done = aDecoder.decodeObjectForKey(PropKey.doneKey) as! Bool
        let todo = aDecoder.decodeObjectForKey(PropKey.todoKey) as! [String]
        let exam = aDecoder.decodeObjectForKey(PropKey.examKey) as? NSDate
        
        // Must call designated initilizer.
        self.init(name: name, ECTS: ECTS, grade: grade, done: done, todo: todo, exam: exam!)
    }
}

struct PropKey {
    static let nameKey = "name"
    static let ECTSKey = "ECTS"
    static let gradeKey = "grade"
    static let doneKey = "done"
    static let todoKey = "todo"
    static let examKey = "exam"
}