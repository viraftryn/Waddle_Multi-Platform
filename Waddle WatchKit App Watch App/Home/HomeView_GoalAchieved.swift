//
//  HomeView_GoalAchieved.swift
//  Waddle
//
//  Created by Vira Fitriyani on 14/05/25.
//

import SwiftUI

struct HomeView_GoalAchieved: View {
    @ObservedObject var userData = UserData.shared
    @ObservedObject var motionManager: MotionManager
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            BackgroundImage()
            InfoButton(path: $path)
            
            VStack {
                Spacer()
                    .frame(height: 80)
                
                Image("mascotAchieved")
                    .resizable()
                    .frame(width: 98, height: 88)
                    .padding(.trailing, 15)
                
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
        HomeView_GoalAchieved(
            motionManager: MotionManager(userData: UserData.shared),
            path: $path
        )
    }
}
