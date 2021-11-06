//
//  AddGameViewController.swift
//  MYX
//
//  Created by Aman on 10/10/21.
//

import UIKit

class AddGameViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtView: UITextView!
    
    
    let placeHolderText = "Enter Objective"
    let firebaseControllerHandle  : FIRController = FIRController()
    var isFirst = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.text = placeHolderText
        txtView.textColor = UIColor.lightGray
        txtView.delegate = self
        txtView.selectedTextRange = txtView.textRange(from: txtView.beginningOfDocument, to: txtView.beginningOfDocument)
        txtView.isScrollEnabled = true
        self.checkIsFirstTimeGame()
    }
    
    override func viewDidLayoutSubviews() {
        self.backView.roundCorners([.topLeft,.topRight], radius: 40)
        self.txtView.layer.borderColor = UIColor.colorFromHex("F3F3F3").cgColor
        self.txtView.backgroundColor = UIColor.colorFromHex("F3F3F3")
    }


    func checkIsFirstTimeGame(){
        firebaseControllerHandle.checkIsUSerAddGameFirstTime { (isFirstTime) in
            print(isFirstTime)
            self.isFirst = isFirstTime
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {

            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
        else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.textColor = .lightGray
            textView.text = placeHolderText
        }
    }
   
    
    func addLocalNotification(){
        let date = Calendar.current.date(byAdding: .hour, value: 48, to: Date())
        appDelegate().scheduleNotification(at: date!, identifierUnic: AppDefaultNames.FortyEightHrsID, body: DefaultsNotificationContent.fortyHrsMsg, titles: "No points recently 🙁")
        
        let fiveDaysAfter =  Calendar.current.date(byAdding: .day, value: 5, to: Date())
        appDelegate().scheduleNotification(at: fiveDaysAfter!, identifierUnic: AppDefaultNames.fiveDaysID, body: DefaultsNotificationContent.fiveDaysMsg, titles: "Game Over?")
    }
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        if txtView.text.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please add your Game/Objective ", ["Ok"], completion: nil)
        }else{
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [AppDefaultNames.FortyEightHrsID,AppDefaultNames.fiveDaysID])

            firebaseControllerHandle.addGameInUserSection(isFirstTime: self.isFirst, gameText: txtView.text ?? "") { (msg) in
                print("game",msg ?? "")
                self.txtView.textColor = .lightGray
                self.txtView.text = self.placeHolderText
                self.txtView.resignFirstResponder()
                displayALertWithTitles(title: AppDefaultNames.name, message: "Your Game/Objective added", ["Ok"], completion: nil)
                self.addLocalNotification()
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
