//
//  Extensions.swift
//  CalendarTask
//
//  Created by 현은백 on 2022/02/15.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach{
            addSubview($0)
        }
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

extension UIColor {
    static func random() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

extension UIFont {
    enum Bold {
        case _14
        case _10
        
        var font: UIFont {
            switch self {
            case ._10: return UIFont.boldSystemFont(ofSize: 10)
            case ._14: return UIFont.boldSystemFont(ofSize: 10)
            }
        }
    }
    
    enum Regular {
        
    }
}
