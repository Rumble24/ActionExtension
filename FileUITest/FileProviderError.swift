//
//  FileProviderEnumerator.swift
//  FileUITest
//
//  Created by SHAREit on 2022/1/20.
//

import Foundation

enum FileProviderError: Error {
  case unableToFindMetadataForPlaceholder
  case unableToFindMetadataForItem
  case notAContainer
  case unableToAccessSecurityScopedResource
  case invalidParentItem
  case noContentFromServer
}
