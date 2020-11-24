//
//  LocationPickerTableViewManager.swift
//  Aether
//
//  Created by Bruno Pastre on 04/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import MapKit
import Contacts

protocol LocationPickerTableViewManagerDelegate: AnyObject {
    func didSelectItemAt(indexPath: IndexPath)
    func locationDidChange(_ coordinate: MKCoordinateRegion?)
}

class LocationPickerTableViewManager: NSObject, UITableViewDelegate {
    
    private var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world) {
        didSet {
            delegate?.locationDidChange(boundingRegion)
        }
    }
    private var places: [MKMapItem]?
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
    weak var delegate: LocationPickerTableViewManagerDelegate?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectItemAt(indexPath: indexPath)
    }
    
    
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = boundingRegion
        
        // Include only point of interest results. This excludes results based on address matches.
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                delegate?.locationDidChange(nil)
                return
            }
            
            self.places = response?.mapItems
            
            // Used when setting the map's region in `prepareForSegue`.
            if let updatedRegion = response?.boundingRegion {
                self.boundingRegion = updatedRegion
            }
        }
    }
}
