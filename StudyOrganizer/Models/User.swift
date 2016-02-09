//
//  User.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 22.01.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject, NSCoding {
    var name: String
    var university: String
    var fieldOfStudies: String
    var image: UIImage?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("user")
    
    init?(name: String, university: String, fieldOfStudies: String, image: UIImage) {
        self.name = name
        self.university = university
        self.fieldOfStudies = fieldOfStudies
        self.image = image
        
        super.init()
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(university, forKey: PropertyKey.universityKey)
        aCoder.encodeObject(fieldOfStudies, forKey: PropertyKey.fieldKey)
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let university = aDecoder.decodeObjectForKey(PropertyKey.universityKey) as! String
        let fieldOfStudies = aDecoder.decodeObjectForKey(PropertyKey.fieldKey) as! String
        let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as? UIImage
        
        // Must call designated initilizer.
        self.init(name: name, university: university, fieldOfStudies: fieldOfStudies, image: image!)
    }
}

struct PropertyKey {
    static let nameKey = "name"
    static let universityKey = "university"
    static let fieldKey = "field"
    static let imageKey = "image"
}