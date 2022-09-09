//
//  PostsCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 07.09.2022.
//

import UIKit

final class PostsCoordinator: NavigationCoordinator {

    //MARK: - Metods

    func showSearchPrompt(title: String,
                          message: String? = nil,
                          text: String? = nil,
                          searchComletion: ((String) -> Void)? = nil,
                          cancelComletion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        var searchTextField: UITextField?
        alert.addTextField { textField in
            if let text = text {
                textField.text = text
            } else {
                textField.placeholder = "Имя автора"
            }
            
            searchTextField = textField
        }

        let search = UIAlertAction(title: "Искать", style: .default) { _ in
            if let searchText = searchTextField?.text,
               !searchText.isEmpty {
                searchComletion?(searchText)
            }
        }
        alert.addAction(search)

        if cancelComletion != nil {
            let cancel = UIAlertAction(title: "Отменить поиск", style: .default) { _ in
                cancelComletion?()
            }
            alert.addAction(cancel)
        }

        navigationController?.present(alert, animated: true)
    }
}
