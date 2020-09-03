//
//  ItemsCollectionViewController.swift
//  Gente3
//
//  Created by Serge Gainsbourg on 9/2/20.
//  Copyright © 2020 IKSong. All rights reserved.
//

import UIKit
import Combine

protocol CollectionContentConfigurable {
    func configure(content: inout UIListContentConfiguration)
}

class ItemsCollectionViewController<Item>: UICollectionViewController where Item: Hashable & Codable & CollectionContentConfigurable {
    var items = [Item]() {
        didSet {
            applySnapshot()
        }
    }

    var resource: Resource<[Item]>?
    private var fetchCancellable: AnyCancellable?
    
    init(items: [Item], resource: Resource<[Item]>?) {
        self.items = items
        self.resource = resource
        
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .systemPurple
        
        super.init(collectionViewLayout: UICollectionViewCompositionalLayout.list(using: config))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum Section: CaseIterable {
        case main
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, _, item in
            var content = cell.defaultContentConfiguration()
            item.configure(content: &content)
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)

            content.image = UIImage(systemName: "person.circle")
            content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)

            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
            cell.tintColor = .systemPurple
        }

        return UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, country) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: country)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadResource(resource)
    }
    
    func loadResource(_ resource: Resource<[Item]>?) {
        guard let resource = resource, items.isEmpty else {
            return
        }

        transition(to: LoadingViewController()) { _ in
            self.fetchCancellable = URLSession.shared.dataTaskPublisher(for: resource.urlRequest)
                .map { data, response in
                    resource.parse(data)
                }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { items in
                    self.popTopView()
                    if let items = items {
                        self.items = items
                    } else {
                        let messageVC = MessageViewController(message: "Something went wrong")
                        messageVC.delegate = self
                        self.transition(to: messageVC)
                    }
                }
        }

    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension ItemsCollectionViewController: MessageViewControllerDelegate {
    func messageViewControllerActionButtonWasTapped(_ messageVC: MessageViewController) {
        loadResource(resource)
    }
}
