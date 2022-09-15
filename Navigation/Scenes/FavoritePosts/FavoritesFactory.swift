//
//  FavoritesFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 02.09.2022.
//

import UIKit
import StorageService

struct FavoritesFactory {

    //MARK: - Properties

    static var create = FavoritesFactory()

    //MARK: - Metods

    func viewModelWith(coordinator: PostsCoordinator?) -> FavoritesViewModel {
        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)

        return FavoritesViewModel(postRepository: postRepository, coordinator: coordinator)
    }

    func viewControllerWith(viewModel: FavoritesViewModel) -> UIViewController {
        FavoritesViewController(viewModel: viewModel)
    }
}
