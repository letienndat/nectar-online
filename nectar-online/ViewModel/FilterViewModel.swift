//
//  FilterViewModel.swift
//  nectar-online
//
//  Created by Macbook on 05/11/2024.
//

import Foundation

class FilterViewModel {
    var sourcesFilter: [SourceFilter]
    
    init(sourcesFilter: [SourceFilter]) {
        self.sourcesFilter = sourcesFilter
    }
}

class SourceFilter {
    let typeFilterCriteria: EnumFilterCriteria
    let title: String
    var inputsCheckbox: [InputCheckbox]
    let minRange: CGFloat
    let maxRange: CGFloat
    var startRange: CGFloat
    var endRange: CGFloat
    var tempStartRange: CGFloat
    var tempEndRange: CGFloat
    var rating: Int
    var tempRating: Int
    
    init(
        filterCriteria: EnumFilterCriteria,
        title: String,
        inputsCheckbox: [InputCheckbox] = [],
        minRange: CGFloat = Const.MIN_RANGE_PRICE,
        maxRange: CGFloat = Const.MAX_RANGE_PRICE,
        startRange: CGFloat = Const.MIN_RANGE_PRICE,
        endRange: CGFloat = Const.MAX_RANGE_PRICE,
        tempStartRange: CGFloat = Const.MIN_RANGE_PRICE,
        tempEndRange: CGFloat = Const.MAX_RANGE_PRICE,
        rating: Int = 0,
        tempRating: Int = 0
    ) {
        self.typeFilterCriteria = filterCriteria
        self.title = title
        self.inputsCheckbox = inputsCheckbox
        self.minRange = minRange
        self.maxRange = maxRange
        self.startRange = startRange
        self.endRange = endRange
        self.tempStartRange = tempStartRange
        self.tempEndRange = tempEndRange
        self.rating = rating
        self.tempRating = tempRating
    }
}
