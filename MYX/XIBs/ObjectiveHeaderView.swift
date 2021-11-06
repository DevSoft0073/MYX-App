//
//  ObjectiveHeaderView.swift
//  MYX
//
//  Created by Aman on 10/10/21.
//

import UIKit

class ObjectiveHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var WeekLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        self.deleteBtn.tintColor = .red
        
    }

}
