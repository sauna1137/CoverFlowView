//
//  ContentView.swift
//  CoverFlowView
//
//  Created by KS on 2024/12/09.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      GeometryReader { geometry in
        let size = geometry.size
        let scrollViewWidth = size.width
        let screenMidX = UIScreen.main.bounds.width / 2

        VStack {
          Spacer()
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
              ForEach(1...7, id: \.self) { i in

                GeometryReader { itemGeometry in
                  let itemMidX = itemGeometry.frame(in: .global).midX
                  let distanceFromCenter = abs(itemMidX - screenMidX)
                  let scale = calcScale(distance: distanceFromCenter, scrollViewWidth: scrollViewWidth)

                  Image("\(i)")
                    .resizable()
                    .scaledToFill()
                    .reflection()
                    .scaleEffect(scale)
                    .animation(.easeInOut, value: scale)
                    .rotation3DEffect(
                      .degrees(calcRotation(itemGeometry)),
                      axis: (x: 0, y: 1, z: 0),
                      anchor: .center
                    )
                }
                .frame(width: 160, height: 160)
              }
            }
            .padding(.horizontal, (size.width - 160) / 2)
            .scrollTargetLayout()
          }
          .scrollTargetBehavior(.viewAligned)
          .scrollIndicators(.hidden)
          .scrollClipDisabled()
          Spacer()
        }
      }
    }
  }

  func calcScale(distance: CGFloat, scrollViewWidth: CGFloat) -> CGFloat {
    let normalizedDistance = distance / scrollViewWidth
    return 0.8 + 0.7 * exp(-2.5 * normalizedDistance)
  }

  func calcRotation(_ proxy: GeometryProxy) -> Double {
    let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
    let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
    let centerX = scrollViewWidth / 2
    let distanceFromCenter = midX - centerX
    let normalizedDistance = abs(distanceFromCenter / (scrollViewWidth * 1.2))
    if normalizedDistance <= 0.14 {
      return 0
    } else {
      return distanceFromCenter > 0 ? -45.0 : 45.0
    }
  }
}

extension View {
  func reflection() -> some View {
    self.overlay(
      GeometryReader { proxy in
        self
          .scaleEffect(y: -1)
          .mask(
            LinearGradient(
              gradient: Gradient(colors: [
                .white.opacity(0.5),
                .white.opacity(0.4),
                .white.opacity(0.3),
                .white.opacity(0.2),
                .white.opacity(0.1)
              ] + Array(repeating: .clear, count: 4)),
              startPoint: .top,
              endPoint: .bottom
            )
          )
          .offset(y: proxy.size.height + 1)
      }
    )
  }
}

func rotation(_ proxy: GeometryProxy) -> Double {
  let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
  let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
  let centerX = scrollViewWidth / 2
  let distanceFromCenter = midX - centerX
  let normalizedDistance = abs(distanceFromCenter / (scrollViewWidth * 1.2))
  if normalizedDistance <= 0.14 {
    return 0
  } else {
    return distanceFromCenter > 0 ? -45.0 : 45.0
  }
}

#Preview {
  ContentView()
}

