//
//  InfoButton.swift
//  Waddle
//
//  Created by Vira Fitriyani on 16/05/25.
//

import SwiftUI

struct InfoButton: View {
    @Binding var path: NavigationPath
    @ObservedObject var userData = UserData.shared
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    path.append(AppRoute.infoWatch)
                }) {
                    Image("infoButton")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .contentShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .padding([.leading, .top], 10)
            Spacer()
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
