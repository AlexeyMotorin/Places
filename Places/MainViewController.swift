//
//  TableViewController.swift
//  Places
//
//  Created by Алексей Моторин on 04.04.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    var places: Results<Places>!
    
    private lazy var placeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    private lazy var segmentSort: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Дата", "Имя"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = .white
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(placeTableView)
        view.addSubview(segmentSort)
        
        NSLayoutConstraint.activate([
            segmentSort.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentSort.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentSort.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            placeTableView.topAnchor.constraint(equalTo: segmentSort.bottomAnchor, constant: -34),
            placeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        places = realm.objects(Places.self)
        
        setupNavigationBar()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Мои места"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        placeTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Мои места"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Snell Roundhand", size: 24) ?? 0]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showAddPlaceVC))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sorted))
    }
    
    @objc private func showAddPlaceVC() {
        navigationController?.pushViewController(NewPlacesViewController(), animated: true)
    }
    
    @objc private func sorted() {
        
    }
    
    @objc private func segmentedValueChanged(_ sender: UISegmentedControl) {
        
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let place = places[indexPath.row]
        
        cell.namePlace.text = place.namePlace
        cell.locationPlace.text = place.locationPlace
        cell.typePlace.text = place.typePlace
        cell.imagePlace.image = UIImage(data: place.imageData!)
        
        return cell
    }
    
    // MARK: Table view delegate
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let place = places[indexPath.row]
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .fade )
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placesVC = NewPlacesViewController()
        placesVC.currentPlace = places[indexPath.row]
        navigationController?.pushViewController(placesVC, animated: true)
    }
}
