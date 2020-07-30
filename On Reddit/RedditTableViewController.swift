//
//  RedditTableViewController.swift
//  On Reddit
//
//  Created by Landen 2 Zackery on 7/28/20.
//  Copyright © 2020 stockx. All rights reserved.
//

import Foundation
import UIKit

class RedditTableViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    private var viewModel: RedditTableViewViewModel!
    
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RedditTableViewViewModel(redditStore: RedditStore())
        
        setupActivityView()
        loadReddits()
    }
    
    func setupActivityView() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = view.center
        activityView?.hidesWhenStopped = true
        view.addSubview(activityView ?? UIActivityIndicatorView())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRedditDetailView":
            let detailsVc = segue.destination as! RedditDetailViewController
            detailsVc.selectedReddit = viewModel.getSelectedReddit()
        default:
            preconditionFailure("Unknown segue")
        }
    }
    
    func loadReddits(subRedditTitle: String = "all") {
        activityView?.startAnimating()
        
        viewModel.loadReddits(subRedditTitle: subRedditTitle) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Ooops something went wrong", message: "The reddits couldn't load, try searching for a different topic or all", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.activityView?.stopAnimating()
            }
        }
    }
}

//MARK: - UITableViewDataSource functions
extension RedditTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfReddits()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = viewModel.getRedditTitle(atRow: indexPath.row)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = viewModel.getSubRedditTitle(atRow: indexPath.row)
        
        return cell
        
    }
}

//MARK: - UITableViewDelegate functions
extension RedditTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
            return
        }
        
        viewModel.saveSelectedReddit(atRow: indexPath.row)
        performSegue(withIdentifier: "showRedditDetailView", sender: self)
    }
}

//MARK: - UISearchBarDelegate functions
extension RedditTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard var subRedditTitle = searchBar.text else { return }
        if subRedditTitle == "" {
            subRedditTitle = "all"
        }
        loadReddits(subRedditTitle: subRedditTitle)
    }
}
