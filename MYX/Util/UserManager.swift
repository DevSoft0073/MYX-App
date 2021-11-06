//
//  UserManager.swift
//  GrownStrong
//
//  Created by Aman on 26/07/21.
//

import Foundation
import UIKit

class UserManager: NSObject {

    static var shared: UserManager {
        return UserManager()
    }
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
            UserDefaults.standard.synchronize()
        }
    }
    
    var totalPoints: String? {
        get {
            return UserDefaults.standard.string(forKey: "totalPoints")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "totalPoints")
            UserDefaults.standard.synchronize()
        }
    }
    
    var fullName: String? {
          get {
              return UserDefaults.standard.string(forKey: "fullName")
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "fullName")
              UserDefaults.standard.synchronize()
          }
      }
    
    
  
    
    
  
    
    func setupUserInfoForLogin(data : [String: Any]) {
        self.fullName = data["name"] as? String
        self.userEmailAddress = data["emailAddress"] as? String
        self.isLoggedIn = true
    }
    
    var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: "userId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    var userEmailAddress: String? {
        get {
            return UserDefaults.standard.string(forKey: "userEmailAddress")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userEmailAddress")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }
    
  
    
    
 
    

    
    
    
    func clear() {
        self.token = nil
        self.userId = nil
        self.userEmailAddress = nil
        self.fullName = nil
        self.isLoggedIn = false
        self.totalPoints = nil
        UserDefaults.standard.synchronize()
    }
}
