//
//  Image.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import Foundation
import UIKit

class ProfileImageView:UIImageView{
    override  func awakeFromNib() {
        self.layer.cornerRadius = (self.frame.size.width) / 2
        self.clipsToBounds = true
    }
}
