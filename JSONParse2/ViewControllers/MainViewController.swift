//
//  MainViewController.swift
//  JSONParse2
//
//  Created by Alexandr Baranov on 12.11.2023.
//

import UIKit

enum Link {
    case factURL
    
    var url: URL {
        switch self {
        case .factURL:
            return URL(string: "https://cat-fact.herokuapp.com/facts")!
            
        }
    }
}

enum UserAction: CaseIterable {
    case fetchFact
    
    var title: String {
        switch self {
        case .fetchFact:
            return "Fetch Fact"
        }
    }
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

final class MainViewController: UICollectionViewController {
    
    private let userActions = UserAction.allCases
    
    // MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath) as? UserActionCell else { return UICollectionViewCell() }
        
        cell.userActionLabel.text = userActions[indexPath.item].title
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .fetchFact:
            fetchFact()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
        
    }
}

// MARK: - Networking
extension MainViewController {
    private func fetchFact() {
        URLSession.shared.dataTask(with: Link.factURL.url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let fact = try jsonDecoder.decode([CatFact].self, from: data)
                print(fact)
                DispatchQueue.main.async { [unowned self] in
                    self.showAlert(withStatus: .success)
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async { [unowned self] in
                    self.showAlert(withStatus: .failed)
                }
            }
        }.resume()
    }
}
