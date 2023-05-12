//
//  SwiftUIView.swift
//
//
//  Created by 이웅재 on 2021/12/08.
//

import SafariServices
import SwiftUI

#if os(iOS)
    import UIKit

    struct SFSafariView: UIViewControllerRepresentable {
        let url: URL

        func makeUIViewController(context: UIViewControllerRepresentableContext<SfSafariView>) -> SFSafariViewController {
            SFSafariViewController(url: url)
        }

        func updateUIViewController(
            _ uiViewController: SFSafariViewController,
            context: UIViewControllerRepresentableContext<SfSafariView>
        ) {}
    }
#endif
