//
//  GenderPage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI

struct GenderPage: View {
    
    @ObservedObject var userData = UserData.shared
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath
    
    var isButtonDisabled: Bool {
        userData.gender.isEmpty
    }
    
    var body: some View {
        ZStack {
            Image("background-ios-profile")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            
            GeometryReader { geometry in
                
                Text("Are you a?")
                    .font(.custom("ChalkboardSE-Bold", size: 20))
                    .foregroundColor(.white)
                    .position(x: geometry.size.width / 2,
                              y: geometry.size.height / 7.5)
                
                if showAlert {
                    Text("Select your gender!")
                        .font(.custom("ChalkboardSE-Regular", size: 12))
                        .foregroundColor(Color(hex: "EA5539"))
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 4.7)
                }
            }
            VStack(spacing: 20){
                Spacer()
                    .frame(height: 200)
                
                GenderSelectionView(userData: userData)
                
                    .padding(.top, -50)
                
                Text("💡 Gender can affect how much water your body needs to stay properly hydrated. By knowing your gender, we can give you a more accurate hydration goal!")
                    .font(.custom("ChalkboardSE-Regular", size: 12))
                    .foregroundColor(Color(hex: "396F86"))
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width: 340, height: 90)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(15)
            
                    .padding(.bottom, 25)
                
                Button(action: {
                    if isButtonDisabled{
                        showAlert = true
                    } else {
                        showAlert = false
                        path = NavigationPath()
                        path.append(AppRoute.weightHeight)
                    }
                }) {
                    Text("NEXT")
                        .font(.custom("ChalkboardSE-Bold", size: 10))
                        .foregroundColor(Color(hex:"9ECFE1"))
                        .padding()
                        .frame(width: 80, height: 25)
                        .background(Color.white)
                        .cornerRadius(20)
                }
                Spacer()
            }
        }
        
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .weightHeight:
                WeightHeightPage(userData: userData, path: $path)
            default:
                EmptyView()
            }
        }
    }
    
}

#Preview {
    struct PreviewWrapper: View {
        @State var showAlert = false
        @State var path = NavigationPath()
        var body: some View {
            GenderPage(userData: UserData.shared, path: $path)
        }
    }
    
    return PreviewWrapper()
}
