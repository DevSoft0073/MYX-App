//
//  TextFields.swift
//  GrownStrong
//
//  Created by Aman on 29/07/21.
//

import Foundation
import UIKit

class DefaultTextField : UITextField{
    
    override func awakeFromNib() {
        //
        self.borderStyle = .none
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        self.textColor = .darkGray
        self.tintColor = AppTheme.defaultBlue
        
    }
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

     override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
     }

     override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
     }

     override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
     }
    
}


class EditProfileTextField : UITextField{
    
    override func awakeFromNib() {
        //
        self.borderStyle = .none
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.colorFromHex("E8E8E8")
        self.textColor = .darkGray
        self.tintColor = AppTheme.defaultBlue
//        self.font = UIFont(name: AppDefaultNames.sansHebrewRegular, size: 15)
        
    }
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

     override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
     }

     override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
     }

     override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
     }
    
}
