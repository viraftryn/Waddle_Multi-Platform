//
//  WeightHeightPage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI

struct WeightHeightPage: View {
    @ObservedObject var userData = UserData.shared
    @State private var weightText: String = ""
    @State private var heightText: String = ""
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath
    
    var isButtonDisabled: Bool {
        weightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        heightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        Double(weightText) == nil ||
        Double(heightText) == nil
    }
    
    var body: some View {
        ZStack {
            Image("background-ios-profile")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Spacer()
                VStack() {
                    Text("Let's customize your journey further!")
                        .font(.custom("ChalkboardSE-Bold", size: 17))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                    
                    Text("Your weight and height helps us do that.")
                        .font(.custom("ChalkboardSE-Bold", size: 17))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                }
                
                VStack {
                    VStack(spacing: 2) {
                        Text("Weight")
                            .font(.custom("ChalkboardSE-Bold", size: 15))
                            .foregroundColor(.white)
                        
                        TextField("kg", text: $weightText)
                            .frame(width: 325, height: 40)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(30)
                            .multilineTextAlignment(.center)
                            .font(.custom("ChalkboardSE-Regular", size: 15))
                            .foregroundColor(Color(hex: "396F86"))
                            .keyboardType(.numberPad)
                            .padding(8)
                            
                    }
                    
                    VStack(spacing: 2) {
                        Text("Height")
                            .font(.custom("ChalkboardSE-Bold", size: 15))
                            .foregroundColor(.white)
                        
                        TextField("cm", text: $heightText)
                            .frame(width: 325, height: 40)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(30)
                            .multilineTextAlignment(.center)
                            .font(.custom("ChalkboardSE-Regular", size: 15))
                            .foregroundColor(Color(hex: "396F86"))
                            .keyboardType(.numberPad)
                            .padding(8)
                            
                    }
                    ZStack {
                        if showAlert {
                            Text("Let Waddle know your weight and height!")
                                .foregroundColor(.red)
                                .font(.custom("ChalkboardSE-Regular", size: 13))
                                
                        } else {
                            Text(" ")
                                .font(.custom("ChalkboardSE-Regular", size: 13))
                        }
                    }
                }
                
                Button(action: {
                    if isButtonDisabled {
                        showAlert = true
                    } else {
                        showAlert = false
                        userData.weight = Double(weightText) ?? 0
                        userData.height = Double(heightText) ?? 0
                        path = NavigationPath()
                        path.append(AppRoute.activityState)
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
                
                Image("waddlePage3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 270)
                
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .activityState:
                            ActivityStatePage(userData: userData, path: $path)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {}
                }
            }
        }
    }

//#Preview {
//    struct PreviewWrapper: View {
//        @State var path = NavigationPath()
//        @State var showAlert = false
//        var body: some View {
//            WeightHeightPage(userData: UserData(), path: $path)
//        }
//    }
//    
//    return PreviewWrapper()
//}

