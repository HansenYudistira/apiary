import XCTest
@testable import apiary

final class DataDecoderTests: XCTestCase {
    func testItemListModelDecoding() throws {
        let mockData = """
        {
            "status": "success",
            "data": {
            "categories": [
                {
                    "id": 101,
                    "name": "Category 1",
                    "items": [
                        {
                            "id": 1,
                            "title": "Item 1",
                            "description": "This is the description for item 1.",
                            "image_url": "https://example.com/image1.jpg",
                            "details": {
                                "author": "Author 1",
                                "published_date": "2024-01-10",
                                "tags": ["tag1", "tag2", "tag3"]
                            }
                        },
                        {
                            "id": 2,
                            "title": "Item 2",
                            "description": "This is the description for item 2.",
                            "image_url": "https://example.com/image2.jpg",
                            "details": {
                                "author": "Author 2",
                                "published_date": "2024-01-12",
                                "tags": ["tag4", "tag5"]
                            }
                        }
                    ]
                },
                {
                    "id": 102,
                    "name": "Category 2",
                    "items": [
                        {
                            "id": 3,
                            "title": "Item 3",
                            "description": "This is the description for item 3.",
                            "image_url": "https://example.com/image3.jpg",
                            "details": {
                                "author": "Author 3",
                                "published_date": "2024-01-15",
                                "tags": ["tag6", "tag7", "tag8"]
                            }
                        },
                        {
                            "id": 4,
                            "title": "Item 4",
                            "description": "This is the description for item 4.",
                            "image_url": "https://example.com/image4.jpg",
                            "details": {
                                "author": "Author 4",
                                "published_date": "2024-01-18",
                                "tags": ["tag9", "tag10"]
                            }
                        }
                    ]
                }
            ]
            },
            "metadata": {
                "total_categories": 2,
                "total_items": 4,
                "request_time": "2024-01-15T12:00:00Z"
            }
        }
        """
        let mockDataJSON = mockData.data(using: .utf8)!
        let decoder = DataDecoder()
        let dataDecoded = try! decoder.decode(RawDataModel.self, from: mockDataJSON)
        XCTAssertEqual(dataDecoded.data.categories[0].id, 101)
        XCTAssertEqual(dataDecoded.data.categories[0].name, "Category 1")
        XCTAssertEqual(dataDecoded.data.categories.count, 2)
        XCTAssertEqual(dataDecoded.data.categories[0].items[0].details.author, "Author 1")
    }
}
