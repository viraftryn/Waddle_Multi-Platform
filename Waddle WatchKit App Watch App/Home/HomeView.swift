//
//  HomeView.swift
//  Waddle
//
//  Created by Vira Fitriyani on 11/05/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @ObservedObject var userData = UserData.shared
    @StateObject private var motionManager = MotionManager(userData: UserData.shared)
    @StateObject private var mascotViewModel = MascotViewModel(userData: UserData.shared)
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            viewForMascotState()
            
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .homeWatch:
                    HomeView(userData: userData)
                case .infoWatch:
                    InfoView(userData: userData, path: $path)
                default:
                    EmptyView()
                }
            }
        }
    }
    
    @ViewBuilder
    private func viewForMascotState() -> some View {
        switch mascotViewModel.mascotState {
        case .onTap:
            HomeView_OnTap(userData: userData, mascotViewModel: mascotViewModel, motionManager: motionManager, path: $path)
        case .afterTap:
            HomeView_AfterTap(motionManager: motionManager, path: $path)
        case .goalAchieved:
            HomeView_GoalAchieved(motionManager: motionManager, path: $path)
        case .sleep:
            HomeView_Sleep(motionManager: motionManager, path: $path)
        }
    }
}

#Preview {
    HomeView()
}
