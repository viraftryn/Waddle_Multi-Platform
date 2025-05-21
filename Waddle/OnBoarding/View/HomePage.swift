//
//  HomePage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI

struct HomePage: View {
    
    @ObservedObject var userData = UserData.shared
    @StateObject private var motionManager = MotionManager(userData: UserData.shared)
    @State private var showInfo = false
    @Binding var path: NavigationPath
    @State private var bobbing = false

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    Image("background-ios")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.2)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 2.2)
                }
                
                VStack {
                    VStack(spacing: 10) {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(hex:"E1F5FF"))

                        Text("*Shake* your phone to update\nyour sip-o-meter progress!")
                            .foregroundColor(Color(hex:"E1F5FF"))
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()
                    
                    ZStack {
                        // Body
                        Image("mascot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 270, height: 270)
                            .offset(y:50)
                            .padding(.bottom, 40)
                            .padding(.trailing, 30)
                    }

                    let totalML = userData.calculateWaterIntakeML()
                    let frequency = max(userData.intakeFrequency, 8)
                    let mlPerSip = totalML / frequency
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Sip-o-meter")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Button(action: {
                                showInfo = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color(hex: "FBB24C"))
                            }
                            .alert("What is Sip-o-meter?", isPresented: $showInfo) {
                                Button("Got it!", role: .cancel) { }
                            } message: {
                                Text("The sip-o-meter tracks your water intake. Shake your phone to log a sip and stay hydrated!")
                            }
                        }

                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.4))
                                .frame(height: 30)

                            RoundedRectangle(cornerRadius: 20)
                                .fill(userData.progressRatio < 0.33 ? Color(hex:"FFF784") :
                                        userData.progressRatio < 0.66 ? Color(hex:"FFF784") :
                                        Color(hex:"FFF784"))
                                .frame(width: UIScreen.main.bounds.width * 0.8 * CGFloat(userData.progressRatio), height: 30)
                                .animation(.easeInOut(duration: 0.4), value: userData.currentProgress)
                        }
                        HStack{
                            Text("Goal: \(totalML) ml \n(\(mlPerSip) ml per sip)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .bold()
                            
                            Text("\(userData.currentProgress)/\(frequency) Sips")
                                .foregroundColor(.white)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                    }
                    .padding()
                    .background(Color(hex:"468AB0").opacity(0.9))
                    .cornerRadius(20)
                    .padding()
                }
                .padding()
            }
            
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 205){
                        Text("Hello \(userData.name.isEmpty ? "User" : userData.name)!")
                            .foregroundStyle(Color(hex:"E1F5FF"))
                            .bold()
                        
                        NavigationLink(value: AppRoute.profilePage) {
                            Image("profileButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                        .padding(.trailing, 10)
                    }
                }
            }
            .onAppear {
                motionManager.startMotionUpdates()
            }
            
            .alert(isPresented: $motionManager.showShakeAlert) {
                Alert(
                    title: Text("Shake Already Used"),
                    message: Text(motionManager.shakeAlertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview{
    struct PreviewWrapper: View {
        @State var path = NavigationPath()
        @State var usr: UserData = UserData.shared
        
        var body: some View {
            HomePage(userData: UserData.shared, path: $path)
                .onAppear(){
                    usr.gender = "Male"
                    usr.height = 160
                    usr.weight = 60
                    usr.activityState = "Light"
                    usr.intakeFrequency = 10
                }
        }
    }
    return PreviewWrapper()
}

