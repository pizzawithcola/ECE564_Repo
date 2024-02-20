//
//  ColorMultiplyExample.swift
//  Graphics and Animation
//
//  Created by Richard Telford on 2/28/23.
//  Copyright © 2023 Duke Pratt. All rights reserved.
//

import SwiftUI

struct ColorMultiplyExample: View {
    var body: some View {
             HStack {
                   Color.red.frame(width: 100, height: 100, alignment: .center)
                       .overlay(InnerCircleView(), alignment: .center)
                       .overlay(Text("Normal")
                                    .font(.callout),
                                alignment: .bottom)
                       .border(Color.gray)
  
                   Spacer()
  
                   Color.red.frame(width: 100, height: 100, alignment: .center)
                       .overlay(InnerCircleView(), alignment: .center)
                       .colorMultiply(Color.purple)
                       .overlay(Text("Multiply")
                                   .font(.callout),
                                alignment: .bottom)
                       .border(Color.gray)
               }
               .padding(50)
           }
}

struct ColorMultiplyExample_Previews: PreviewProvider {
    static var previews: some View {
        ColorMultiplyExample()
    }
}

struct InnerCircleView: View {
         var body: some View {
             Circle()
                 .fill(Color.green)
                 .frame(width: 40, height: 40, alignment: .center)
         }
     }
