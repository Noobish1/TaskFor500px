import CoreGraphics
import Foundation
import UIKit

// Simplified Swift version of https://github.com/500px/greedo-layout-for-ios
internal final class GreedoCalculator {
    // MARK: properties
    private let rowMaximumHeight: CGFloat
    private let originalSizeForIndexPath: (IndexPath) -> CGSize
    private var sizeCache: [IndexPath: CGSize] = [:]
    
    // MARK: init
    internal init(
        rowMaximumHeight: CGFloat,
        originalSizeForIndexPath: @escaping (IndexPath) -> CGSize
    ) {
        self.rowMaximumHeight = rowMaximumHeight
        self.originalSizeForIndexPath = originalSizeForIndexPath
    }
    
    // MARK: clearing the cache
    internal func clearCache() {
        sizeCache.removeAll()
    }
    
    internal func clearCache(after indexPath: IndexPath) {
        sizeCache.removeValue(forKey: indexPath)
        
        for existingIndexPath in sizeCache.keys where existingIndexPath > indexPath {
            sizeCache.removeValue(forKey: existingIndexPath)
        }
    }
    
    // MARK: computing sizes
    internal func sizeForPhoto(
        at indexPath: IndexPath, collectionView: UICollectionView
    ) -> CGSize {
        if let cachedSize = sizeCache[indexPath] {
            return cachedSize
        } else {
            return computeSizes(at: indexPath, collectionView: collectionView)
        }
    }
    
    private func computeSizes(
        at indexPath: IndexPath, collectionView: UICollectionView
    ) -> CGSize {
        var collectedSizes: [(IndexPath, CGSize)] = []
        let contentWidth = computeContentWidth(for: collectionView)
        let interItemSpacing = computeInterItemSpacing(for: collectionView)
        
        return computeSizes(
            at: indexPath,
            contentWidth: contentWidth,
            interItemSpacing: interItemSpacing,
            collectedSizes: &collectedSizes,
            originalIndexPath: indexPath
        )
    }
    
    private func computeSizes(
        at indexPath: IndexPath,
        contentWidth: CGFloat,
        interItemSpacing: CGFloat,
        collectedSizes: inout [(IndexPath, CGSize)],
        originalIndexPath: IndexPath
    ) -> CGSize {
        collectedSizes.append((indexPath, computeOriginalSize(at: indexPath)))
        
        let rowHeight = computeRowHeight(forLeftOvers: collectedSizes, contentWidth: contentWidth)
        
        if rowHeight < rowMaximumHeight {
            // The line is full!
            var availableSpace = contentWidth
            
            for (indexPath, leftOverSize) in collectedSizes {
                let newWidth = computeNewWidth(
                    forRowHeight: rowHeight, photoSize: leftOverSize, availableSpace: availableSpace
                )
                
                sizeCache[indexPath] = CGSize(width: newWidth, height: rowHeight)
                
                availableSpace -= (newWidth + interItemSpacing)
            }
            
            // swiftlint:disable force_unwrapping
            return sizeCache[originalIndexPath]!
            // swiftlint:enable force_unwrapping
        } else {
            // The line is not full, let's ask the next photo and try to fill up the line
            return computeSizes(
                at: IndexPath(item: indexPath.item + 1, section: indexPath.section),
                contentWidth: contentWidth,
                interItemSpacing: interItemSpacing,
                collectedSizes: &collectedSizes,
                originalIndexPath: originalIndexPath
            )
        }
    }
    
    // MARK: computing parts of the algorithm
    private func computeOriginalSize(at indexPath: IndexPath) -> CGSize {
        var photoSize = originalSizeForIndexPath(indexPath)
        
        if photoSize.width < 1 || photoSize.height < 1 {
            photoSize.width = rowMaximumHeight
            photoSize.height = rowMaximumHeight
        }
        
        return photoSize
    }
    
    private func computeRowHeight(
        forLeftOvers leftOvers: [(IndexPath, CGSize)], contentWidth: CGFloat
    ) -> CGFloat {
        let totalAspectRatio = leftOvers.map { _, size in size.width / size.height }.reduce(0, +)
        
        return contentWidth / totalAspectRatio
    }
    
    private func computeNewWidth(
        forRowHeight rowHeight: CGFloat, photoSize: CGSize, availableSpace: CGFloat
    ) -> CGFloat {
        let newWidth = floor((rowHeight * photoSize.width) / photoSize.height)
        
        return min(availableSpace, newWidth)
    }
    
    private func computeInterItemSpacing(for collectionView: UICollectionView) -> CGFloat {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.minimumInteritemSpacing
        } else {
            return 0
        }
    }
    
    private func computeContentWidth(for collectionView: UICollectionView) -> CGFloat {
        var contentWidth = collectionView.bounds.width
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            contentWidth -= (flowLayout.sectionInset.left + flowLayout.sectionInset.right)
        }
        
        return contentWidth
    }
}
