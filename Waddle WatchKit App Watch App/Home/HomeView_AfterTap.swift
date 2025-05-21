//
//  HomeView2.swift
//  Waddle
//
//  Created by Vira Fitriyani on 14/05/25.
//

import SwiftUI

struct HomeView_AfterTap: View {
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
                
                Image("mascotComeBack")
                    .resizable()
                    .frame(width: 101, height: 88.08)
                    .padding(.leading, 8)
                
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
        HomeView_AfterTap(
            motionManager: MotionManager(userData: UserData.shared),
            path: $path
        )
    }
}
