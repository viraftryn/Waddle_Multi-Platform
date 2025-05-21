//
//  OpenGaugeView.swift
//  Waddle
//
//  Created by Vira Fitriyani on 11/05/25.
//

import SwiftUI

struct OpenGaugeView: View {
    @ObservedObject var userData: UserData

    var progressRatio: CGFloat {
        guard userData.intakeFrequency > 0 else { return 0 }
        return CGFloat(userData.currentProgress) / CGFloat(userData.intakeFrequency)
    }
    
    let gaugeSpan: CGFloat = 0.75
    let rotation: Double = 135
    let iconCount = 7
    let size: CGFloat = 165
    let strokeWidth: CGFloat = 13
    let arcPadding: CGFloat = 33
    
    var body: some View {
        ZStack {

            let center = size / 2
            let arcRadius = (size - strokeWidth) / 2 - arcPadding / 3.5
            
            ForEach(0..<iconCount) { index in
                let spacingFactor = 0.9
                let fraction = spacingFactor * Double(index) / Double(iconCount - 1)
                let angle = fraction * gaugeSpan * 360 + rotation + 12
                let rad = Angle(degrees: angle).radians
                let x = center + cos(rad) * arcRadius
                let y = center + sin(rad) * arcRadius - 16
                
                Image(systemName: "drop.fill")
                    .resizable()
                    .frame(width: 5, height: 8)
                    .foregroundColor(Color.white.opacity(0.6))
                    .position(x: x, y: y)
            }
            
            Circle()
                .trim(from: 0.0, to: gaugeSpan)
                .stroke(
                    Color.white.opacity(0.35),
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(rotation))
                .padding(.bottom, arcPadding)

            Circle()
                .trim(from: 0.0, to: progressRatio * gaugeSpan)
                .stroke(
                    Color(hex: "FFF784"),
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(rotation))
                .animation(.easeOut(duration: 0.3), value: progressRatio)
                .padding(.bottom, arcPadding)

            VStack {
                Spacer()
                Text("\(userData.currentProgress)/\(userData.intakeFrequency)")
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundColor(Color(hex: "0B4E62"))
                    .padding(.bottom, 25)
            }
        }
        .frame(width: size, height: size)
    }
}

//#Preview {
//    OpenGaugeView(userData: UserData)
//}
