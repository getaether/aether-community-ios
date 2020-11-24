//
//  LocationPickerViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 28/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import MapKit
import Contacts

protocol LocationPickerDelegate: AnyObject {
    func didChangeLocation(to coordinate: MKCoordinateRegion?)
    func onDismiss()
}

class LocationPickerViewController: UIViewController, UISearchBarDelegate, LocationPickerTableViewManagerDelegate {
    typealias strings = AEStrings.Alert.SearchError
    // MARK: - Controllers
    private var suggestionController: LocationSuggestionTableViewController
    private var searchController: UISearchController
    
    // MARK: - Location Properties
    private let tableViewManager = LocationPickerTableViewManager()
    private var currentPlacemark: CLPlacemark?
    private var currentAnnotation = MKPointAnnotation()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.addAnnotation(currentAnnotation)
        return view
    }()
    
    weak var delegate: LocationPickerDelegate?
    
    // MARK: - Initializer
    init() {
        suggestionController = LocationSuggestionTableViewController()

        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController

        super.init(nibName: nil, bundle: nil)

        suggestionController.tableView.delegate = tableViewManager
        tableViewManager.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.onDismiss()
    }
    
    // MARK: - UIViewController Lifecycle
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
    }
    
    // MARK: - SearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        tableViewManager.search(for: searchBar.text)
    }
    
    // MARK: - LocationPickerTableViewManagerDelegate
    func didSelectItemAt(indexPath: IndexPath) {
        
        if let suggestion = suggestionController.completerResults?[indexPath.row] {
            
            searchController.isActive = false
            searchController.searchBar.text = suggestion.title
            currentAnnotation.title = suggestion.title
            tableViewManager.search(for: suggestion)
        }
    }
    
    func locationDidChange(_ coordinate: MKCoordinateRegion?) {
        delegate?.didChangeLocation(to: coordinate)
        guard let coordinate = coordinate else { return }
        
        mapView.setRegion(coordinate, animated: true)
        currentAnnotation.coordinate = coordinate.center
        
    }
    // MARK: - Helpers
    private func displaySearchError(_ error: Error?) {
        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
            let alertController = UIAlertController(
                title: strings.title,
                message: errorString,
                preferredStyle: .alert
            )
            alertController.addAction(
                UIAlertAction(
                    title: strings.Action.ok,
                    style: .default,
                    handler: nil
            ))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Unused
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
