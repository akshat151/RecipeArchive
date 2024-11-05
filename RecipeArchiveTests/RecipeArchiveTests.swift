//
//  RecipeArchiveTests.swift
//  RecipeArchiveTests
//
//  Created by Akshat Khare on 11/4/24.
//

import XCTest
@testable import RecipeArchive

/// This class tests the functionalities of the RecipeArchive app, ensuring that the Recipe and RecipeViewModel behaviors are correct under various conditions.
final class RecipeArchiveTests: XCTestCase {
    
    private var service: MockNetworkUtility!
    
    /// Set up the test environment before each test method runs. It initializes the MockNetworkUtility to simulate network interactions.
    override func setUpWithError() throws {
        super.setUp()
        service = MockNetworkUtility()
    }
    
    /// Clean up the test environment after each test method completes. It deallocates the mock network utility to ensure clean test states.
    override func tearDownWithError() throws {
        service = nil
        super.tearDown()
    }
    
    /// Test the decoding of a single recipe from JSON to verify if the decoding process correctly parses the model.
    func testRecipeDecoding() throws {
        let json = """
                {
                    "uuid": "1",
                    "cuisine": "Italian",
                    "name": "Pizza",
                    "photo_url_large": "<https://example.com/pizza_large.jpg>",
                    "photo_url_small": "<https://example.com/pizza_small.jpg>",
                    "source_url": "<https://example.com/recipe_pizza>",
                    "youtube_url": "<https://youtube.com/example>"
                }
                """.data(using: .utf8)!
        
        let recipe = try JSONDecoder().decode(Recipe.self, from: json)
        XCTAssertEqual(recipe.uuid, "1")
        XCTAssertEqual(recipe.cuisine, "Italian")
        XCTAssertEqual(recipe.name, "Pizza")
        XCTAssertEqual(recipe.photoUrlLarge, "<https://example.com/pizza_large.jpg>")
    }
    
    /// Test decoding of a JSON response containing multiple recipes to ensure the RecipeResponse model works as expected.
    func testRecipeResponseDecoding() throws {
        let json = """
                {
                    "recipes": [
                        {
                            "uuid": "1",
                            "cuisine": "Italian",
                            "name": "Pizza",
                            "photo_url_large": "<https://example.com/pizza_large.jpg>",
                            "photo_url_small": "<https://example.com/pizza_small.jpg>",
                            "source_url": "<https://example.com/recipe_pizza>",
                            "youtube_url": "<https://youtube.com/example>"
                        }
                    ]
                }
                """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(RecipeResponse.self, from: json)
        XCTAssertEqual(response.recipes.count, 1)
        XCTAssertEqual(response.recipes[0].name, "Pizza")
    }
    
    /// Test the successful fetch and loading of recipes asynchronously to confirm the RecipeViewModel correctly handles successful data fetching.
    func testSuccessfulDataFetching() async {
        let viewModel = await RecipeViewModel(networkUtility: service)
        let sampleRecipe = MockData.sampleAppetizer
        service.recipes = [sampleRecipe]
        
        await viewModel.loadRecipes()
        
        DispatchQueue.main.async {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNil(viewModel.error)
            XCTAssertEqual(viewModel.recipes.count, 1)
            XCTAssertEqual(viewModel.recipes.first?.name, "Spaghetti Carbonara")
        }
    }
    
    /// Tests the behavior of the app when receiving malformed JSON data, expecting decoding errors to be handled correctly.
    func testMalformedData() async throws {
        let malformedJSONData = "{ malformed json".data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, malformedJSONData)
        }
        
        let service = NetworkUtility(baseURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!)
        let viewModel = await RecipeViewModel(networkUtility: service)
        
        await viewModel.loadRecipes()
        
        await MainActor.run {
            XCTAssertTrue(viewModel.showError, "The view model should show an error")
            XCTAssertEqual(viewModel.error, .decodingError, "The expected error should be decodingError")
        }
    }
    
    /// Tests the scenario where empty but valid JSON data is fetched. This test ensures the app handles the absence of expected recipe data correctly, without crashing or misinterpreting the data structure.
    func testEmptyData() async throws {
            let emptyJSONData = "{ empty json".data(using: .utf8)!
            MockURLProtocol.requestHandler = { request in
                return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, emptyJSONData)
            }
            
            // Initialize service and view model
            let service = NetworkUtility(baseURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!)
            let viewModel = await RecipeViewModel(networkUtility: service)
            
            // Perform action
            await viewModel.loadRecipes()
            
            // Wait for updates to be posted to the main actor
            await MainActor.run {
                // Now check values within the main actor context
                XCTAssertEqual(viewModel.recipes.count, 0, "The recipe count should be 0 due to empty data")
                XCTAssertTrue(viewModel.showError, "The view model should show an error")
                XCTAssertEqual(viewModel.error, .decodingError, "The expected error should be decodingError")
            }
        }
    
    
    /// Test correct handling of valid JSON data from a functional URL, expecting the view model to update the recipe list correctly without errors.
    func testValidDataFromValidURL() async throws {
        let validJSONData = "{}".data(using: .utf8)!  // Use actual valid JSON for this scenario.
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, validJSONData)
        }
        
        let service = NetworkUtility(baseURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
        let viewModel = await RecipeViewModel(networkUtility: service)
        
        await viewModel.loadRecipes()
        
        await MainActor.run {
            XCTAssertEqual(viewModel.recipes.count, 63, "The recipe count should be 63")
            XCTAssertFalse(viewModel.showError, "No error should be shown when valid data is fetched")
            XCTAssertNil(viewModel.error, "No error should be present")
        }
    }
    
    /// Test the view model's error handling when a network request fails due to an invalid URL, ensuring the error is communicated properly.
    func testNetworkFailureWithInvalidURL() async {
        let viewModel = await RecipeViewModel(networkUtility: service)
        service.error = .invalidURL
        
        await viewModel.loadRecipes()
        
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertTrue(viewModel.showError, "The view model should show an error when URL is invalid")
            XCTAssertEqual(viewModel.error, .invalidURL, "The expected error should be invalidURL")
        }
    }
    
    /// Tests the view model's error handling when the server responds improperly, ensuring the error is communicated properly.
    func testNetworkFailureWithInvalidResponse() async {
        let viewModel = await RecipeViewModel(networkUtility: service)
        service.error = .invalidResponse
        
        await viewModel.loadRecipes()
        
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertTrue(viewModel.showError, "The view model should show an error when the response is invalid")
            XCTAssertEqual(viewModel.error, .invalidResponse, "The expected error should be invalidResponse")
        }
    }
    
    /// Tests the functionality to open URLs through the view model and verify the response when the URL is not valid.
    func testOpenURLInvalid() async {
        let viewModel = await RecipeViewModel(networkUtility: service)
        
        await MainActor.run {
            viewModel.openURL("htp://invalid.url")  // Intentionally malformed URL scheme.
            
            XCTAssertTrue(viewModel.showURLAlert, "An alert should be shown for an invalid URL")
            XCTAssertEqual(viewModel.alertMessage, "The URL provided is invalid or unsupported.")
        }
    }
    
    /// Tests the functionality to open URLs through the view model and verify the correct execution when the URL is valid.
    func testOpenURLValid() async {
        let viewModel = await RecipeViewModel(networkUtility: service)
        let validURL = "https://youtube.com"
        
        await MainActor.run {
            viewModel.openURL(validURL)
            XCTAssertFalse(viewModel.showURLAlert, "No alert should be shown for a valid URL")
        }
    }
}

/// The mock service used to simulate network responses, both successful and erroneous, to test the RecipeViewModel.
class MockNetworkUtility: NetworkUtilityProtocol {
    var recipes: [Recipe]?
    var error: NetworkErrorManager?
    
    func fetchRecipes() async throws -> [Recipe] {
        if let error = error {
            throw error
        }
        return recipes ?? []
    }
}

/// A custom URL protocol to mock network responses, helping to test network failure handling and data fetching.
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // This method is required but does not need to do anything for our mocks.
    }
}

