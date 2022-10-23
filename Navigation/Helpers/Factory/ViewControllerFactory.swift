//
//  ViewControllerFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 18.06.2022.
//

import UIKit

struct ViewControllerFactory {
    
    //MARK: - Properties
    
    static var create = ViewControllerFactory()
    
    //MARK: - Metods
    
    func tabBarController(with viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray6
        
        tabBarController.setViewControllers(viewControllers, animated: true)
        
        tabBarController.selectedIndex = 1
        
        return tabBarController
    }
    
    func feedViewController(tag: Int) -> FeedViewController {
        let feedViewController = FeedViewController(model: FeedViewControllerModel())
        feedViewController.tabBarItem = UITabBarItem(title: "feedViewControllerFactory".localized,
                                                     image: UIImage(systemName: "house.fill"),
                                                     tag: tag)
        return feedViewController
    }
    
    func loginViewController(loginDelegate: LoginDelegate, coordinator: LoginCoordinator, tag: Int) -> UIViewController {
        let loginViewModel = LoginFactory().viewModelWith(loginDelegate: loginDelegate,
                                                          coordinator: coordinator)
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.tabBarItem = UITabBarItem(title: "profileViewControllerFactory".localized,
                                                      image: UIImage(systemName: "person.fill"),
                                                      tag: tag)
        return loginViewController
    }
    
    func musicViewController(tag: Int) -> UIViewController {
        let musicStorage = MusicStorage(collection: MusicStorage.demoMusicTracks)
        let musicPlayer = MusicPlayer()
        
        let musicViewModel = MusicViewModel(storage: musicStorage, player: musicPlayer)
        
        let musicViewController = MusicViewController(viewModel: musicViewModel)
        musicViewController.tabBarItem = UITabBarItem(title: "musicViewControllerFactory".localized,
                                                      image: UIImage(systemName: "music.note"),
                                                      tag: tag)
        return musicViewController
    }
    
    func videoViewController(tag: Int) -> UIViewController {
        let videoViewController = VideoViewController(viewModel: VideoTrack.demoVideos)
        videoViewController.tabBarItem = UITabBarItem(title: "videoViewControllerFactory".localized,
                                                      image: UIImage(systemName: "film"),
                                                      tag: tag)
        return videoViewController
    }
    
    func recorderViewController(tag: Int) -> UIViewController {
        let recorder = AudioRecorder()
        let player = MusicPlayer()
        
        let viewModel = RecorderViewModel(recorder: recorder, player: player)
        
        let recorderViewController = RecorderViewController(viewModel: viewModel)
        
        recorderViewController.tabBarItem = UITabBarItem(title: "recorderViewControllerFactory".localized,
                                                         image: UIImage(systemName: "recordingtape"),
                                                         tag: tag)
        return recorderViewController
    }
    
    func profileViewController(userName: String,
                               profileCoordinator: ProfileCoordinator?,
                               profilePostsCoordinator: PostsCoordinator?,
                               tag: Int
    ) -> UIViewController {
        let profileViewModel = ProfileFactory.create.viewModelWith(profileCoordinator: profileCoordinator,
                                                                   postsCoordinator: profilePostsCoordinator,
                                                                   userName: userName)
        let profileViewController = ProfileFactory.create.viewControllerWith(viewModel: profileViewModel)
        
        profileViewController.tabBarItem = UITabBarItem(title: "profileViewControllerFactory".localized,
                                                        image: UIImage(systemName: "person.fill"),
                                                        tag: tag)
        return profileViewController
    }
    
    func favoritesViewController(coordinator: PostsCoordinator?, tag: Int) -> UIViewController {
        let favoritesViewModel = FavoritesFactory.create.viewModelWith(coordinator: coordinator)
        let favoritesViewController = FavoritesFactory.create.viewControllerWith(viewModel: favoritesViewModel)
        
        favoritesViewController.tabBarItem = UITabBarItem(title: "favoritesViewControllerFactory".localized,
                                                          image: UIImage(systemName: "heart.fill"),
                                                          tag: tag)
        return favoritesViewController
    }
    
    func mapViewController(tag: Int) -> UIViewController {
        let presenter = MapPresenter()
        let manager = MapManager()
        let viewController = MapViewController(presenter: presenter, manager: manager)
        presenter.view = viewController
        
        viewController.tabBarItem = UITabBarItem(title: "mapViewControllerFactory".localized,
                                                 image: UIImage(systemName: "map.fill"),
                                                 tag: tag)
        return viewController
    }
}
