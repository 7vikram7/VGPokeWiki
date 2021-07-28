//
//  VGPokeWikiTests.swift
//  VGPokeWikiTests
//
//  Created by Vicky's Red Devil on 7/13/21.
//

import XCTest
@testable import VGPokeWiki

class VGPokeWikiTests: XCTestCase {

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testHomeViewModel_SearchBarShouldChangeTextInRange_ShouldReturnTrue() {
        //Arrange
        let sut = HomeViewModel()

        //Act
        let result = sut.searchBar(UISearchBar(), shouldChangeTextIn: NSRange(), replacementText: "abcdefghijklmnopqurstuvwxyz1234567890")

        //Assert
        XCTAssertTrue(result, "Only smallcase alphabets and numbers are searchable")
    }

    func testHomeViewModel_SearchBarShouldChangeTextInRange_ShouldReturnFalse() {
        //Arrange
        let sut = HomeViewModel()

        //Act
        let result = sut.searchBar(UISearchBar(), shouldChangeTextIn: NSRange(), replacementText: "~!@#$%^&*()_+{}|:")

        //Assert
        XCTAssertFalse(result, "Only smallcase alphabets and numbers are searchable")
    }
}
