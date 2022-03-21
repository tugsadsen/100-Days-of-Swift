//
//  ViewController.swift
//  Project 7
//
//  Created by Tuğşad Şen on 15.03.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredItems = [Petition]()
    var mainItems = [Petition]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(credit))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(wordFilter))
            
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string:urlString) {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        showError()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func credit () {
        let ac = UIAlertController(title: "Your data!", message: "The data comes from the ˆˆWe The People API of the Whitehouse.ˆˆ", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        
        present(ac, animated: true)
    }
    
    @objc func wordFilter () {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Find", style: .default) { _ in
            guard let text = ac.textFields?[0].text else { return }
            self.submit(text)
        }
        let backAction = UIAlertAction(title: "Reset All", style: .destructive) { _ in
                   self.resetButton()
        }
        ac.addAction(submitAction)
        ac.addAction(backAction)
        present(ac, animated: true)
    }
    
    func submit ( _ text: String) {
        filteredItems.removeAll()
        for petition in mainItems {
            if petition.body.lowercased().contains(text.lowercased()) {
                filteredItems.append(petition)
            }
            if petition.title.lowercased().contains(text.lowercased()) {
                filteredItems.append(petition)
            }
            }
            if filteredItems.isEmpty {return}
            petitions = filteredItems
            tableView.reloadData()
    }
    
    func showError() {
        
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse (json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
            mainItems = petitions
        }
    }


    func resetButton() {
            petitions = mainItems
            tableView.reloadData()
            
        }

}

