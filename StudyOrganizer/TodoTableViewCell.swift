//
//  TodoTableViewCell.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 07.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol ItemCheckedDelegate: class {
    func updateTodoList(todoName: String) -> Bool
}

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoItemLabel: UILabel!
    @IBOutlet weak var checkButton: CheckButton!
    
    weak var delegate: ItemCheckedDelegate?
    
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

extension TodoTableViewCell: CheckButtonClickedDelegate {
    func didSelectCheckButton(isChecked: Bool) -> Bool {
        delegate?.updateTodoList(todoItemLabel.text!)
        return true
    }
}
