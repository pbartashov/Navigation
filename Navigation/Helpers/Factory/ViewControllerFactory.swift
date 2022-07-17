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
        feedViewController.tabBarItem = UITabBarItem(title: "Feed",
                                                     image: UIImage(systemName: "house.fill"),
                                                     tag: tag)
        return feedViewController
    }

    func loginViewController(loginDelegate: LoginDelegate, coordinator: LoginCoordinator, tag: Int) -> UIViewController {
        let loginViewModel = LoginFactory().viewModelWith(loginDelegate: loginDelegate,
                                                          coordinator: coordinator)

        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.tabBarItem = UITabBarItem(title: "Profile",
                                                      image: UIImage(systemName: "person.fill"),
                                                      tag: tag)
        return loginViewController
    }

    func musicViewController(tag: Int) -> UIViewController {
        let musicStorage = MusicStorage(collection: MusicStorage.demoMusicTracks)
        let musicPlayer = MusicPlayer()

        let musicViewModel = MusicViewModel(storage: musicStorage, player: musicPlayer)

        let musicViewController = MusicViewController(viewModel: musicViewModel)
        musicViewController.tabBarItem = UITabBarItem(title: "Music",
                                                      image: UIImage(systemName: "music.note"),
                                                      tag: tag)
        return musicViewController
    }

    func videoViewController(tag: Int) -> UIViewController {
        let videoViewController = VideoViewController(viewModel: VideoTrack.demoVideos)
        videoViewController.tabBarItem = UITabBarItem(title: "Video",
                                                      image: UIImage(systemName: "film"),
                                                      tag: tag)
        return videoViewController
    }
    
    func recorderViewController(tag: Int) -> UIViewController {
        let recorder = AudioRecorder()
        let player = MusicPlayer()

        let viewModel = RecorderViewModel(recorder: recorder, player: player)

        let recorderViewController = RecorderViewController(viewModel: viewModel)

        recorderViewController.tabBarItem = UITabBarItem(title: "Recorder",
                                                         image: UIImage(systemName: "recordingtape"),
                                                         tag: tag)
        return recorderViewController
    }
}
