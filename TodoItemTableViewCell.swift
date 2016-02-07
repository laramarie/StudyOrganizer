//
//  TodoItemTableViewCell.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 07.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol TodoItemCheckedDelegate: class {
    func didUpdateTodoList(todoName: String) -> Bool
}

class TodoItemTableViewCell: UITableViewCell {

    @IBOutlet weak var todoItemLabel: UILabel!
    @IBOutlet weak var checkButton: CheckButton!
    
    weak var delegate: TodoItemCheckedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.checkButton.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkButtonClicked(sender: CheckButton) {
    }
}

extension TodoItemTableViewCell: CheckButtonClickedDelegate {
    func didSelectCheckButton(isChecked: Bool) -> Bool {
        delegate?.didUpdateTodoList(todoItemLabel.text!)
        return true
    }
}
