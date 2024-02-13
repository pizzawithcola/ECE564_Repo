//
//  ContractView.swift
//  Using SwiftUI 2
//
//  Created by Ric Telford on 2/12/24.
//

import SwiftUI

struct AgreementView: View {
  @Binding var isAgreement: Bool

  var body: some View {
      Image(systemName: isAgreement ? "checkmark.square" : "square")
  }
}

struct ContractView: View {
  @State private var isAgreement = true
  @State private var firstName = ""

  var body: some View {
      VStack {
          TextField("Enter your name", text: $firstName)
          Text(firstName)
          Toggle(isOn: $isAgreement) {
          Text("Agree to ...")
          }
          AgreementView(isAgreement: $isAgreement)
      }
  }
}
#Preview {
    ContractView()
}
