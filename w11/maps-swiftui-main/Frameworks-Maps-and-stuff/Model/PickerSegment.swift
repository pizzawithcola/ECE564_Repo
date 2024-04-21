//
//  PickerSegment.swift
//  Frameworks-Maps-and-stuff
//
//  Created by TA on 3/14/23.
//

import Foundation

/*
 Conforms to String protocol so that we can access the .rawValue property
 Conforms to CaseIterable so that we can access PickerSegment.allCases
 */
enum PickerSegment: String, CaseIterable, Equatable{
    case De
    case Gr
    case B1
    case B2
    case BM
    case RT
    case RA
    case AP
}


