import XCTest
@testable import ParrotIos

// MARK: - Mocks
class MockAudioRecorder: AudioRecorder {
    var startRecordingCalled = false
    var stopRecordingCalled = false
    
    override func startRecording() {
        startRecordingCalled = true
    }
    
    override func stopRecording() {
        stopRecordingCalled = true
    }
}

class MockParrotApiService: ParrotApiService {
    var mockWordResult: Result<Word, Error>?
    var mockRecordingResult: Result<RecordingResponse, Error>?
    
    func getRandomWord() async -> Result<Word, Error> {
        return mockWordResult ?? .failure(NSError(domain: "", code: -1))
    }
    
    func postRecording(recordingURL: URL, word: Word) async -> Result<RecordingResponse, Error> {
        return mockRecordingResult ?? .failure(NSError(domain: "", code: -1))
    }
}

class RecordingViewModelTests: XCTestCase {
    var sut: RecordingView.ViewModel!
    var mockAudioRecorder: MockAudioRecorder!
    var mockParrotApi: MockParrotApiService!
    
    // MARK: - Mock Data
    let mockPhonemes = [
        Phoneme(id: 1, ipa: "æ", respelling: "a"),
        Phoneme(id: 2, ipa: "t", respelling: "t")
    ]
    
    override func setUp() {
        super.setUp()
        mockAudioRecorder = MockAudioRecorder()
        mockParrotApi = MockParrotApiService()
        sut = RecordingView.ViewModel(audioRecorder: mockAudioRecorder, parrotApi: mockParrotApi)
    }
    
    override func tearDown() {
        sut = nil
        mockAudioRecorder = nil
        mockParrotApi = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Word Tests
    
    func testFetchNewWord_ResetsStateAndFetchesNewWord() async {
        // Given
        let mockWord = Word(
            word_id: 1,
            word: "cat",
            word_phonemes: mockPhonemes
        )
        
        //        TODO: Write this test
        assert(true)
    }
    
    func testFetchRandomWord_Success() async {
        // Given
        let mockWord = Word(
            word_id: 1,
            word: "cat",
            word_phonemes: mockPhonemes
        )
        
        //        TODO: Write this test
        assert(true)
    }
    
    func testFetchRandomWord_Failure() async {
        // Given
        let error = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockParrotApi.mockWordResult = .failure(error)
        
        //        TODO: Write this test
        assert(true)
    }
    
    // MARK: - Recording Tests
    
    func testStartRecording() {
        // When
        sut.startRecording()
        
        // Then
        XCTAssertTrue(sut.isRecording)
        XCTAssertTrue(mockAudioRecorder.startRecordingCalled)
    }
    
    func testStopRecording() async {
        // Given
        let mockResponse = RecordingResponse(
            recording_id: 1,
            score: 85,
            recording_phonemes: mockPhonemes
        )
        mockParrotApi.mockRecordingResult = .success(mockResponse)
        
        // When
        await sut.stopRecording()
        
        // Then
        XCTAssertFalse(sut.isRecording)
        XCTAssertTrue(mockAudioRecorder.stopRecordingCalled)
        XCTAssertEqual(sut.score, mockResponse.score)
    }
    
    func testUploadRecording_Success() async {
        // Given
        let mockWord = Word(
            word_id: 1,
            word: "cat",
            word_phonemes: mockPhonemes
        )
        sut.testWord = mockWord
        let mockResponse = RecordingResponse(
            recording_id: 1,
            score: 85,
            recording_phonemes: mockPhonemes
        )
        mockParrotApi.mockRecordingResult = .success(mockResponse)
        let recordingURL = URL(fileURLWithPath: "test.m4a")
        
        // When
        await sut.uploadRecording(recordingURL: recordingURL)
        
        // Then
        XCTAssertEqual(sut.score, mockResponse.score)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testUploadRecording_Failure() async {
        // Given
        let mockWord = Word(
            word_id: 1,
            word: "cat",
            word_phonemes: mockPhonemes
        )
        sut.testWord = mockWord
        let error = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockParrotApi.mockRecordingResult = .failure(error)
        let recordingURL = URL(fileURLWithPath: "test.m4a")
        
        // When
        await sut.uploadRecording(recordingURL: recordingURL)
        
        // Then
        XCTAssertNil(sut.score)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, error.localizedDescription)
    }
    
    func testToggleRecording_StartsRecording() async {
        // Given
        sut.testIsRecording = false
        
        // When
        await sut.toggleRecording()
        
        // Then
        XCTAssertTrue(sut.isRecording)
        XCTAssertTrue(mockAudioRecorder.startRecordingCalled)
    }
    
    func testToggleRecording_StopsRecording() async {
        // Given
        sut.testIsRecording = true
        let mockResponse = RecordingResponse(
            recording_id: 1,
            score: 85,
            recording_phonemes: mockPhonemes
        )
        mockParrotApi.mockRecordingResult = .success(mockResponse)
        
        // When
        await sut.toggleRecording()
        
        // Then
        XCTAssertFalse(sut.isRecording)
        XCTAssertTrue(mockAudioRecorder.stopRecordingCalled)
        XCTAssertEqual(sut.score, mockResponse.score)
    }
}
