//
//  Ab4Error.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 05/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import Foundation
import SwiftyJSON

class Ab4Error {
    var message: String
    var code: String
    
    init(with json: JSON) {
        message = json["message"].string ?? "No message"
        code = json["code"].string ?? "noCode"
    }
    
}
