//
//  HornView.swift
//  Using SwiftUI
//
//  Created by Ric Telford on 2/12/24.
//

import SwiftUI

struct HornButton: View  {
  @Binding var hornPlayedCount: Int

  var body: some View {
      Button("\(hornPlayedCount) times") {
      hornPlayedCount += 1
      }
  }
}

struct CarView: View  {
  @State private var hornCount: Int = 0

  var body: some View {
      Text("Your car has honked: \(hornCount)")
      HornButton(hornPlayedCount: $hornCount)
  }
}

#Preview {
    CarView()
    
}
