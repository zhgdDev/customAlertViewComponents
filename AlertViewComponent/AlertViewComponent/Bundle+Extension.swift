//
//  Bundle+Extension.swift
//  Mapping
//
//  Created by Dubai on 2019/1/20.
//  Copyright © 2019 hhcu. All rights reserved.
//

import Foundation

extension Bundle
{
    var nameSpace: String
    {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
