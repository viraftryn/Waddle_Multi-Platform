//
//  HomeView_OnTap.swift
//  Waddle
//
//  Created by Vira Fitriyani on 14/05/25.
//

import Foundation
import SwiftUI
import WatchKit

struct HomeView_OnTap: View {
    
    @ObservedObject var userData = UserData.shared
    @ObservedObject var mascotViewModel: MascotViewModel
    @ObservedObject var motionManager: MotionManager
    @State private var bounce = false
    @Binding var path: NavigationPath
    
    var body: some View {
            ZStack {
                BackgroundImage()
                InfoButton(path: $path)
                
                VStack {
                    Spacer()
                        .frame(height: 85)
                    
                    Button(action: {
                        mascotViewModel.handleTap()
                        WKInterfaceDevice.current().play(.click)
                    }) {
                        Image("mascotTap")
                            .resizable()
                            .frame(width: 108.21, height: 83.75)
                            .offset(y: bounce ? -2 : 0)
                            .animation (
                                Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                                value: bounce)
                    }
                            .padding(.trailing)
                            .padding(.bottom, 75)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                Spacer()
                OpenGaugeView(userData: userData)
                
                    .padding(.top, 25)
                }
                .onAppear {
                    bounce = true
                    motionManager.startMotionUpdates()
                }
            
                .alert(isPresented: $motionManager.showShakeAlert) {
                    Alert(
                        title: Text("Shake Already Used"),
                        message: Text(motionManager.shakeAlertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .infoWatch:
                        InfoView(userData: userData, path: $path)
                    default:
                        EmptyView()
                    }
                }
        }
    }

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var path = NavigationPath()

    var body: some View {
        HomeView_OnTap(
            userData: UserData.shared,
            mascotViewModel: MascotViewModel(userData: UserData.shared),
            motionManager: MotionManager(userData: UserData.shared),
            path: $path
        )
    }
}
