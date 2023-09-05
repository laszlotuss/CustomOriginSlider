//
//  ContentView.swift
//  CustomOriginSliderExample
//
//  Created by Dean Thompson on 2023/06/04.
//

import SwiftUI
import CustomOriginSlider

struct ContentView: View {
    
    @State var value1: Float = 0
    @State var value2: Float = 0
    @State var value3: Float = 60
    @State var value4: Float = 20
    
    var body: some View {
        ZStack {
            VStack {
                Text("Value1: \(value1)")
                CustomOriginSlider(
                            minValue: -30,
                            maxValue: 50,
                            sliderValue: $value1
                        )
                
                Text("Value2: \(value2)")
                CustomOriginSlider(
                            minValue: 0,
                            maxValue: 100,
                            sliderValue: $value2)
                
                Text("Value3: \(value3)")
                CustomOriginSlider(
                            minValue: 50,
                            maxValue: 100,
                            sliderValue: $value3)
                
                Text("Value4: \(value4)")
                CustomOriginSlider(
                    minValue: -50,
                    maxValue: 50,
                    sliderValue: $value4,
                    thumbSize: 24,
                    thumbColor: .red,
                    guideBarCornerRadius: 4,
                    guideBarColor: .blue.opacity(0.2),
                    guideBarHeight: 6,
                    trackingBarColor: .blue,
                    trackingBarHeight: 6,
                    shadow: 2,
                    shadowColor: .gray,
                    backgroundColor: .clear
                )
                        
            }
            .frame(height: 300)
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
