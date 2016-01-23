//
//  User.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 22.01.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import Foundation
import UIKit

class User {
    var name: String
    var university: String
    var fieldOfStudies: String
    var image: UIImage?
    
    init(name: String, university: String, fieldOfStudies: String, image: UIImage){
        self.name = name
        self.university = university
        self.fieldOfStudies = fieldOfStudies
        self.image = image
    }
    
    init() {
        name = "Your name"
        university = "Your university"
        fieldOfStudies = "Your field of studies"
        image = UIImage(named: "defaultImage")
    }
}