//
//  ContentView.swift
//  VolumeMakeItLouder
//
//  Created by Inna Chystiakova on 22/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var config: Configuration = .init()
    
    var body: some View {
        GeometryReader {
            let size = $0.size

            ZStack{
                LinearGradient(gradient: Gradient(colors: [.black, .red, .orange, .purple, .blue, .cyan]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .frame(width: 80, height: 200)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white)
                            .scaleEffect(y: config.progress, anchor: .bottom)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .scaleEffect(x: config.xScale, y: config.yScale, anchor: config.anchor)
            }
            .gesture(
                LongPressGesture(minimumDuration: 0.0).onEnded{ _ in
                    config.lastProgress = config.progress
                }.simultaneously(with: DragGesture().onChanged({ value in
                    /// - Converting Offset Into Progress
                    let startLocation = value.startLocation.y
                    let currentLocation = value.location.y
                    let offset = startLocation - currentLocation
                    /// - Converting It Into Progress
                    var progress = (offset / size.height) + config.lastProgress
                    /// - Clipping Progress btw 0 - 1
                    ///
                    if progress < 0 || progress > 1 {
                        config.anchor = (progress < 0) ? .top : .bottom
                        config.xScale = 0.9
                        config.yScale = (progress > 0) ? progress * 1.05 : (1-progress) * 1.05
                    } else {
                        config.yScale = 1.0
                        config.xScale = 1.0
                    }
                    progress = max(0, progress)
                    progress = min(1, progress)
                    config.progress = progress
                }).onEnded({ value in
                    /// - Saving Last Progress for Continous Flow
                    config.lastProgress = config.progress
                    withAnimation {
                        config.xScale = 1.0
                        config.yScale = 1.0
                    }
                }))
            )
        }
    }
}

struct Configuration{
    var progress: CGFloat = 0.5
    var xScale: CGFloat = 1.0
    var yScale: CGFloat = 1.0
    var lastProgress: CGFloat = 0
    var anchor: UnitPoint = .zero
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
