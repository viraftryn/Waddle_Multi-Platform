//
//  HomeView_Sleep.swift
//  Waddle
//
//  Created by Vira Fitriyani on 14/05/25.
//

import SwiftUI

struct HomeView_Sleep: View {
    @ObservedObject var userData = UserData.shared
    @ObservedObject var motionManager: MotionManager
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            BackgroundImageNight()
            InfoButton(path: $path)
            
            VStack {
                Spacer()
                    .frame(height: 65)
                
                Image("mascotSleeping")
                    .resizable()
                    .frame(width: 87, height: 103.52)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                OpenGaugeView(userData: userData)

                    .padding(.bottom, 25)
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
        HomeView_Sleep(
            motionManager: MotionManager(userData: UserData.shared),
            path: $path
        )
    }
}
