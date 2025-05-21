//
//  NamePage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI

struct NamePage: View {
    
    @ObservedObject var userData = UserData.shared
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath
    
    var isButtonDisabled: Bool {
        userData.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Image("background-ios-profile")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 10) {
                Text("WADDLE")
                    .font(.custom("ChalkboardSE-Bold", size: 50))
                    .foregroundColor(.black)
                    .padding(.top, 200)
                    .overlay(
                        Text("WADDLE")
                            .font(.custom("ChalkboardSE-Bold", size: 50))
                            .foregroundColor(.white)
                            .padding(.top, 200)
                            .offset(x: -2, y: -1)
                    )
                
                Image("mascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 108.21, height: 83.46)
                    .padding(.top, 50)
                
                VStack(spacing: 10) {
                    Text("Hi! What's your name?")
                        .font(.custom("ChalkboardSE-Bold", size: 20))
                        .foregroundColor(.white)
                    
                    TextField("Type here", text: $userData.name)
                        .padding()
                        .frame(width: 325, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(30)
                        .multilineTextAlignment(.center)
                        .font(.custom("ChalkboardSE-Regular", size: 15))
                        .foregroundColor(Color(hex: "396F86"))
                    
                    ZStack {
                        if showAlert {
                            Text("We'd love to know what to call you!")
                                .font(.custom("ChalkboardSE-Regular", size: 12))
                                .foregroundColor(.red)
                        } else {
                            Text(" ")
                                .font(.custom("ChalkboardSE-Regular", size: 12))
                        }
                    }
                }
                .padding(.top)
                
                Button(action: {
                    if isButtonDisabled {
                        showAlert = true
                    } else {
                        showAlert = false
                        path = NavigationPath()
                        path.append(AppRoute.gender)
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
                Spacer()
            }
        }
        
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .gender:
                GenderPage(userData: userData, path: $path)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
         @State var path = NavigationPath()
        var body: some View {
            NamePage(userData: UserData.shared, path: $path)
        }
    }
    
    return PreviewWrapper()
}
