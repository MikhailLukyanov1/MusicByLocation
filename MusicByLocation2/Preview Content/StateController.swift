//
//  StateController.swift
//  MusicByLocation2
//
//  Created by MIKHAEL LUKYANOV on 07/03/2023.
//

import Foundation

class StateController: ObservableObject {
    
    @Published var lastKnownLocation: String = "" {
        didSet {
            getArtists(search: lastKnownLocation)
        }
    }
    @Published var artistsFromLocation: String = ""
    let locationHandler: LocationHandler = LocationHandler()
    
    func findMusic() {
        locationHandler.requestLocation()
    }
    
    func requestAccessToLocationData() {
        locationHandler.stateController = self
        locationHandler.requestAuthorisation()
    }
    
    func getArtists(search: String) {
        
        let baseUrl = "https://itunes.apple.com"
        let path = "/search?term=\(search)&entity=musicArtist".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        guard let url = URL(string: baseUrl + path)
        else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let response = self.parseJson(json: data) {
                    let names = response.results.map {
                        return $0.name
                    }
                    
                    DispatchQueue.main.async {
                        self.artistsFromLocation = names.joined(separator: ", ")
                    }
                }
            }
        }.resume()
    }
    
    func parseJson(json: Data) -> ArtistResponse? {
        let decoder = JSONDecoder()
        
        if let artistResponse = try? decoder.decode(ArtistResponse.self, from: json) {
            return artistResponse
        } else {
            print("Error decoding json")
            return nil
        }
        
        
    }
}
