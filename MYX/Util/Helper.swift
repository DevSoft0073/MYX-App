//
//  Helper.swift
//  MYX
//
//  Created by Aman on 08/10/21.
//

import Foundation
import UIKit
import MBProgressHUD

@IBDesignable
extension UIView {
    // Corner radius
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    // Border width
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // Border color
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    // Shadow radius
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    // Shadow opactity
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    // Shadow offset
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    // Shadow color
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func setLayer(){
        self.layer.cornerRadius = 7
           self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
           self.layer.borderWidth = 0.7
           self.clipsToBounds = true
    }
    
    func fadeIn(duration: TimeInterval = 2, delay: TimeInterval = 4, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 2, delay: TimeInterval = 3, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
    
}
extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = self.cornerRadius
        gradient.colors = colours.map { $0.cgColor }
        if let loc = locations {
            gradient.locations = loc
        } else {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        if let subLayers = self.layer.sublayers {
            for sublayer in  subLayers {
                if sublayer.isKind(of: CAGradientLayer.self) {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    @discardableResult
     func applyGradientTopLeftToBottonRight(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
         let gradient: CAGradientLayer = CAGradientLayer()
         gradient.frame = self.bounds
         gradient.cornerRadius = self.cornerRadius
         gradient.colors = colours.map { $0.cgColor }
         if let loc = locations {
             gradient.locations = loc
         } else {
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
         }
         
         if let subLayers = self.layer.sublayers {
             for sublayer in  subLayers {
                 if sublayer.isKind(of: CAGradientLayer.self) {
                     sublayer.removeFromSuperlayer()
                 }
             }
         }
         
         self.layer.insertSublayer(gradient, at: 0)
         return gradient
     }
    
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
         
         var viewsDictionary = [String: UIView]()
         
         for (index, view) in views.enumerated() {
             let key = "v\(index)"
             view.translatesAutoresizingMaskIntoConstraints = false
             viewsDictionary[key] = view
         }
         
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
         
     }
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
    
}

extension UIButton {
    func addWhiteShadow(){
//        self.backgroundColor =
//        self.layer.borderWidth = 2.0;/
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 3);

    }
}


extension UIColor {
    
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static func colorFromHex(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            
            return UIColor.magenta
        }
        
        var rgb: UInt32 = 0
        Scanner.init(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255,
                            green: CGFloat((rgb & 0x00FF00) >> 8)/255,
                            blue: CGFloat(rgb & 0x0000FF)/255,
                            alpha: 1.0)
    }
    
}


extension UIApplication {
    
    class func topViewController(base: UIViewController? = appDelegate().window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
extension UIViewController {
    
    
    func showLoader() {
        
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.animationType = .zoomOut
        Indicator.isUserInteractionEnabled = false
        Indicator.show(animated: true)
        self.view.isUserInteractionEnabled = false
    }
    
    
    
    func hideLoader() {
        self.view.isUserInteractionEnabled = true
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
extension String{
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension UIButton{
    func setAttributedText(startingText: String, textColor: UIColor, font: UIFont, lastText: String, secondaryTextColor: UIColor, secondaryFont: UIFont) {
        
        let completeString = "\(startingText) \(lastText)"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let completeAttributedString = NSMutableAttributedString(
            string: completeString, attributes: [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        let secondStringAttribute: [NSAttributedString.Key: Any] = [
            .font: secondaryFont,
            .foregroundColor: secondaryTextColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let range = (completeString as NSString).range(of: lastText)
        
        completeAttributedString.addAttributes(secondStringAttribute, range: range)
        
        self.setAttributedTitle(completeAttributedString, for: .normal)
    }
}




class AppTheme {
    static let defaultYellow = UIColor.colorFromHex("FFDF01")
    static let defaultBlue = UIColor.colorFromHex("286DAA")
    static let darkBlue = UIColor.colorFromHex("0B1043")
}


class AppDefaultNames {
    static let name = "MYX"
    static let sansFontNameBold = "OpenSans-Bold"
    static let sansFontNameRegular = "OpenSans-Regular"
    static let sansHebrewBold = "OpenSansHebrew-Bold"
    static let sansHebrewRegular = "OpenSansHebrew-Regular"
    static let SFProRegular = "SFProDisplay-Regular"
    static let bisonFont = "Bison-Bold"
    
    static let FortyEightHrsID = "48Hours"
    static let fiveDaysID = "5Days"
    static let firstTimeNotificaitonID = "firstTime"
    static let everyMondayNotificaitonID = "erveyMonday"
    static let everySundayNotificaitonID = "erveySunday"

}

class DefaultsNotificationContent {
    static let fiveDaysMsg = "The world revolves around desirable ideas if you think you don't want them, great"
    static let fortyHrsMsg = "Don't forgot to include recent points. Life is not stopping, will you?"
    static let everyMondayMsg = "New week, new games, new challenges"
    static let everySundayMsg = "This Week you scored \(UserManager.shared.totalPoints ?? "great") points."
    static let firstTimeMsg = "One day you will look back and say: Yes, I did it! Your life game starts now"
}

extension Bool{
    func isMondayToday() -> Bool{
        let CurrentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone() as TimeZone
        dateFormatter.dateFormat = "ccc"

        let Monday = dateFormatter.string(from: CurrentDate as Date)
        let isMonday = "Mon"
        if Monday == isMonday {
           print("It's Monday")
            return true
        }
        else {
            let otherDay = dateFormatter.string(from: CurrentDate as Date)
           print(otherDay)
            return false
        }
    }
    
    func ifTimeStampMoreThan7Days(from interval : TimeInterval) -> Bool
    {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
        let day = components.day!
        if abs(day) < 2 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return false
        } else if day > 1 || day < 6{
            return false
        } else {
            return true
        }
    }
    
}


extension UILabel{

public var requiredHeight: CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.attributedText = attributedText
    label.sizeToFit()
    return label.frame.height
  }
}


extension UIView{
    func addShadow(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset =  CGSize.zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4

    }
    func addLightShadow(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset =  CGSize.zero
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2

    }
    
    func makeCircle(){
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true

    }
}


extension Date {

    func getWeekDates() -> (thisWeek:[Date],nextWeek:[Date]) {
        var tuple: (thisWeek:[Date],nextWeek:[Date])
        var arrThisWeek: [Date] = []
        for i in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        var arrNextWeek: [Date] = []
        for i in 1...7 {
            arrNextWeek.append(Calendar.current.date(byAdding: .day, value: i, to: arrThisWeek.last!)!)
        }
        tuple = (thisWeek: arrThisWeek,nextWeek: arrNextWeek)
        return tuple
    }



    
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
    }

    func toDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func getCurrenYear () -> Int{
        return Calendar.current.component(.year, from: Date())
    }
    
    func getCurrentMonth () -> Int{
        return Calendar.current.component(.month, from: Date())
        
    }
    func monthAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMMM")
            return df.string(from: self)
    }

    
}

extension UIColor {
    static var random: UIColor {
//        let colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]

        return UIColor().randomColor()!
 
    }
    
    func randomColor() -> UIColor? {
        while (1 != 0) {
            let red = CGFloat(arc4random()) / CGFloat(RAND_MAX)
            let blue = CGFloat(arc4random()) / CGFloat(RAND_MAX)
            let green = CGFloat(arc4random()) / CGFloat(RAND_MAX)
            let gray = 0.299 * red + 0.587 * green + 0.114 * blue
            if gray < 0.6 {
                return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            }
        }
    }
}


extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

//        let calendar = Calendar(identifier: .gregorian)
//        let components = calendar.dateComponents([.year, .month], from: self)
//
//        return  calendar.date(from: components)!
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!

        
        
    }
    
//    func getFirstAndLastDateOfMonth(date: NSDate) -> (fistDateOfMonth: NSDate, lastDateOfMonth: NSDate) {
//
//        let date = NSDate()
//        let calendar = NSCalendar.current
//        let dateComponents = calendar.components([NSCalendar.Unit.month, NSCalendar.Unit.year], fromDate: date)
//        let firstDay = self.returnDateForMonth(dateComponents.month, year: dateComponents.year, day: 1)
//
//    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    func numberOfWeeksInMonth(_ date: Date) -> Int {
         var calendar = Calendar(identifier: .gregorian)
         calendar.firstWeekday = 1
         let weekRange = calendar.range(of: .weekOfMonth,
                                        in: .month,
                                        for: date)
         return weekRange!.count
    }
}



extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}

extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
}


extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}
