////
////  ProgressBarView.swift
////  EDTS_DS_SwiftUI
////
////  Created by Rizka Ghinna Auliya on 19/08/26.
////
//
//import SwiftUI
//
//// MARK: - Reusable Progress Bar Component
//
//struct ProgressBarView: View {
//    let progress: CGFloat
//    var trackColor: Color = EDTSColor.grey30
//    var fillColor: Color = EDTSColor.blue50
//    var height: CGFloat = 4
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                Capsule()
//                    .fill(trackColor)
//
//                Capsule()
//                    .fill(fillColor)
//                    .frame(width: geometry.size.width * max(0, min(progress, 1)))
//            }
//        }
//        .frame(height: height)
//    }
//}
