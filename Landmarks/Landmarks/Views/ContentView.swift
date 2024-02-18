//
//  ContentView.swift
//  Landmarks
//
//  Created by Jamie on 2024/2/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
