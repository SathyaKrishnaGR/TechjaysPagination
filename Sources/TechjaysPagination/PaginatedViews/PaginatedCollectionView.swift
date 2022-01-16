//
//  PaginatedCollectionView.swift
//  Fayvit
//
//  Created by Sharran M on 02/10/20.
//  Copyright © 2020 Iderize. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol PaginatedCollectionViewDelegate {
    func paginatedCollectionView(paginationEndpointFor collectionView: UICollectionView) -> PaginationUrl
    func paginatedCollectionView(_ collectionView: UICollectionView, paginateTo url: String, isFirstPage: Bool, afterPagination hasNext: @escaping(_ hasNext: Bool) -> Void)
    func paginatedCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func paginatedCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    @objc optional func paginatedCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc optional func paginatedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    @objc optional func paginatedCollectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    @objc optional func paginatedCollectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    @objc optional func paginationScrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func paginationScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func paginationScrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func paginationScrollViewDidScroll(_ scrollView: UIScrollView)
}

public class PaginatedCollectionView: UICollectionView {
    @IBOutlet open weak var paginationDelegate: PaginatedCollectionViewDelegate! {
        didSet { paginationManager = PaginationManager(delegate: paginationDelegate, collectionView: self) }
    }
    private var paginationManager: PaginationManager!
    private var dataCount = 0
    private var hasNext = false
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    /// Fetch data from server from the given offset with default fetch limit.
    /// - Parameter from: offset of the api data
    func fetchData(from offset: Int = 0) {
        isLoading = true
        paginationManager.paginate(to: offset) { (hasNext) in
            self.isLoading = false
            self.hasNext = hasNext
        }
    }
}

extension PaginatedCollectionView: UICollectionViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        paginationDelegate.paginationScrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        paginationDelegate.paginationScrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        paginationDelegate.paginationScrollViewDidEndDecelerating?(scrollView)
    }
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        paginationDelegate.paginationScrollViewDidScroll?(scrollView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        paginationDelegate.paginatedCollectionView?(collectionView, didSelectItemAt: indexPath)
    }
}

extension PaginatedCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataCount = paginationDelegate.paginatedCollectionView(collectionView, numberOfItemsInSection: section)
        return dataCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return paginationDelegate.paginatedCollectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionFooterSpinner.identifier, for: indexPath)
            return footer
        }
        return UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == dataCount - 1, !isLoading, hasNext {
            fetchData(from: dataCount)
        }
        
        paginationDelegate.paginatedCollectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        paginationDelegate.paginatedCollectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
}

extension PaginatedCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return paginationDelegate.paginatedCollectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

extension PaginatedCollectionView {
    var isLoading: Bool {
        get {
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize.equalTo(CollectionFooterSpinner.size) ?? false
        }
        set {
            if newValue {
                DispatchQueue.main.async {
                    (self.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CollectionFooterSpinner.size
                }
            } else {
                DispatchQueue.main.async {
                    (self.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = .zero
                }
            }
        }
    }
    
    fileprivate func commonInit() {
        delegate = self
        dataSource = self
        register(
            CollectionFooterSpinner.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: CollectionFooterSpinner.identifier
        )
    }
}

public class CollectionFooterSpinner: UICollectionReusableView {
    static let identifier = "Footer"
    static let size = CGSize(width: 50, height: 50)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let footerSpinner = UIActivityIndicatorView(style: .medium)
        footerSpinner.startAnimating()
        footerSpinner.center = self.center
        addSubview(footerSpinner)
    }
}
