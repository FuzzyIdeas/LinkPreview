//
//  LinkPreviewDesign.swift
//
//
//  Created by 이웅재 on 2021/12/08.
//

import LinkPresentation
import SwiftUI
import UniformTypeIdentifiers
#if os(iOS)
    import MobileCoreServices
#endif

// MARK: - LinkPreviewDesign

struct LinkPreviewDesign: View {
    // MARK: Lifecycle

    init(
        metaData: LPLinkMetadata,
        type: LinkPreviewType = .auto,
        backgroundColor: Color,
        primaryFontColor: Color,
        secondaryFontColor: Color,
        titleLineLimit: Int,
        maxWidth: CGFloat?,
        cornerRadius: CGFloat
    ) {
        self.metaData = metaData
        self.type = type
        self.backgroundColor = backgroundColor
        self.primaryFontColor = primaryFontColor
        self.secondaryFontColor = secondaryFontColor
        self.titleLineLimit = titleLineLimit
        self.maxWidth = maxWidth
        self.cornerRadius = cornerRadius
    }

    // MARK: Internal

    let metaData: LPLinkMetadata
    let type: LinkPreviewType

    var body: some View {
        Group {
            switch type {
            case .small:
                smallType
            case .large:
                largeType
            case .auto:
                largeType
            }
        }
        .onAppear {
            getIcon()
            getImage()
        }
    }

    @ViewBuilder
    var smallType: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                if let title = metaData.title {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(primaryFontColor)
                        .lineLimit(titleLineLimit)
                }

                if let url = metaData.url?.host {
                    Text("\(url)")
                        .foregroundColor(secondaryFontColor)
                        .font(.footnote)
                }
            }

            if let image {
                img(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            } else {
                Image(systemName: "arrow.up.forward.app.fill")
                    .resizable()
                    .foregroundColor(secondaryFontColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    @ViewBuilder
    var largeType: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let image {
                ZStack(alignment: .bottomTrailing) {
                    img(image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: maxWidth)
                        .clipped()
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    if let title = metaData.title {
                        HStack(spacing: 4) {
                            if let icon {
                                img(icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 11, height: 11, alignment: .center)
                                    .cornerRadius(2)
                            }
                            Text(title)
                                .font(.system(size: 11, weight: .light))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(primaryFontColor)
                                .lineLimit(titleLineLimit)
                        }
                    }

                    if let url = metaData.url?.host {
                        Text("\(url)")
                            .foregroundColor(secondaryFontColor)
                            .font(.footnote)
                            .padding(.leading, icon == nil ? 0 : 15)
                    }
                }

                if image == nil {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .resizable()
                        .foregroundColor(secondaryFontColor)
                        .scaledToFit()
                        .frame(width: 24, height: 24, alignment: .center)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(backgroundColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    func getImage() {
        metaData.imageProvider?.loadFileRepresentation(
            forTypeIdentifier: UTType.image.identifier,
            completionHandler: { url, imageProviderError in
                if imageProviderError != nil {}
                guard let data = url?.path else { return }
                image = XImage(contentsOfFile: data)
            }
        )
    }

    func getIcon() {
        metaData.iconProvider?.loadFileRepresentation(
            forTypeIdentifier: UTType.image.identifier,
            completionHandler: { url, imageProviderError in
                if imageProviderError != nil {}
                guard let data = url?.path else { return }
                icon = XImage(contentsOfFile: data)
            }
        )
    }

    // MARK: Private

    @State private var image: XImage? = nil
    @State private var icon: XImage? = nil
    @State private var isPresented = false

    private let backgroundColor: Color
    private let primaryFontColor: Color
    private let secondaryFontColor: Color
    private let titleLineLimit: Int
    private let maxWidth: CGFloat?
    private let cornerRadius: CGFloat
}

// MARK: - LinkPreviewType

public enum LinkPreviewType {
    case small
    case large
    case auto
}
