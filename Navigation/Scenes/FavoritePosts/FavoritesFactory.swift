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

    func viewModelWith() -> FavoritesViewModel {
        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.viewContext)

        return FavoritesViewModel(postRepository: postRepository)
    }

    func viewControllerWith(viewModel: FavoritesViewModel) -> UIViewController {
        PostsViewController(viewModel: viewModel)
    }
}
