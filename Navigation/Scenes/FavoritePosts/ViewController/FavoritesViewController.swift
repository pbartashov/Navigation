//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.09.2022.
//

import UIKit
import StorageService

final class FavoritesViewController<T>: PostsViewController<T>,
                                        UITableViewDelegate where T: FavoritesViewModel {
    //MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }

    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            guard let post = self?.postItems[indexPath.row] else { return }
            self?.viewModel.perfomAction(.delete(post: post))

            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])

        return configuration
    }
}
