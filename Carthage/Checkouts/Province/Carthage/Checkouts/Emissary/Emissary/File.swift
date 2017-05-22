//
//  File.swift
//  Emissary
//
//  Created by Jordan Kay on 9/20/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

import MobileCoreServices

public extension URL {
    var mimeType: String? {
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(), !pathExtension.isEmpty else {
            return nil
        }
        
        guard let
            mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() else {
            return nil
        }
        return mimeType as String
    }
}
