//
//  ActivityStatePage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI

struct ActivityStatePage: View {
    
    @ObservedObject var userData = UserData.shared
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath
    
    var activityDescription: String {
        switch userData.activityState {
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
    
    var isButtonDisabled: Bool {
        userData.activityState.isEmpty
    }
    
    var body: some View {
            ZStack{
                Image("background-ios-profile")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    Spacer()
                    Text("How much do you move daily? \nLet's find the best fit for you! ")
                        .foregroundStyle(.white)
                        .font(.custom("ChalkboardSE-Bold", size: 18))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    let options = ["Low Intensity 🐌", "Medium Intensity ⚙️", "High Intensity 🏃‍♂️"]
                    Menu {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                userData.activityState = option
                            }) {
                                Text(option)
                            }
                        }
                    } label: {
                        HStack {
                            Text(userData.activityState.isEmpty ? "Select an option" : userData.activityState)
                                .font(.custom("ChalkboardSE-Bold", size: 15))
                                .foregroundColor(Color.white)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(width: 325, height: 40)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(20)
                    }
                    .padding()
                    
                    if !userData.activityState.isEmpty {
                        VStack(spacing: 1){
                            Text(activityDescription)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .transition(.opacity)
                        .padding(.bottom, 17)
                    }
                    
                    ZStack {
                        if showAlert {
                            Text("Let Waddle know your daily groove - pick your activity level!")
                                .font(.custom("ChalkboardSE-Regular", size: 12))
                                .foregroundColor(.red)
                        } else {
                            Text(" ")
                                .font(.custom("ChalkboardSE-Regular", size: 12))
                        }
                    }
                    
                    Button(action: {
                        if isButtonDisabled {
                            showAlert = true
                        } else {
                            showAlert = false
                            path = NavigationPath()
                            path.append(AppRoute.intakeFrequency)
                        }
                    }) {
                        Text("NEXT")
                            .font(.custom("ChalkboardSE-Bold", size: 10))
                            .foregroundColor(Color(hex:"9ECFE1"))
                            .padding()
                            .frame(width: 80, height: 25)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    
                    Image("waddlePage4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .intakeFrequency:
                    IntakeFrequencyPage(userData: userData, path: $path)
                default:
                    EmptyView()
                }
            }
        }
}

#Preview {
    struct PreviewWrapper: View {
        @State var path = NavigationPath()
        @State var showAlert = false
        var body: some View {
            ActivityStatePage(userData: UserData.shared, path: $path)
        }
    }
    
    return PreviewWrapper()
}

