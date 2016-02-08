//
//  CheckButton.swift
//  StudyOrganizer
//
//  Created by Lara Marie Reimer on 07.02.16.
//  Copyright © 2016 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol CheckButtonClickedDelegate: class {
    func didSelectCheckButton(isChecked: Bool) -> Bool
}

class CheckButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "checked")! as UIImage
    let uncheckedImage = UIImage(named: "unchecked")! as UIImage
    
    weak var delegate: CheckButtonClickedDelegate?
        
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents:UIControlEvents.TouchUpInside)
    }
        
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
        let done = delegate?.didSelectCheckButton(isChecked)
        print(done)
    }
    
    func setState(bool: Bool) {
        if(bool) {
            isChecked = true
        } else {
            isChecked = false
        }
    }

}
