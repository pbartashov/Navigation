//
//  InfoView.swift
//  Navigation
//
//  Created by Павел Барташов on 31.07.2022.
//

import UIKit

protocol InfoViewDelegate {
    func reloadData()
}

final class InfoView: UIView {

    // MARK: - Properties
    weak var delegate: (UITableViewDelegate&InfoViewDelegate)? {
        didSet {
            tableView.delegate = delegate
        }
    }

    var dataSource: UITableViewDataSource? {
        get {
            tableView.dataSource
        }
        set {
            tableView.dataSource = newValue
        }
    }

    var isLoading: Bool = false {
        didSet {
            isLoading ? tableView.refreshControl?.beginRefreshing() : tableView.refreshControl?.endRefreshing()
        }
    }

    private var planetResidentsLabelText: String = "Ожидание данных..." {
        didSet {
            planetResidentsLabel.text = planetResidentsLabelText
        }
    }

    // MARK: - Views

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center

        return label
    }()

    private let planetOrbitalPeriodLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0

        return label
    }()

    private let planetResidentsLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = " "

        label.layer.cornerRadius = Constants.padding / 2
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)

        tableView.layer.cornerRadius = Constants.padding / 2
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                            for: .valueChanged)
        return tableView
    }()

    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metods

    private func initialize() {
        addSubviews(titleLabel,
                    planetOrbitalPeriodLabel,
                    planetResidentsLabel,
                    tableView)

        setupLayouts()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Constants.padding)
        }

        planetOrbitalPeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.padding)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }

        planetResidentsLabel.snp.makeConstraints { make in
            make.top.equalTo(planetOrbitalPeriodLabel.snp.bottom).offset(Constants.padding)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(planetResidentsLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(Constants.padding)
        }
    }

    func updateTitle(with text: String?) {
        if let text = text {
            titleLabel.text = "Title: \(text)"
        } else {
            titleLabel.text = nil
        }
    }

    func updatePlanet(with planet: PlanetModel?) {
        if let planet = planet {
            planetOrbitalPeriodLabel.text = "Период обращения планеты \(planet.name) вокруг своей звезды = \(planet.orbitalPeriod)"
            planetResidentsLabelText = "Жители планеты \(planet.name):"
        } else {
            planetOrbitalPeriodLabel.text = nil
            planetResidentsLabelText = "Ожидание данных..."
        }
    }

    func updateResidents(with residents: [Person]?) {
        if let residents = residents {
            planetResidentsLabel.text = "\(planetResidentsLabelText) (\(residents.count)):"
        }
        tableView.reloadData()
    }

    @objc func handleRefreshControl() {
        delegate?.reloadData()
    }
}
