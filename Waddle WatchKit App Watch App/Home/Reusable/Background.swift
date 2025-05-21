//
//  BackgroundViewModel.swift
//  Waddle
//
//  Created by Vira Fitriyani on 16/05/25.
//

import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundImageNight: View {
    var body: some View {
        Image("background-night")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

