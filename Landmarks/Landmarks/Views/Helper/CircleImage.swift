//
//  CircleImage.swift
//  Landmarks
//
//  Created by Jamie on 2024/2/15.
//

import SwiftUI

struct CircleImage: View{
    var image: Image
    
    var body: some View{
        image
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage(image: Image("turtlerock"))
}
