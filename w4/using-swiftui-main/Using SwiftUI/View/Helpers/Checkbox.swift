//
//  Checkbox.swift
//  ToDo
//
//  Created by Anshu Dwibhashi on 6/2/22.
//

import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool
    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 25, height: 25, alignment: .center)
            .foregroundColor(isChecked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                isChecked.toggle()
            }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox(isChecked: .constant(true))
    }
}
