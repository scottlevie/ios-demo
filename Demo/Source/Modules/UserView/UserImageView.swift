//
//  UserImage.swift
//  Demo
//
//  Created by Scott Levie on 3/21/20.
//  Copyright © 2020 Scott Levie. All rights reserved.
//

import SwiftUI

struct UserImageView: View {

    @Binding var image: UIImage?

    init(_ image: Binding<UIImage?>) { _image = image }

    var body: some View {
        let image: AnyView

        if let uiImage = self.image {
            image = AnyView(self.imageView(uiImage))
        }
        else {
            image = AnyView(self.emptyImageView())
        }

        return GeometryReader { geometry in
            image
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .center
                )
                .clipped()
        }
    }

    private func imageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
    }

    private func emptyImageView() -> some View {
        Image(systemName: "person.fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding(.top, 20)
            .padding(.bottom, -20)
            .clipped()
    }
}


// MARK: - Preview


struct UserImageView_Previews: PreviewProvider {

    static var previews: some View {

        let img = UIImage(named: "pennywise")

        return Group {
            // Square
            self.preview(image: img, smWidth: true, smHeight: true)
            self.preview(image: nil, smWidth: true, smHeight: true)
            // Landscape
            self.preview(image: img, smWidth: false, smHeight: true)
            self.preview(image: nil, smWidth: false, smHeight: true)
            // Portrait
            self.preview(image: img, smWidth: true, smHeight: false)
            self.preview(image: nil, smWidth: true, smHeight: false)
        }
    }

    static func preview(image: UIImage?, smWidth: Bool, smHeight: Bool) -> some View {

        let width: CGFloat = smWidth ? 200 : 300
        let height: CGFloat = smHeight ? 200 : 300

        return UserImageView(.constant(image))
            .frame(width: width, height: height)
            .overlay(Rectangle().stroke(Color.gray, lineWidth: 0.5))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
