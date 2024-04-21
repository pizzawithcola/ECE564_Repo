//
//  Triangle.swift
//  Frameworks-Maps-and-stuff
//
//  Created by TA on 3/28/23.
//

import Foundation
import SwiftUI

struct Triangle: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}
