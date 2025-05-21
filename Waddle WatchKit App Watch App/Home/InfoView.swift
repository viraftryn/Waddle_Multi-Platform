//
//  InfoView.swift
//  Waddle
//
//  Created by Vira Fitriyani on 11/05/25.
//

import SwiftUI

struct InfoView: View {
    
    @ObservedObject var userData = UserData.shared
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 8) {
                    Text("Progress Bar")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    Text("You can **shake your hand** or **tap the duck** to update your progress.")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .homeWatch:
                    HomeView(userData: userData)
                default:
                    EmptyView()
                }
            }
        }
    }
}

//#Preview {
//    struct PreviewWrapper: View {
//         @State var path = NavigationPath()
//        var body: some View {
//            InfoView(userData: UserData(), path: $path)
//        }
//    }
//    
//    return PreviewWrapper()
//}
