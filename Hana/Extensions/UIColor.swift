//
//  UIColor.swift
//  Hana
//
//  Created by ccsuser02 on 2018/07/19.
//

import Foundation
import UIKit

extension UIColor {
    
    class func hex(_ hex: String, alpha: CGFloat = 1) -> UIColor {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    class func rgb(_ r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }   
}
