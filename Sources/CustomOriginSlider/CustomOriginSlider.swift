// MIT License
//
// Copyright (c) 2023 Dean Thompson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/// `CenterOriginSlider` is a custom SwiftUI view that represents a slider. The slider's thumb can be moved horizontally
/// to select a value within a range. The slider's appearance and behavior can be customized with several options.
///
import SwiftUI

public struct CustomOriginSlider: View {

    /// The minimum value the slider can take.
    public let minValue: Float

    /// The maximum value the slider can take.
    public let maxValue: Float
    
    /// The default value where the slider center is. If not set, its 0 or the closest value inside the min/max range
    public let defaultValue: Float

    /// The increment by which the value should change. If this is nil, the value changes continuously.
    public let increment: Float?

    /// A binding to a variable that holds the current slider value.
    @Binding public var sliderValue: Float

    /// The size of the slider's thumb.
    public let thumbSize: CGFloat

    /// The color of the slider's thumb.
    public let thumbColor: Color

    /// The corner radius of the slider's guide bar.
    public let guideBarCornerRadius: CGFloat

    /// The color of the slider's guide bar.
    public let guideBarColor: Color

    /// The height of the slider's guide bar.
    public let guideBarHeight: CGFloat

    /// The color of the slider's tracking bar.
    public let trackingBarColor: Color

    /// The height of the slider's tracking bar.
    public let trackingBarHeight: CGFloat

    /// The shadow radius of the slider's thumb.
    public let shadow: CGFloat
    
    /// The shadow radius' color.
    public let shadowColor: Color
    
    /// The background color of the whole View.
    public let backgroundColor: Color
    
    /// Left right padding for the slider
    public let sidePadding: CGFloat = 16
    
    /// Adjust **sliderValue** if outside of min/max region
    public let adjustSliderValueIfNeeded: Bool = false
    
    // MARK: -
    
    @State private var offsetX: CGFloat = .nan
    
    // MARK: -
    
    public init(
        minValue: Float,
        maxValue: Float,
        defaultValue: Float = 0,
        increment: Float? = nil,
        sliderValue: Binding<Float>,
        thumbSize: CGFloat = 16,
        thumbColor: Color = .white,
        guideBarCornerRadius: CGFloat = 2,
        guideBarColor: Color = .white.opacity(0.15),
        guideBarHeight: CGFloat = 4,
        trackingBarColor: Color = .white,
        trackingBarHeight: CGFloat = 4,
        shadow: CGFloat = 0,
        shadowColor: Color = .clear,
        backgroundColor: Color = .clear
    ) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.increment = increment
        self._sliderValue = sliderValue
        self.thumbSize = thumbSize
        self.thumbColor = thumbColor
        self.guideBarCornerRadius = guideBarCornerRadius
        self.guideBarColor = guideBarColor
        self.guideBarHeight = guideBarHeight
        self.trackingBarColor = trackingBarColor
        self.trackingBarHeight = trackingBarHeight
        self.shadow = shadow
        self.shadowColor = shadowColor
        self.backgroundColor = backgroundColor
        self.defaultValue = min(max(defaultValue, minValue), maxValue)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let sliderWidth = max(geometry.size.width - (sidePadding * 2), 0)
            let dragGesture = DragGesture()
                .onChanged({ value in
                    let dragX = value.location.x - geometry.frame(in: .local).minX
                    let dragValue = Float(dragX / sliderWidth) * (maxValue - minValue) + minValue

                    sliderValue = min(max(dragValue, minValue), maxValue)
                })
            let restrictedSliderValue = max(min(sliderValue, maxValue), minValue)
            let sliderX = CGFloat((restrictedSliderValue - minValue) / (maxValue - minValue)) * sliderWidth
            let defaultX = CGFloat((defaultValue - minValue) / (maxValue - minValue)) * sliderWidth
            
            VStack(alignment: .center) {
                ZStack(alignment: .leading) {
                    
                    RoundedRectangle(cornerRadius: guideBarCornerRadius)
                        .frame(width: sliderWidth, height: guideBarHeight)
                        .foregroundColor(guideBarColor)
                    
                    let width = sliderX - defaultX
                    if width.isFinite, !width.isZero {
                        HStack {
                            Spacer().frame(width: abs(width < 0 ? defaultX + width : defaultX))
                            Rectangle()
                                .frame(width: abs(width), height: guideBarHeight)
                                .foregroundColor(trackingBarColor)
                        }
                    }
                    
                    if sliderWidth > 0 {
                        let offsetX = offsetX.isNaN ? sliderX : offsetX
                        Circle()
                            .frame(width: thumbSize, height: thumbSize)
                            .foregroundColor(thumbColor)
                            .offset(x: offsetX)
                            .shadow(color: shadowColor, radius: shadow)
                            .gesture(dragGesture)
                            .onChange(of: sliderValue) { value in
                                let restrictedSliderValue = max(min(value, maxValue), minValue)
                                if adjustSliderValueIfNeeded, value != restrictedSliderValue {
                                    sliderValue = restrictedSliderValue
                                } else {
                                    self.offsetX = CGFloat((restrictedSliderValue - minValue) / (maxValue - minValue)) * sliderWidth
                                }
                            }
                    }
                }
                .padding(.horizontal, sidePadding)
                .onAppear() {
                    if sliderWidth > 0 {
                        offsetX = sliderX
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .background(backgroundColor)
        }
    }
}

// MARK: - SwiftUI Debug Preview

struct CustomOriginSlider_Previews: PreviewProvider {
    
    private struct CustomOriginSliderDemo: View {
        
        @State var value1: Float = 0
        @State var value2: Float = 0
        @State var showModal = false
        
        var body: some View {
            VStack {
                HStack {
                    Text("value1: \(value1)")
                    Button("Present Modally") {
                        showModal.toggle()
                    }.padding(.top, 1)
                }
                
                CustomOriginSlider(
                    minValue: -100,
                    maxValue: 100,
                    defaultValue: 10,
                    sliderValue: $value1
                ).addDebugTitles()
                
                CustomOriginSlider(
                    minValue: -30,
                    maxValue: 50,
                    defaultValue: 20,
                    sliderValue: $value1
                ).addDebugTitles()
                
                CustomOriginSlider(
                    minValue: 0,
                    maxValue: 100,
                    sliderValue: $value1
                ).addDebugTitles()
                
                CustomOriginSlider(
                    minValue: -50,
                    maxValue: 50,
                    sliderValue: $value2,
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
                ).addDebugTitles()
            }
            .frame(width: 300, height: 300)
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showModal, content: {
                CustomOriginSlider(
                    minValue: -100,
                    maxValue: 100,
                    defaultValue: 10,
                    sliderValue: $value1
                ).addDebugTitles()
                    .preferredColorScheme(.dark)
                    .frame(maxWidth: 300, maxHeight: 80)
            })
        }

    }
    
    static var previews: some View {
        CustomOriginSliderDemo()
    }
}

extension CustomOriginSlider {
    
    func addDebugTitles() -> some View {
        VStack {
            self
            HStack {
                Text(String(format: "%.2f", minValue))
                Spacer()
                Text(String(format: "%.2f", defaultValue))
                Spacer()
                Text(String(format: "%.2f", maxValue))
            }
        }
    }
}
