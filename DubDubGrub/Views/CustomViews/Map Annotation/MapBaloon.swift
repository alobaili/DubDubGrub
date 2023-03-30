//
//  MapBaloon.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 30/03/2023.
//

import SwiftUI

struct MapBaloon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        return path
    }
}

struct MapBaloon_Previews: PreviewProvider {
    static var previews: some View {
        MapBaloon()
            .frame(width: 300, height: 240)
            .foregroundColor(.brandPrimary)
    }
}
