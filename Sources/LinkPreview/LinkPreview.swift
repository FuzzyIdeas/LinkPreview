import LinkPresentation
import SwiftUI

// MARK: - LinkPreview

public struct LinkPreview: View {
    // MARK: Lifecycle

    public init(url: URL?) {
        self.url = url
    }

    // MARK: Public

    public var body: some View {
        if let url {
            if let metaData = metaData ?? (try? cache.object(forKey: url.absoluteString))?.lpLinkMetadata {
                Button(action: {
                    openURL(url)
                }, label: {
                    LinkPreviewDesign(
                        metaData: metaData,
                        type: type,
                        backgroundColor: backgroundColor,
                        primaryFontColor: primaryFontColor,
                        secondaryFontColor: secondaryFontColor,
                        titleLineLimit: titleLineLimit
                    )
                })
                .buttonStyle(LinkButton())
                #if os(iOS)
                    .fullScreenCover(isPresented: $isPresented) {
                        SFSafariView(url: url)
                            .edgesIgnoringSafeArea(.all)
                    }
                #endif
                    .animation(.spring(), value: metaData)
            } else {
                HStack(spacing: 10) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: secondaryFontColor))

                    Text(url.host ?? "")
                        .font(.caption)
                        .foregroundColor(primaryFontColor)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule().foregroundColor(backgroundColor)
                )
                .onAppear {
                    getMetaData(url: url)
                }
                .onTapGesture {
                    openURL(url)
                }
                #if os(iOS)
                .fullScreenCover(isPresented: $isPresented) {
                    SFSafariView(url: url)
                        .edgesIgnoringSafeArea(.all)
                }
                #endif
            }
        }
    }

    // MARK: Internal

    let url: URL?

    var backgroundColor = Color.gray.opacity(0.5)
    var primaryFontColor: Color = .primary
    var secondaryFontColor: Color = .secondary
    var titleLineLimit = 3
    var type: LinkPreviewType = .auto

    func openURL(_ url: URL) {
        #if os(iOS)
            if UIApplication.shared.canOpenURL(url) {
                isPresented.toggle()
            }
        #else
            NSWorkspace.shared.open(url)
        #endif
    }

    func getMetaData(url: URL) {
        if let meta = (try? cache.object(forKey: url.absoluteString))?.lpLinkMetadata {
            withAnimation(.spring()) {
                metaData = meta
            }
            return
        }

        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { meta, err in
            guard let meta else { return }
            try? cache.setObject(meta.codable, forKey: url.absoluteString)
            withAnimation(.spring()) {
                metaData = meta
            }
        }
    }

    // MARK: Private

    @State private var isPresented = false
    @State private var metaData: LPLinkMetadata? = nil
}

extension LPLinkMetadata {
    var codable: LinkMetadata { LinkMetadata(self) }
}

// MARK: - LinkMetadata

class LinkMetadata: Codable {
    // MARK: Lifecycle

    init(_ meta: LPLinkMetadata) {
        lpLinkMetadata = meta
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)

        lpLinkMetadata = try (NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data))!
    }

    // MARK: Public

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(NSKeyedArchiver.archivedData(withRootObject: lpLinkMetadata, requiringSecureCoding: true))
    }

    // MARK: Internal

    let lpLinkMetadata: LPLinkMetadata
}

import Cache

let diskConfig = DiskConfig(name: "URLCache")
let memoryConfig = MemoryConfig(expiry: .seconds(60 * 60 * 1000), countLimit: 1000, totalCostLimit: 1000)

let cache = try! Storage<String, LinkMetadata>(
    diskConfig: diskConfig,
    memoryConfig: memoryConfig,
    transformer: TransformerFactory.forCodable(ofType: LinkMetadata.self)
)

// MARK: - LinkButton

struct LinkButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}
