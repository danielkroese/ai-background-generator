import XCTest

final class ImageDataParserTests: XCTestCase {
    func test_parseData_returnsFileUrl() {
        assertNoThrow {
            let sut = ImageDataParser()
            
            let url = try sut.parse(dummyBase64Image)
            
            XCTAssertTrue(url.isFileURL)
        }
    }
    
    func test_parseData_withInvalidBase64_throws() async {
        await assertAsyncThrows(expected: DataParsingError.invalidImageData) {
            let sut = ImageDataParser()
            _ = try sut.parse("???")
        }
    }
    
    func test_parseData_returnsExpectedFileNameFormat() {
        
    }
    
    private var dummyBase64Image: String {
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5QgQChUkFOfjAAAAABl0RVh0Q29tbWVudABDcmVhdGVkIHdpdGggR0lNUFeBDhcAAAANSURBVAjXY2AAAAACAAHiIjUNAAAAAElFTkSuQmCC"
    }
}
