//
//  ViewController.swift
//  ItunesSearchAssignment
//  Copyright © 2018 HarpreetSingh. All rights reserved.
//

import UIKit
import AVKit

class MusicSearchViewController: UIViewController {

    @IBOutlet weak var musicSearchTableView: UITableView!
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter artist or track name here..."
        return searchBar
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No results."
        label.textAlignment = .center
        return label
    }()
    
    private let playerViewController = AVPlayerViewController()
    
    private var musics = [Music]()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var isFetching: Bool = false  {
        didSet {
            if (isFetching) {
                activityIndicator.startAnimating()
                view.isUserInteractionEnabled = false
            } else {
                activityIndicator.stopAnimating()
                view.isUserInteractionEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        noResultLabel.frame = musicSearchTableView.frame
        setupSearchBar()
        setupMusicSearchTableView()
        setupIndicatorView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    private func setupMusicSearchTableView() {
        musicSearchTableView.keyboardDismissMode = .onDrag
        musicSearchTableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupIndicatorView() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MusicSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (musics.count == 0) {
            tableView.backgroundView = noResultLabel
        } else {
            tableView.backgroundView = nil
        }
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let music = musics[indexPath.row]
        cell.textLabel?.text = music.artistName
        cell.detailTextLabel?.text = music.trackName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let music = musics[indexPath.row]
        playTrack(music.previewUrl)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func playTrack(_ previewUrl: String) {
        present(playerViewController, animated: true, completion: nil)
        let player = AVPlayer(url: URL(string: previewUrl)!)
        playerViewController.player = player
        player.play()
    }
}


extension MusicSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        isFetching = true
        NetworkManager().getMusic(query: query) { [unowned self](musics, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("ERROR: \(error)")
                    let alert = UIAlertController.init(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.musics = musics ?? []
                self.musicSearchTableView.reloadData()
                self.isFetching = false
            }
        }
    }
}
