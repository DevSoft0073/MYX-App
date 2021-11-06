//
//  Alert.swift
//  GrownStrong
//
//  Created by Aman on 26/07/21.
//

import Foundation
import UIKit

func displayALertWithTitles(title : String,message : String,_ buttons:[String], completion:((_ index:Int) -> Void)?) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for index in 0..<buttons.count    {
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion!(index)
            }
        })
        
        alertController.addAction(action)
    }
//    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//        (alert: UIAlertAction!) in
//        if(completion != nil){
//            completion!(0)
//        }
//    })
    
    //alertController.addAction(cancel)
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
}


func displayActionSheetWithTitles(title : String,message : String,_ buttons:[String], completion:((_ index:Int) -> Void)?) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for index in 0..<buttons.count    {
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion!(index)
            }
        })
        
        alertController.addAction(action)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(cancel)
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
}


func displayActionSheetForDelete(title : String,message : String,_ buttons:[String], completion:((_ index:Int) -> Void)?) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for index in 0..<buttons.count    {
        
        let action = UIAlertAction(title: buttons[index], style: .destructive, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion!(index)
            }
        })
        
        alertController.addAction(action)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancel)
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
}
