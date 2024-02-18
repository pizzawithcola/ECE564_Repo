//
//  test.swift
//  Landmarks
//
//  Created by Jamie on 2024/2/17.
//

import SwiftUI

class TimerData: ObservableObject {
    @Published var time: Int = 0 // 使用@Published包装器创建可观察属性
}

struct test: View {
    @ObservedObject var timerData = TimerData() // 使用@ObservedObject包装器观察TimerData对象
        
    var body: some View {
        VStack {
            Text("Timer: \(timerData.time)")
            Button("Start") {
                timerData.time += 1 // 修改time属性的值会触发视图的重新渲染
            }
        }
    }
}

#Preview {
    test()
}
