//
//  Artist.swift
//  MusicByLocation2
//
//  Created by MIKHAEL LUKYANOV on 07/03/2023.
//

import Foundation

struct Artist: Codable {
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "artistName"
    }
}
