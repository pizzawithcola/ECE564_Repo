//
//  Utilities.swift
//  05_PersistentStorage
//
//  Created by Richard Telford on 9/21/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
