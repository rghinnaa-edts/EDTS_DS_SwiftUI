//
//  ProgressBarView.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 19/08/26.
//

import SwiftUI
import Combine

struct ProgressBarView: View {
    let progress: CGFloat
    var multiplier: Int = 1
    var badgeMultiplier: Int = 0
    var showBadge: Bool = false

    var trackColor: Color = EDTSColor.grey20
    var completedTrackColor: Color = EDTSColor.blue30

    private let indicatorSize: CGFloat = 8
    private let badgeSize: CGFloat = 16
    private let trackHeight: CGFloat = 6
    private let trackFillPadding: CGFloat = 1

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [EDTSColor.skyblueLeading, EDTSColor.skyblueTrailing],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        GeometryReader { geometry in
            let trackWidth = max(0, geometry.size.width - badgeSize / 2)
            let clampedProgress = max(0, min(progress, 1))

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(trackColor)
                    .frame(width: trackWidth, height: trackHeight)

                LapFillView(
                    targetProgress: clampedProgress,
                    multiplier: multiplier,
                    trackWidth: trackWidth,
                    trackHeight: trackHeight,
                    trackFillPadding: trackFillPadding,
                    indicatorSize: indicatorSize,
                    gradient: gradient,
                    completedTrackColor: completedTrackColor,
                    showBadge: showBadge
                )

                if showBadge {
                    ZStack {
                        Circle()
                            .fill(gradient)
                            .frame(width: badgeSize, height: badgeSize)

                        Text("x\(badgeMultiplier)")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: trackWidth - badgeSize / 2)
                    .transition(.opacity)
                }
            }
            .frame(width: geometry.size.width, height: badgeSize)
            .animation(.easeInOut(duration: 0.2), value: showBadge)
        }
        .frame(height: badgeSize)
    }
}


// MARK: - Lap Fill

private struct LapFillView: View {
    let targetProgress: CGFloat
    let multiplier: Int
    let trackWidth: CGFloat
    let trackHeight: CGFloat
    let trackFillPadding: CGFloat
    let indicatorSize: CGFloat
    let gradient: LinearGradient
    let completedTrackColor: Color
    let showBadge: Bool

    @State private var displayProgress: CGFloat = 0
    @State private var lastHandledProgress: CGFloat = -1
    @State private var lastHandledMultiplier: Int = -1

    private let growDuration = 0.3
    private let shrinkDuration = 0.25
    private let overlayFadeDuration = 0.2

    private var showCompletedOverlay: Bool {
        showBadge && displayProgress > 0
    }

    var body: some View {
        let innerWidth = max(0, trackWidth - trackFillPadding * 2)
        let innerHeight = max(0, trackHeight - trackFillPadding * 2)
        let fillWidth = innerWidth * displayProgress

        ZStack(alignment: .leading) {
            Capsule()
                .fill(completedTrackColor)
                .frame(width: innerWidth, height: innerHeight)
                .opacity(showCompletedOverlay ? 1 : 0)
                .animation(.easeInOut(duration: overlayFadeDuration), value: showCompletedOverlay)

            Capsule()
                .fill(gradient)
                .frame(width: fillWidth, height: innerHeight)

            Circle()
                .fill(gradient)
                .frame(width: indicatorSize, height: indicatorSize)
                .offset(x: max(0, fillWidth - indicatorSize / 2))
                .opacity(displayProgress >= 1 ? 0 : 1)
        }
        .padding(trackFillPadding)
        .onAppear {
            lastHandledMultiplier = multiplier
            advance(to: targetProgress)
        }
        .onReceive(Just(multiplier)) { newMultiplier in
            guard newMultiplier != lastHandledMultiplier else { return }
            let didIncreaseLap = newMultiplier > lastHandledMultiplier
            lastHandledMultiplier = newMultiplier

            if didIncreaseLap {
                displayProgress = 0
                advance(to: targetProgress)
            } else {
                withAnimation(.easeInOut(duration: shrinkDuration)) {
                    displayProgress = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + shrinkDuration) {
                    advance(to: targetProgress)
                }
            }
        }
        .onReceive(Just(targetProgress)) { newProgress in
            guard multiplier == lastHandledMultiplier else { return }
            guard newProgress != lastHandledProgress else { return }
            advance(to: newProgress)
        }
    }

    private func advance(to newProgress: CGFloat) {
        lastHandledProgress = newProgress
        withAnimation(.easeInOut(duration: growDuration)) {
            displayProgress = newProgress
        }
    }
}
