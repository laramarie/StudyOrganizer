//
//  TodoItemTableViewCell.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 07.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol TodoItemCheckedDelegate: class {
    func didUpdateTodoList(todoName: String, courseName: String) -> Bool
}

class TodoItemTableViewCell: UITableViewCell {

    @IBOutlet weak var todoItemLabel: UILabel!
    @IBOutlet weak var checkButton: CheckButton!
    
    // being passed by table view instantiation as ID for course
    var courseName = ""
    
    weak var delegate: TodoItemCheckedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.checkButton.delegate = self
    }
}

extension TodoItemTableViewCell: CheckButtonClickedDelegate {
    func didSelectCheckButton(isChecked: Bool) -> Bool {
        delegate?.didUpdateTodoList(todoItemLabel.text!, courseName: courseName)
        return true
    }
}
