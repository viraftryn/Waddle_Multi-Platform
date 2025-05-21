//
//  WelcomePage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI

struct WelcomePage: View {
    
    @StateObject private var userData = UserData.shared
    @State private var path = NavigationPath()
    @State private var fadeOut = false
    @State private var animateLetters: [Bool] = Array(repeating: false, count: 6)
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("background-ios-profile")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                
                HStack(spacing: 0) {
                    ForEach(Array("WADDLE".enumerated()), id: \.offset) { index, letter in
                        Text(String(letter))
                            .font(.custom("ChalkboardSE-Bold", size: 50))
                            .foregroundColor(.black)
                            .overlay(
                                Text(String(letter))
                                    .font(.custom("ChalkboardSE-Bold", size: 50))
                                    .foregroundColor(.white)
                                    .offset(x: -2, y: -1)
                            )
                            .scaleEffect(animateLetters[index] ? 1.2 : 0.5)
                            .opacity(fadeOut ? 0 : 1)
                            .offset(y: fadeOut ? -30 : 0)
                            .animation(.interpolatingSpring(stiffness: 170, damping: 10).delay(Double(index) * 0.1), value: animateLetters[index])
                            .animation(.easeInOut(duration: 1.0), value: fadeOut)
                    }
                }
                .onAppear {
                    Notification.shared.requestPermission(userData: userData)
                    for i in 0..<animateLetters.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                            animateLetters[i] = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation {
                            fadeOut = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if userData.isComplete {
                                path = NavigationPath()
                                path.append(AppRoute.mainPage)
                            } else {
                                path = NavigationPath()
                                path.append(AppRoute.name)
                            }
                        }
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .name:
                        NamePage(userData: userData, path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .gender:
                        GenderPage(userData: userData, path: $path)
                    case .weightHeight:
                        WeightHeightPage(userData: userData, path: $path)
                    case .activityState:
                        ActivityStatePage(userData: userData, path: $path)
                    case .intakeFrequency:
                        IntakeFrequencyPage(userData: userData, path: $path)
                    case .mainPage:
                        HomePage(userData: UserData.shared, path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .profilePage:
                        ProfilePage(userData: userData, path: $path)
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
}


#Preview {
    WelcomePage()
}
