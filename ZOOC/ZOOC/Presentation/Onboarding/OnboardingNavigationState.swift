//
//  OnboardingNavigationState.swift
//  ZOOC
//
//  Created by 장석우 on 3/12/24.
//

import Foundation


enum OnboardingDestination {
    
    case agreement
    case name
    case phone
    case welcome
    case main
    case unknown
}

protocol OnboardingNavigationState {
    
    var agreementButtonTitle: String? { get }
    var nameButtonTitle: String? { get }
    var phoneButtonTitle: String? { get }
    
    var loginDestination: OnboardingDestination { get }
    var agreementDestination: OnboardingDestination { get }
    var nameDestination: OnboardingDestination { get }
    var phoneDestination: OnboardingDestination { get }
}

extension OnboardingNavigationState {
    
    var agreementButtonTitle: String? { get { return nil } }
    var nameButtonTitle: String? { get { return nil } }
    var phoneButtonTitle: String? { get { return nil } }
    
    var loginDestination: OnboardingDestination { get { return .unknown } }
    var agreementDestination: OnboardingDestination { get { return .unknown } }
    var nameDestination: OnboardingDestination { get { return .unknown } }
    var phoneDestination: OnboardingDestination { get { return .unknown } }
}
