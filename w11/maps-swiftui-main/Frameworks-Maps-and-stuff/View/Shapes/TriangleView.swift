//
//  TriangleView.swift
//  Frameworks-Maps-and-stuff
//
//  Created by TA on 3/28/23.
//

import SwiftUI

struct TriangleView: View {
    var body: some View {
        Triangle()
            .foregroundColor(.red.opacity(0.3))
            .frame(width: 200, height: 200)
    }
}

struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleView()
    }
}
