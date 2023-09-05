//
//  ContentView.swift
//  CustomOriginSliderExample
//
//  Created by Dean Thompson on 2023/06/04.
//

import SwiftUI
import CustomOriginSlider

struct ContentView: View {
    
    @State var value: Float = 25
    
    @State var showModal = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Value: \(value)")
                CustomOriginSlider(
                            minValue: -30,
                            maxValue: 75,
                            defaultValue: 50,
                            sliderValue: $value)
                
                CustomOriginSlider(
                            minValue: 0,
                            maxValue: 100,
                            sliderValue: $value)
                
                CustomOriginSlider(
                            minValue: 50,
                            maxValue: 100,
                            sliderValue: $value)
                
                CustomOriginSlider(
                    minValue: -50,
                    maxValue: 50,
                    sliderValue: $value,
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
                 
                Button("Present Modally") {
                    showModal.toggle()
                }.padding(.top, 1)
            }
            .frame(height: 300)
            .padding()
        }
        .sheet(isPresented: $showModal, content: {
            CustomOriginSlider(
                minValue: -100,
                maxValue: 100,
                defaultValue: 10,
                sliderValue: $value
            )
            .presentationDetents([.height(100)])
            .preferredColorScheme(.dark)
            .frame(maxWidth: 300, maxHeight: 80)
        })
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
