//
//  ProfilePage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 11/05/25.
//

import SwiftUI

struct ProfilePage: View {
    @ObservedObject var userData = UserData.shared
    @Binding var path: NavigationPath
    
    @State private var tempWeight: String = ""
    @State private var tempHeight: String = ""
    @State private var tempDrinkFrequency: String = ""
    @State private var tempActivityLevel: String = ""

    @State private var showSavedToast: Bool = false
    @State private var validationErrors: [String: Bool] = [:]
    
    var activityDescription: String {
        switch tempActivityLevel {
        case "Low Intensity 🐌":
            return "Little to no exercise. Sitting, studying, or light household chores."
        case "Medium Intensity ⚙️":
            return "You move around regularly. Walking, cycling, or exercising a few times a week."
        case "High Intensity 🏃‍♂️":
            return "You’re very active daily. Intense workouts, manual labor, or high-energy sports."
        default:
            return ""
        }
    }

    var body: some View {
        ZStack {
            Image("background-ios-profile")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Hello \(userData.name.isEmpty ? "User" : userData.name)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    // Gender Display
                    infoCard(title: "Gender", content: userData.gender)

                    // Editable Inputs
                    inputCard(title: "weight", label: "Weight (kg)", text: $tempWeight)
                    inputCard(title: "height", label: "Height (cm)", text: $tempHeight)
                    inputCard(title: "drinkFrequency", label: "Drink Frequency (times/day)", text: $tempDrinkFrequency, isPicker: true)

                    // Activity Level Picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Activity Level")
                            .font(.headline)
                            .foregroundColor(.white)

                        Menu {
                            ForEach(["Low Intensity 🐌", "Medium Intensity ⚙️", "High Intensity 🏃‍♂️"], id: \.self) { level in
                                Button(action: {
                                    tempActivityLevel = level
                                }) {
                                    Text(level)
                                }
                            }
                        } label: {
                            HStack {
                                Text(tempActivityLevel.isEmpty ? "Select your activity level" : tempActivityLevel)
                                    .foregroundColor(.white)
                                    .bold()
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                        }

                        // Activity Description
                        if !activityDescription.isEmpty {
                            Text(activityDescription)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }

                        // Validation
                        if validationErrors["activityLevel"] ?? false {
                            Text("Please select your activity level")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(16)

                    // Save Button
                    Button(action: saveProfile) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                            
                    }
                    
                }
                .padding()
                .onAppear {
                    tempWeight = String(format: "%.1f", userData.weight)
                    tempHeight = String(format: "%.0f", userData.height)
                    tempDrinkFrequency = String(userData.intakeFrequency)
                    tempActivityLevel = userData.activityState
                }
            }
            .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                        }
                    }
                }

            // Toast Confirmation
            if showSavedToast {
                VStack {
                    Spacer()
                    Text("Profile Saved ✅")
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                        .padding(.bottom, 40)
                }
                .animation(.easeInOut(duration: 0.3), value: showSavedToast)
            }
        }
    }


    func infoCard(title: String, content: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(content)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }

    func inputCard(title: String, label: String, text: Binding<String>, isPicker: Bool = false) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(label == "Gender" ? .black : .white)

                if validationErrors[title] ?? false {
                    Text("*This field cannot be empty")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                }
            }

            if isPicker {
                Menu {
                    ForEach(8...20, id: \.self) { number in
                        Button(action: {
                            text.wrappedValue = String(number)
                        }) {
                            Text("\(number)")
                        }
                    }
                } label: {
                    HStack {
                        Text(text.wrappedValue.isEmpty ? "Select frequency" : text.wrappedValue)
                            .foregroundColor(.white)
                            .bold()
                            .padding(9)
                        Text("times a day")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                }
            } else {
                ZStack(alignment: .leading) {
                    if text.wrappedValue.isEmpty {
                        Text(label)
                            .foregroundColor(Color(hex:"767676"))
                            .padding(8)
                    }
                    
                    TextField("", text: text)
                        .keyboardType(.numberPad)
                        .padding(8)

                }
                .background(Color.white)
                .cornerRadius(10)

            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
    }

    // MARK: - Save Logic

    func saveProfile() {
        // Validate inputs
        validationErrors["weight"] = tempWeight.isEmpty
        validationErrors["height"] = tempHeight.isEmpty
        validationErrors["drinkFrequency"] = tempDrinkFrequency.isEmpty
        validationErrors["activityLevel"] = tempActivityLevel.isEmpty

        // If any are invalid, don't save
        if validationErrors.values.contains(true) {
            return
        }

        // Save data
        userData.weight = Double(tempWeight) ?? userData.weight
        userData.height = Double(tempHeight) ?? userData.height
        userData.intakeFrequency = Int(tempDrinkFrequency) ?? userData.intakeFrequency
        userData.activityState = tempActivityLevel

        // Show toast
        showSavedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSavedToast = false
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var path = NavigationPath()
        var body: some View {
            ProfilePage(userData: UserData.shared, path: $path)
        }
    }
    
    return PreviewWrapper()
}

