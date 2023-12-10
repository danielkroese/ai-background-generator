import XCTest

final class ImageDataParserTests: XCTestCase {
    func test_parseData_returnsFileUrl() {
        assertNoThrow {
            let url = try createSutAndParseDummy()
            
            XCTAssertTrue(url.isFileURL)
        }
    }
    
    func test_parseData_withInvalidBase64_throws() async {
        await assertAsyncThrows(expected: DataParsingError.invalidImageData) {
            let sut = createSut()
            
            _ = try sut.parse("???")
        }
    }
    
    func test_parseData_usesExpectedFileName() {
        assertNoThrow {
            let url = try createSutAndParseDummy()
            let date = Date().ISO8601Format()
            
            XCTAssertEqual(url.lastPathComponent, "background-\(date).png")
        }
    }
    
    func test_parseData_usesExpectedFileDirectory() {
        assertNoThrow {
            let url = try createSutAndParseDummy()
            let directory = url.deletingLastPathComponent()
            let expectedDirectory = directoryUrl(for: .documentDirectory)
            
            XCTAssertEqual(directory.pathComponents, expectedDirectory.pathComponents)
        }
    }
}

// MARK: - Test helpers
extension ImageDataParserTests {
    private func createSut() -> ImageDataParser {
        ImageDataParser()
    }
    
    private func createSutAndParseDummy() throws -> URL {
        let sut = ImageDataParser()
        
        return try sut.parse(dummyBase64Image)
    }
    
    private func directoryUrl(for directory: FileManager.SearchPathDirectory) -> URL {
        guard let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            XCTFail("Could not find directory")
            return URL.documentsDirectory
        }
        
        return directory
    }
    
    private var dummyBase64Image: String {
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5QgQChUkFOfjAAAAABl0RVh0Q29tbWVudABDcmVhdGVkIHdpdGggR0lNUFeBDhcAAAANSURBVAjXY2AAAAACAAHiIjUNAAAAAElFTkSuQmCC"
    }
}
