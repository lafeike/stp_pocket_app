//
//  Constant.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-11-24.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import Foundation

struct Constants {
    static let URL_END_POINT = "http://stponline.stpub.com/appmobile/api/" // for release
    //static let URL_END_POINT = "http://10.1.48.195:9001/api/" // for developing environment
    static let SESSION = 7.0  // how many days can the users browse the offline data after their last login.
    static let TITLE = "POCKET REFERENCE"
}

struct StpVariables {
    static var userID: Int?  // login id
    static var states = [String]() // The States list user subscribed
    static var stateSelected: Int = 0 // state that user chosed for displaying state difference.
}

struct StpColor {
    static var Orange = "ED9022"
    static var Purple = "343896"
}
