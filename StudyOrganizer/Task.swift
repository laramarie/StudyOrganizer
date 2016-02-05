//
//  Task.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 05.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    var descript: String
    var done: Bool
    
    init(descript: String, done: Bool) {
        self.descript = descript
        self.done = done
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(descript, forKey: ProperKey.descriptionKey)
        aCoder.encodeObject(done, forKey: ProperKey.doneKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let descript = aDecoder.decodeObjectForKey(ProperKey.descriptionKey) as! String
        let done = aDecoder.decodeObjectForKey(ProperKey.doneKey) as! Bool
        
        // Must call designated initializer.
        self.init(descript: descript, done: done)
    }

}


// MARK: Part for NSCoding in Course
struct ProperKey {
    static let descriptionKey = "description"
    static let doneKey = "done"
}