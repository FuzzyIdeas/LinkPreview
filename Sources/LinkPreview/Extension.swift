//
//  SwiftUIView.swift
//
//
//  Created by 이웅재 on 2021/12/08.
//

import SwiftUI

public extension LinkPreview {
    func primaryFontColor(_ primaryFontColor: Color) -> LinkPreview {
        var result = self

        result.primaryFontColor = primaryFontColor
        return result
    }

    func secondaryFontColor(_ secondaryFontColor: Color) -> LinkPreview {
        var result = self

        result.secondaryFontColor = secondaryFontColor
        return result
    }

    func backgroundColor(_ backgroundColor: Color) -> LinkPreview {
        var result = self

        result.backgroundColor = backgroundColor
        return result
    }

    func titleLineLimit(_ titleLineLimit: Int) -> LinkPreview {
        var result = self

        result.titleLineLimit = titleLineLimit
        return result
    }

    func maxWidth(_ maxWidth: CGFloat?) -> LinkPreview {
        var result = self

        result.maxWidth = maxWidth
        return result
    }

    func cornerRadius(_ cornerRadius: CGFloat) -> LinkPreview {
        var result = self

        result.cornerRadius = cornerRadius
        return result
    }

    func type(_ type: LinkPreviewType) -> LinkPreview {
        var result = self

        result.type = type
        return result
    }
}

#if os(macOS)
    typealias XImage = NSImage
    func img(_ nsImage: NSImage) -> Image {
        Image(nsImage: nsImage)
    }
#else
    typealias XImage = UIImage
    func img(_ uiImage: UIImage) -> Image {
        Image(uiImage: uiImage)
    }
#endif
