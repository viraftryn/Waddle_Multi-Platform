//
//  IntakeFrequencyPage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI

struct IntakeFrequencyPage: View {
    @ObservedObject var userData = UserData.shared
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath
    @State private var showPermissionAlert = false
    
    var isButtonDisabled: Bool {
        userData.intakeFrequency < 8
    }
    
    var body: some View {
        ZStack {
            Image("background-ios-profile")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 20) {
                Spacer()
                Text("How frequent do you drink \nwater in a day?")
                    .foregroundStyle(.white)
                    .font(.custom("ChalkboardSE-Bold", size: 20))
                    .multilineTextAlignment(.center)
                
                HStack{
                    Menu {
                        ForEach(Array(8...20).sorted(), id: \.self) { number in
                            Button(action: {
                                userData.intakeFrequency = number
                            }) {
                                Text("\(number)")
                            }
                        }
                    } label: {
                        HStack {
                            Text(userData.intakeFrequency >= 8 ? "\(userData.intakeFrequency)" : "Select")
                                .foregroundColor(.white)
                                .font(.custom("ChalkboardSE-Bold", size: 16))
                            Text("Times a day")
                                .foregroundColor(.white)
                                .font(.custom("ChalkboardSE-Bold", size: 16))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        }
                        .frame(width: 325, height: 40)
                        .padding()
                        .frame(height: 50)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(30)
                    }
                    
                }
                ZStack {
                    if showAlert {
                        Text("Waddle wants to know your daily water intake!")
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
                        if userData.isComplete {
                            showPermissionAlert = true
                        }
                    }
                }) {
                    Text("SUBMIT")
                        .font(.custom("ChalkboardSE-Bold", size: 10))
                        .foregroundColor(Color(hex: "9ECFE1"))
                        .padding()
                        .frame(width: 80, height: 25)
                        .background(Color.white)
                        .cornerRadius(20)
                }
                
                Image("waddlePage5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                
            }
            .alert(isPresented: $showPermissionAlert) {
                Alert(
                    title: Text("Enable Notifications"),
                    message: Text("We’ll remind you to drink water throughout the day!\n(8 AM - 9 PM)"),
                    primaryButton: .default(Text("Allow")) {
                        Notification.shared.requestPermission(userData: userData)
                        path = NavigationPath()
                        path.append(AppRoute.mainPage)
                    },
                    secondaryButton: .cancel {
                        path = NavigationPath()
                        path.append(AppRoute.mainPage)
                    }
                )
            }
            
        }
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .mainPage:
                HomePage(userData: UserData.shared, path: $path)
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
            return IntakeFrequencyPage(userData: UserData.shared, path: $path)
        }
    }
    
    return PreviewWrapper()
}

