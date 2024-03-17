//
//  AppVersion.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/16.
//

import Foundation

public typealias AppVersion = [Int]

extension AppVersion {
    
    
    var major: Int {
        return self[0]
    }
    
    var minor: Int {
        return self[1]
    }
    
    var patch: Int {
        return self[2]
    }
    
    
    public static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return (lhs.major == rhs.major) &&
        (lhs.minor == rhs.minor) &&
        (lhs.patch == rhs.patch)
    }
    
    public static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major > rhs.major { return false }
        if lhs.minor > rhs.minor { return false }
        if lhs.patch > rhs.patch { return false }
        if lhs == rhs { return false}
        return true
    }
    
    public static func != (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return !(lhs == rhs)
    }
    
    public static func > (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return !(lhs < rhs) && !(lhs == rhs)
    }
    
    public static func <= (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return (lhs < rhs) || (lhs == rhs)
    }
    
    public static func >= (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return (lhs > rhs) || (lhs == rhs)
    }
    
    
}
