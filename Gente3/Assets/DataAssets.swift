//
//  DataAssets.swift
//  Gente3
//
//  Created by Song, InKyung on 9/1/18.
//  Copyright © 2018 IKSong. All rights reserved.
//

import Foundation
import UIKit

class DataAssets {
    static func loadDataAsset(name: String) -> Data? {
        return NSDataAsset(name: name)?.data        
    }
}

/* how to use
 WebService().loadFromDataAssets(resource: User.resourceForAllUsers()!) { result in
 print(result)
 }
*/
