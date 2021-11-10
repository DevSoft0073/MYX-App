//
//  FirebaseSetup.swift
//  MYX
//
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
//import FirebaseStorage
import UIKit

class FIRController : NSObject{
    
    func loginUser(_ emailAddress : String!, password : String , completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        UIApplication.topViewController()?.showLoader()
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            
            if error != nil{
                UIApplication.topViewController()?.hideLoader()
                displayALertWithTitles(title: AppDefaultNames.name, message: error?.localizedDescription ?? "", ["Ok"], completion: nil)
            }else{
                let db = Firestore.firestore()
                db.collection("Users").document(result?.user.uid ?? "").getDocument { (snapshot, err) in
                    UIApplication.topViewController()?.hideLoader()
                    if err == nil{
                        if snapshot!.exists{
                            if snapshot != nil{
                                if snapshot!.exists{
                                    let data = snapshot?.data()
                                    print("here is login user data",data as Any)
                                    UserManager.shared.userId = result?.user.uid
                                    UserManager.shared.setupUserInfoForLogin(data: data ?? [:])
                                    completionBlock(result?.user.uid)
                                }
                            }
                        }
                    }else{
                        print("need to verify account")
                        displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
                    }
                }
            }
            
        }
        
    }
    
    
    func createAndSaveUser(name: String, emailAddress: String ,password: String, completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        UIApplication.topViewController()?.showLoader()

        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if error != nil{
                UIApplication.topViewController()?.hideLoader()
                displayALertWithTitles(title: AppDefaultNames.name, message: error?.localizedDescription ?? "" , ["Ok"], completion: nil)
            }else{
                self.saveInfoInFirestore(nameUSer: name, emailAddress: emailAddress, currentUserID: result?.user.uid ?? "") { (uidd) in
                    UIApplication.topViewController()?.hideLoader()

                    completionBlock(uidd)
                }
        }
            }
        }
    
    
    
    func saveInfoInFirestore(nameUSer: String,emailAddress: String,  currentUserID : String,completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        self.addUserInfoOnFireStore(name: nameUSer, email: emailAddress, uid: currentUserID) { (uid) in
            completionBlock(uid)
        }
    
}

   
    
    func addUserInfoOnFireStore(name:String,email:String,uid: String, completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        
        let db = Firestore.firestore()
        
        let userData = ["name":name,"emailAddress":email,"TimeStamp":Timestamp(),"UserID":uid] as [String : Any]
        db.collection("Users").document(uid).setData(userData as [String : Any], merge: false) { (err) in
            UIApplication.topViewController()?.hideLoader()
            if err == nil{
                UserManager.shared.isLoggedIn = true
                let user = UserManager.shared
                user.userId = uid
                user.fullName = name
                user.userEmailAddress = email
                completionBlock(uid)
            }else{
                UIApplication.topViewController()?.hideLoader()

                displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
            }
        }
        
    }
    
    
    func checkIsUSerAddGameFirstTime(completionBlock : @escaping ((_ msg : Bool) -> Void)){
        let db = Firestore.firestore()
        
        db.collection("Objectives").document(UserManager.shared.userId!).getDocument { (snapshot, err) in
            if err == nil{
                if snapshot!.data() == nil{
                    completionBlock(true)
                }else{
                    let data = snapshot?.data()
                    Singleton.shared.mondayTimeStamp = (data?["MondayTimeStamp"] as? Timestamp)!
                    completionBlock(false)
                }
            }
           
        }
    }
    

    func addGameInUserSection(isFirstTime:Bool,gameText : String, completionBlock : @escaping ((_ msg : String?) -> Void)){
        
        let db = Firestore.firestore()
        UIApplication.topViewController()?.showLoader()
        let data = ["TimeStamp":Timestamp(),"Objective": gameText] as [String : Any]
        db.collection("Objectives").document(UserManager.shared.userId!).collection("Data").addDocument(data: data) { (err) in
            UIApplication.topViewController()?.hideLoader()
            if err == nil{
                if isFirstTime{
                    self.updateTimeStamp { (msg) in
                        completionBlock(msg)
                    }
                }else{
                    let isMondayTOday = Bool().isMondayToday()
                    if isMondayTOday{
                        self.updateTimeStamp { (msg) in
                            completionBlock(msg)
                        }
                    }else{
                        completionBlock("done")
                    }
                }
            }
        }
    }
    
    
    func updateTimeStamp(completionBlock : @escaping ((_ msg : String?) -> Void)){
        let db = Firestore.firestore()
        
        db.collection("Objectives").document(UserManager.shared.userId!).setData(["MondayTimeStamp": Timestamp(date: Date().startOfWeek)]) { (err) in
            if err == nil{
                completionBlock("done")
            }
        }
    }
    
    
    
    func fetchCurrentWeekGames( completionBlock : @escaping ((_ data : [GameModel]) -> Void)){
        var model : [GameModel] = []
        let db = Firestore.firestore()
        print("start week date",Timestamp(date: Date().startOfWeek()).dateValue())
        db.collection("Objectives").document(UserManager.shared.userId!).collection("Data").whereField("TimeStamp", isGreaterThanOrEqualTo: Timestamp(date: Date().startOfWeek())).order(by: "TimeStamp", descending: true).addSnapshotListener { (snapshot, err) in
            if err == nil{
                model.removeAll()
                for data in snapshot!.documents{
                    model.append(GameModel(dataDict: data.data(),gameid: data.documentID))
                }
                completionBlock(model)
            }
        }
        
        
    }
    
    func getLastWeekAverage( completionBlock : @escaping ((_ msg : String?) -> Void)){
        let db = Firestore.firestore().collection("Objectives")
        db.document(UserManager.shared.userId!).getDocument { (snapshot, err) in
            if err == nil{
                if let savedMonDate = snapshot!.data()?["MondayTimeStamp"] as? Timestamp{
                    let currentWeekModayDate = Date().getWeekDates()
                    let thisMon = Timestamp(date: currentWeekModayDate.thisWeek.first!)
                    print("thisMon date",thisMon.dateValue())
                    print("saved monday date ",savedMonDate.dateValue())
//                    let savedDate = "\(Date().getCurrentMonth())-\(Date().getCurrenYear())"

                    
                    db.document(UserManager.shared.userId!).collection("Data").whereField("TimeStamp", isLessThan: thisMon).limit(to: 7).getDocuments { (snapData, err) in
                        if err == nil{
                            var totalPointFromLastWeek = 0
                            for data in snapData!.documents{
                                let model = GameModel(dataDict: data.data(), gameid: data.documentID)
                                totalPointFromLastWeek += Int(model.points) ?? 0
                            }
                            completionBlock("\(totalPointFromLastWeek)")
                        }
                    }
                    
                }
            }
        }
    }
    
    
    func updatePointInGame(data : GameModel, completionBlock : @escaping ((_ msg : String?) -> Void)){
        if data.points == ""{
            data.points = "0"
        }
        var pointInt = Int(data.points) ?? 0
        pointInt += 1
        let db = Firestore.firestore()
//        let savedDate = "\(Date().getCurrentMonth())-\(Date().getCurrenYear())"

        db.collection("Objectives").document(UserManager.shared.userId!).collection("Data").document(data.gameID).updateData(["Points":"\(pointInt)"]) { (err) in
            if err == nil{
                completionBlock("added")
            }
        }
    }
   
    
    func deleteGame(data : GameModel, completionBlock : @escaping ((_ msg : String?) -> Void)){
        let db = Firestore.firestore()

        db.collection("Objectives").document(UserManager.shared.userId!).collection("Data").document(data.gameID).delete { (err) in
            if err == nil{
                completionBlock("done")
            }
        }
    }
   
    
   
    
    
    func fetchLimitedData( startDateFrom : Timestamp,completionBlock : @escaping ((_ data : [WeekData]) -> Void)){
        let db = Firestore.firestore().collection("Objectives").document(UserManager.shared.userId!).collection("Data")
        UIApplication.topViewController()?.showLoader()
        var weekWiseModelData : [WeekData] = [WeekData]()
        let query = db.order(by: "TimeStamp").whereField("TimeStamp", isGreaterThanOrEqualTo: startDateFrom)
//        query.getDocuments(completion: )
        query.getDocuments { (snapshot, err) in
            if err == nil{

                for data in snapshot!.documents{
                    weekWiseModelData.append(WeekData(dataDict: data.data()))
                }
                UIApplication.topViewController()?.hideLoader()
                print("total number of gamed in limites",weekWiseModelData.count)

                completionBlock(weekWiseModelData)
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    
    func getWeeksDataForChart( weekNDate : String,completionBlock : @escaping ((_ data : [WeekData]) -> Void)){
        
        
        let db = Firestore.firestore().collection("Objectives").document(UserManager.shared.userId!).collection("Data")
            var weekWiseModelData : [WeekData] = [WeekData]()
            weekWiseModelData.removeAll()
                
        db.order(by: "TimeStamp").getDocuments { (snapshot, err) in
            if err == nil{
                for data in snapshot!.documents{
                    weekWiseModelData.append(WeekData(dataDict: data.data()))
                }
                print("total number of games",weekWiseModelData.count)
                completionBlock(weekWiseModelData)
            }
        }
        
        
        
    }
    
    
    func logout(){
        DispatchQueue.main.async {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UserManager.shared.clear()
            }
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "LaunchViewController") as? LaunchViewController
            let nav = UINavigationController(rootViewController: vc!)
            nav.navigationBar.isHidden = true
            appDelegate().window?.rootViewController = nav
        }
    }
}


