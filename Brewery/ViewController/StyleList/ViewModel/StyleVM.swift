//
//  StyleVM.swift
//  Brewery
//
//  Created by Alvaro Blazquez on 16/10/18.
//  Copyright © 2018 Alvaro Blazquez. All rights reserved.
//

import SwiftyJSON
import Moya

class StyleVM: ListVM<StyleItemVM, StyleRepositoryProtocol, StyleCoordinatorProtocol>, DictionaryViewModel {
    
    var minElementToShowDictionary: Int = 15
    var dictionaryItems: [Character: [StyleItemVM]] = [:]
    
    func reloadData() {
        guard let viewDelegate = self.viewDelegate else {
            fatalError("ViewModel without view delegate")
        }
        viewDelegate.render(state: .loading(Process.Main))
        
        repository.get { result in
            switch result {
            case let .success(response):
                if let response = response {
                    self.data = response.map { StyleItemVM($0) }
                    self.dictionaryItems = Dictionary(grouping: self.data,
                                                      by: { $0.name.formattedFirstChar })
                }
                viewDelegate.render(state: .loaded(Process.Main))
            case .failure:
                viewDelegate.render(state: .error(Process.Main))
            }
        }
    }
    
    func didSelectItemAt(index: IndexPath) {
        if let styleItemVM = itemAtIndex(index) {
            coordinator.performTransition(transition: .goBeerList(styleItemVM: styleItemVM))
        }
    }
    
}
