//
//  InfoViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

import UIKit

final class InfoViewController: UIViewController {

    //MARK: - Properties

    private lazy var buttonShowQuestion: ClosureBasedButton = {
        let button = ClosureBasedButton(title: "Показать вопрос",
                                        titleColor: .black,
                                        tapAction:  { [weak self] in self?.buttonTapped() })

        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = self.view.center
        button.tintColor = .black

        return button
    }()

    //MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemOrange

        view.addSubview(buttonShowQuestion)
    }

    //MARK: - Metods

    func buttonTapped() {

        let alert = UIAlertController(title: "Сохранить изменения?",
                                      message: "Все несохраненные изменения будут утеряны",
                                      preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Сохранить",
                                       style: .default,
                                       handler: {_ in
            print("Сохраняем...")
        })

        let cancelAction = UIAlertAction(title: "Отмена",
                                       style: .cancel,
                                       handler: {_ in
            print("Отмена")
        })

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}
