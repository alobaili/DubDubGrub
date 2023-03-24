//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 21/03/2023.
//

import SwiftUI

struct AvatarView: View {
    var image: UIImage
    var size: CGFloat

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(image: PlaceholderImage.avatar, size: 90)
    }
}
