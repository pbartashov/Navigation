//
//  PostsViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 04.09.2022.
//

import StorageService

enum PostsAction {
    case requstPosts
    case selected(post: Post)
    case deletePost(at: IndexPath)
    case showSearchPromt
    case cancelSearch
    case showError(Error)
}

enum PostsState {
    case initial
    case loaded([Post])
    case isFiltered(with: String?)
}

protocol PostsViewModelProtocol: ViewModelProtocol
where State == PostsState,
      Action == PostsAction {

    var posts: [Post] { get set }
    var onPostSelected: ((Post) -> Void)? { get set }
    var requstPosts: (() -> Void)? { get set }
    var deletePost: ((IndexPath) -> Void)? { get set }
    var searchText: String? { get }
}

class PostsViewModel: ViewModel<PostsState, PostsAction>,
                      PostsViewModelProtocol {

    //MARK: - Properties

    private weak var coordinator: PostsCoordinator?

    var posts: [Post] = [] {
        didSet {
            state = .loaded(posts)
            if searchText != nil, posts.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    self?.showRetrySearch()
                }
            }
        }
    }
    
    private(set) var searchText: String?

    var onPostSelected: ((Post) -> Void)?
    var requstPosts: (() -> Void)?
    var deletePost: ((IndexPath) -> Void)?

    //MARK: - LifeCicle

    init(coordinator: PostsCoordinator?) {
        self.coordinator = coordinator
        super.init(state: .initial)
    }

    //MARK: - Metods

    override func perfomAction(_ action: PostsAction) {
        switch action {
            case .requstPosts:
                requstPosts?()

            case .showSearchPromt:
                coordinator?.showSearchPrompt(title: "searchPromptTitlePostsViewModel".localized,
                                              searchComletion: { [weak self] text in
                    self?.handleSearch(with: text)
                })

            case .cancelSearch:
                searchText = nil
                state = .isFiltered(with: nil)
                requstPosts?()

            case .selected(let post):
                onPostSelected?(post)

            case .deletePost(let indexPath):
                deletePost?(indexPath)

            case .showError(let error):
                ErrorPresenter.shared.show(error: error)
        }
    }

    private func handleSearch(with text: String) {
        searchText = text
        state = .isFiltered(with: text)
        requstPosts?()
    }

    private func showRetrySearch() {
        coordinator?.showSearchPrompt(title: "retryPromptTitlePostsViewModel".localized,
                                      message: "retryPromptMessagePostsViewModel".localized,
                                      text: searchText,
                                      searchComletion: { [weak self] text in
            self?.handleSearch(with: text)
        },
                                      cancelComletion: { [weak self] in
            self?.perfomAction(.cancelSearch)
        })
    }
}
