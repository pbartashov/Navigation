//
//  PostsViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 03.09.2022.
//

import UIKit
import StorageService
import iOSIntPackage

struct PostSectionType: RawRepresentable, Hashable {
    let rawValue: String
}

extension PostSectionType {
    static let posts = PostSectionType(rawValue: "posts")
}

class PostsViewController<ViewModelType: PostsViewModelProtocol>: UIViewController {

    typealias SectionType = PostSectionType

    //MARK: - Properties

    private(set) var viewModel: ViewModelType

    var postsSectionNumber = 0
    private var currentColorFilter: ColorFilter? {
        didSet {
            for (i, post) in viewModel.posts.enumerated() {
                let indexPath = IndexPath(row: i, section: postsSectionNumber)
                if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                    cell.setup(with: post, filter: currentColorFilter)
                }
            }
        }
    }
    
    private lazy var postsDataSource: UITableViewDiffableDataSource<PostSectionType, Post> = {
        let tableViewDataSource = UITableViewDiffableDataSource<PostSectionType, Post>(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, post) -> UITableViewCell? in
                return self?.getPostCell(indexPath: indexPath, post: post)
            })

        return tableViewDataSource
    }()

    private var postsSnapshot: NSDiffableDataSourceSnapshot<PostSectionType, Post> {
        var snapshot = NSDiffableDataSourceSnapshot<PostSectionType, Post>()
        snapshot.appendSections(postSections)
        snapshot.appendItems(postItems)

        return snapshot
    }

    var postSections: [PostSectionType] {
        [PostSectionType.posts]
    }

    var postItems: [Post] {
        viewModel.posts
    }

    //MARK: - Views

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)
#if DEBUG
        tableView.backgroundColor = .systemTeal
#else
        tableView.backgroundColor = .systemOrange
#endif
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTap)

        return tableView
    }()

    private lazy var colorFilterSelecor: UISegmentedControl = {
        let off = UIAction(title: "Выкл") { _ in self.currentColorFilter = nil }
        let chrome = UIAction(title: "Нуар") { _ in self.currentColorFilter = .noir }
        let motionBlur = UIAction(title: "Размытие") { _ in
            self.currentColorFilter = .motionBlur(radius: 10)
        }
        let fade = UIAction(title: "Инверсия") { _ in self.currentColorFilter = .colorInvert }

        let control = UISegmentedControl(items: [off,
                                                 chrome,
                                                 motionBlur,
                                                 fade])
        control.selectedSegmentIndex = 0

        return control
    }()

    private var cancelSearchBarItem: UIBarButtonItem?

    //MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        view.addSubview(colorFilterSelecor)
        view.addSubview(tableView)

        setupLayout()
        setupViewModel()
        setupBarItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.perfomAction(.requstPosts)
    }

    //MARK: - Metods

    private func setupViewModel() {
        viewModel.stateChanged = { state in
            DispatchQueue.main.async { [weak self] in
                switch state {
                    case .initial:
                        break

                    case .loaded(_):
                        self?.applySnapshot()

                    case .isFiltered(let text):
                        if let text = text {
                            self?.cancelSearchBarItem?.isEnabled = true
                            self?.navigationItem.title = "Найдено для: \(text)"
                        } else {
                            self?.cancelSearchBarItem?.isEnabled = false
                            self?.navigationItem.title = nil
                        }


//                        if flag {
//                            self?.tableView.setNoDataPlaceholder("Ничего не нашли...🤷")
//                        } else {
//                            self?.tableView.removeNoDataPlaceholder()
//                        }
                }
            }
        }
    }

    private func setupLayout() {
        colorFilterSelecor.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(colorFilterSelecor.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupBarItems() {
        let searchAction = UIAction { [weak self] _ in
            self?.viewModel.perfomAction(.showSearchPromt)
        }

        let searchItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                          primaryAction: searchAction)

        let clearAction = UIAction { [weak self] _ in
            self?.viewModel.perfomAction(.cancelSearch)
        }

        let cancelSearchItem = UIBarButtonItem(image: UIImage(systemName: "return"),
                                         primaryAction: clearAction)
        cancelSearchItem.isEnabled = false

        navigationItem.setRightBarButtonItems([cancelSearchItem, searchItem], animated: false)
        cancelSearchBarItem = cancelSearchItem
    }

    func getPostCell(indexPath: IndexPath, post: Post) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                 for: indexPath)
        as! PostTableViewCell

        cell.setup(with: post,
                   filter: self.currentColorFilter)
        return cell
    }

    func applySnapshot() {
        postsDataSource.apply(postsSnapshot)
    }

    @objc func handleDoubleTap(recognizer: UIGestureRecognizer) {
        let tappedPoint = recognizer.location(in: tableView)

        if let indexPath = tableView.indexPathForRow(at: tappedPoint) {
            tableView.deselectRow(at: indexPath, animated: true)

            let post = viewModel.posts[indexPath.row]
            viewModel.perfomAction(.selected(post: post))
        }
    }
}

//https://blog.kulman.sk/simple-bindable-no-data-placeholder/
//extension UITableView {
//    func setNoDataPlaceholder(_ message: String) {
//        let label = UILabel(frame: CGRect(x: 0,
//                                          y: 0,
//                                          width: self.bounds.size.width,
//                                          height: 100))
//        label.text = message
//        // styling
//        label.sizeToFit()
//
//        self.isScrollEnabled = false
//        self.backgroundView = label
//        self.separatorStyle = .none
//    }
//
//    func removeNoDataPlaceholder() {
//        self.isScrollEnabled = true
//        self.backgroundView = nil
//        self.separatorStyle = .singleLine
//    }
//
//}
