//
//  InfoViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

import UIKit

final class InfoViewController: UIViewController {

    // MARK: - Properties

    var viewModel = InfoViewModel(state: .initial)

    // MARK: - Views

    private lazy var infoView: InfoView = {
        $0.delegate = self
        $0.dataSource = self

        return $0
    }(InfoView())

    // MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemOrange
        view.addSubview(infoView)

        setupLayout()
        setupViewModel()

        viewModel.perfomAction(.requestData)
        viewModel.perfomAction(.requestPlanet)
    }

    //MARK: - Metods

    private func setupLayout() {
        infoView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupViewModel() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .initial:
                        self?.infoView.updateTitle(with: nil)
                        fallthrough

                    case .loadingPlanet:
                        self?.infoView.updatePlanet(with: nil)
                        fallthrough

                    case .loadingResidents:
                        self?.infoView.updateResidents(with: nil)
                        self?.infoView.isLoading = true

                    case .loadedInfo(let info):
                        self?.infoView.updateTitle(with: info.title)

                    case .loadedPlanet(let planet):
                        self?.infoView.updatePlanet(with: planet)

                    case let .loadedResidents(residents):
                        self?.infoView.updateResidents(with: residents)

                    case .loadingPlanetCompleted:
                        self?.infoView.isLoading = false
                }
            }
        }
    }
}

// MARK: - Table view data source
extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.residents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = viewModel.residents[indexPath.row].name

        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - Table view delegate
extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Info view delegate
extension InfoViewController: InfoViewDelegate {
    func reloadData() {
        viewModel.perfomAction(.reloadData)
    }
}
