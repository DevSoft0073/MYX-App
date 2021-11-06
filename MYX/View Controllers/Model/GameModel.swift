//
//  GameModel.swift
//  MYX
//
//  Created by Aman on 10/10/21.
//

import Foundation
import FirebaseFirestore

class GameModel : NSObject{
 
    var name = ""
    var timeStamp = Timestamp()
    var points = "0"
    var gameID = ""
    
    init(dataDict : [String : Any],gameid : String){
        self.name = dataDict["Objective"] as? String ?? ""
        self.timeStamp = (dataDict["TimeStamp"] as? Timestamp)!
        self.points = dataDict["Points"] as? String ?? "0"
        self.gameID = gameid
    }
    
    
}

class OverAllWeekData : NSObject{
    var weekData : [WeekData] = [WeekData]()
    var week = ""
    init(_ data : [WeekData],weekCount : String){
        self.weekData = data
        self.week = weekCount
    }
}

class WeekData : NSObject{
    var name = ""
    var timeStamp = Timestamp()
    var points = "0"
    
    init(dataDict : [String : Any]){
        self.name = dataDict["Objective"] as? String ?? ""
        self.timeStamp = (dataDict["TimeStamp"] as? Timestamp)!
        self.points = dataDict["Points"] as? String ?? "0"
    }
    
}

