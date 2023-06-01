//
//  ViewController.swift
//  News
//
//  Created by Kadir Yılmaz on 25.05.2023.
//

import UIKit
import SafariServices

class MainVC: UIViewController {

    private var cellViewModels = [NewsTableViewCellViewModel]()
    private var newsViewModel = NewsViewModel()
    private var articles = [Article]()
    var menuTitles = [String]()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let menuView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reusableId)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.delegate = self
        tableView.dataSource = self
        
        menuTitles = newsViewModel.getMenuTitles()

        configure()
        createMenuButtons()
        
        if let topButton = menuView.arrangedSubviews.first as? UIButton {
            topButton.isSelected = true
            topButton.setTitleColor(.systemBlue, for: .normal)
        }
        
        fetchStories(for: "Top")
    }
    
    private func configure() {
        view.addSubview(scrollView)
        scrollView.addSubview(menuView)
        view.addSubview(tableView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 50),
            
            menuView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            menuView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            menuView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            menuView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            menuView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    private func createMenuButtons() {
        for (index, title) in menuTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            button.setTitleColor(.label, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            menuView.addArrangedSubview(button)
        }
    }


    @objc private func menuButtonTapped(_ sender: UIButton) {
        let selectedTitle = menuTitles[sender.tag]

        if let previousSelectedButton = menuView.arrangedSubviews.first(where: { ($0 as? UIButton)?.isSelected == true }) as? UIButton {
            previousSelectedButton.isSelected = false
            previousSelectedButton.setTitleColor(.label, for: .normal)
        }
        sender.isSelected = true
        sender.setTitleColor(.systemBlue, for: .normal)

        fetchStories(for: selectedTitle)
    }

    private func fetchStories(for topic: String) {
        WebService.shared.getTopStories(for: topic) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.cellViewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? ""))
                })

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reusableId, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }

        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]

        guard let urlString = article.url, let url = URL(string: urlString) else {
            return
        }

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let heightForRow = screenHeight * 0.2
        return heightForRow
    }
}
