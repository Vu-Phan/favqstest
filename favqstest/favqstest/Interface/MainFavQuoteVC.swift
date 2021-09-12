//
//  MainFavQuoteVC.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import UIKit

class MainFavQuoteVC: AppNavigationVC {
    // MARK: Xib
    var tableView: UITableView!
    // MARK: UI
    var userNavBar: MainFavQuoteUserNavBarView!
    // MARK: Data
    var quoteTableData: [QuoteM] = []
    var isServiceLoading = false
    var servicePage = 0
    var isLastServicePage = false
    var isFirstLoad = true
    
    // MARK: - View Controller
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupData()
        getUserFavoriteQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.layoutIfNeeded()
        navigationBar.updateExpandHeight(userNavBar.pr_height)
        navigationBar.displayExpandBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - UI
    private func setupNavigationBar() {
        navigationBar.setupLeftAction(icon: .refresh)
        navigationBar.onLeftActionTap = {
            self.refreshFromStart()
        }
        navigationBar.setupRightAction(icon: .logout)
        navigationBar.onRightActionTap = {
            self.logout()
        }
        
        userNavBar = MainFavQuoteUserNavBarView.init(inView: navigationBar.expandContentView)
        
        var pictureUrl = ""
        var login = "Unknown"
        var favoriteCount = 0
        if let user = App.shared.user {
            login = user.login
            pictureUrl = user.pictureUrl
            favoriteCount = user.publicFavoritesCount
        }
        navigationBar.setupTitle("Welcome \(login)")
        userNavBar.setup(pictureUrl: pictureUrl, login: login, favoriteCount: favoriteCount)
    }
    
    private func setupUI() {
        tableView = UITableView.init(in: containerView)
        tableView.snpEdges()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainFavQuoteTVCell.self, forCellReuseIdentifier: "myReusableCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
    }
    
    
    // MARK: - Data
    private func setupData() {
        var quote = QuoteM()
        quote.body = "No Favorite Quote Found"
        quote.author = ""
        quoteTableData = [quote]
        
        self.tableView.reloadData()
    }
    
    private func refreshFromStart() {
        servicePage = 0
        getUserFavoriteQuote()
    }
    
    private func getUserFavoriteQuote(more: Bool = false) {
        if let login = App.shared.isLoginSessionExist(), !isLastServicePage && !isServiceLoading {
            isServiceLoading = true
            ServiceFavqs.shared.getUserFavoriteQuotes(login: login, page: servicePage + 1, done: { (quotes, page, isLastPage) in
                self.servicePage = page
                self.isLastServicePage = isLastPage
                if more {
                    self.quoteTableData.append(contentsOf: quotes)
                } else {
                    self.quoteTableData = quotes
                }
                
                self.isServiceLoading = false
                
                self.tableView.reloadData()
            })
        }
    }
    
    private func logout() {
        ServiceFavqs.shared.logout()
        pr_closeVC()
    }
}

// MARK: - UI Table View Delegate / Data Source
extension MainFavQuoteVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myReusableCell", for: indexPath)  as! MainFavQuoteTVCell
        
        let quote = quoteTableData[indexPath.row]
        cell.setup(fromQuote: quote)
        
        if indexPath.row == self.quoteTableData.count - 1 {
            getUserFavoriteQuote(more: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: + Scroll View
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationBar.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationBar.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        navigationBar.scrollViewDidEndDragging(scrollView)
    }
}

