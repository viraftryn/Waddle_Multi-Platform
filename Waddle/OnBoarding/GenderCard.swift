//
//  GenderViewModel.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI

struct GenderCard: View {
    var imageName: String
    var gender: String
    @ObservedObject var userData: UserData

    var body: some View {
        let isSelected = userData.gender == gender
        let textColor: Color = isSelected ? .white : .black
        let genderColor: Color = {
            if isSelected {
                return gender == "Male" ? Color(hex: "#4150B6") : Color(hex: "#E18AAA")
            } else {
                return Color.white
            }
        }()

        return Button(action: {
            userData.gender = gender
        }) {
            VStack(spacing: 0) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 170)
                    .clipped()

                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected
                        ? AnyShapeStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [genderColor.opacity(0.6), genderColor]),
                                startPoint: .topLeading,
                                endPoint: .bottom
                            )
                        )
                        : AnyShapeStyle(Color.white)
                    )
                    .frame(height: 110)
                    .overlay(
                        Text(gender)
                            .foregroundColor(textColor)
                            .font(.system(size: 27))
                            .bold(isSelected)
                    )
            }
            .frame(width: 170)
            .shadow(radius: 5)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? genderColor : Color(hex: "#EEEEEE"), lineWidth: 3)
            )
        }
    }
}


struct GenderSelectionView: View {
    @ObservedObject var userData: UserData

    var body: some View {

        HStack(spacing: 20) {
            GenderCard(imageName: "waddleBoy", gender: "Male", userData: userData)
            GenderCard(imageName: "waddleGirl", gender: "Female", userData: userData)
        }
        .padding()
    }
}
