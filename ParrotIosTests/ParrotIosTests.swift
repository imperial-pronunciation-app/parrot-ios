import XCTest
@testable import ParrotIos
import AVFoundation

final class RecordingViewModelTests: XCTestCase {
    
    // Mock Classes
    class InnerMockAudioRecorder: AVAudioRecorder {
        override var url: URL {  // Computed property
                get {
                    return someOtherURL // Provide custom logic here
                }
                set {
                    someOtherURL = newValue
                }
            }
            
            private var someOtherURL: URL = URL(string: "https://default.com")! // Internal storage

    }
    
    class MockAudioRecorder: AudioRecorder {
        var startRecordingCalled = false
        var stopRecordingCalled = false
        
        override func startRecording() {
            startRecordingCalled = true
        }
        
        override func stopRecording() {
            stopRecordingCalled = true
        }
        
        override func getAudioFileURL() -> URL {
            return URL(string: "file:///path/to/file")!
        }
    }
    
    class MockParrotApi: ParrotApiService {
        var shouldSucceed = true
        var mockWord = Word(
            word_id: 1,
            word: "hello",
            word_phonemes: [
                Phoneme(id: 1, ipa: "həˈloʊ", respelling: "huh-LOH")
            ]
        )
        
        var mockRecordingResponse = RecordingResponse(
            recording_id: 1,
            score: 85,
            recording_phonemes: [
                Phoneme(id: 1, ipa: "həˈloʊ", respelling: "huh-LOH")
            ]
        )
        
        override func getRandomWord() async -> Result<Word, ParrotApiError> {
            if shouldSucceed {
                return .success(mockWord)
            } else {
                return .failure(.customError("Failed to fetch the word."))
            }
        }
        
        override func postRecording(recordingURL: URL, word: Word) async -> Result<RecordingResponse, ParrotApiError> {
            if shouldSucceed {
                return .success(mockRecordingResponse)
            } else {
                return .failure(.customError("Failed to upload recording."))
            }
        }
    }
    
    // MARK: - Test Properties
    var viewModel: RecordingView.ViewModel!
    var mockAudioRecorder: MockAudioRecorder!
    var mockParrotApi: MockParrotApi!
    
    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        mockAudioRecorder = MockAudioRecorder()
        mockParrotApi = MockParrotApi()
        viewModel = RecordingView.ViewModel(audioRecorder: mockAudioRecorder, parrotApi: mockParrotApi)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAudioRecorder = nil
        mockParrotApi = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Word Tests
    func testFetchNewWordSuccess() async {
        // Given
        mockParrotApi.shouldSucceed = true
        
        // When
        await viewModel.fetchNewWord()
        
        // Then
        XCTAssertEqual(viewModel.testWord?.word, "hello")
        XCTAssertEqual(viewModel.testWord?.word_id, 1)
        XCTAssertEqual(viewModel.testWord?.word_phonemes.count, 1)
        XCTAssertNil(viewModel.testErrorMessage)
        XCTAssertFalse(viewModel.testIsLoading)
    }
    
    func testFetchNewWordFailure() async {
        // Given
        mockParrotApi.shouldSucceed = false
        
        // When
        await viewModel.fetchNewWord()
        
        // Then
        XCTAssertNil(viewModel.testWord)
        XCTAssertEqual(viewModel.testErrorMessage, "The operation couldn’t be completed. (ParrotIos.ParrotApiService.ParrotApiError error 0.)")
        XCTAssertFalse(viewModel.testIsLoading)
    }
   
    //  Recording Tests
    func testStartRecording() {
        // When
        viewModel.startRecording()
        
        // Then
        XCTAssertTrue(viewModel.testIsRecording)
        XCTAssertTrue(mockAudioRecorder.startRecordingCalled)
    }
    
    func testStopRecording() async {
        // Given
        mockParrotApi.shouldSucceed = true
        viewModel.testWord = mockParrotApi.mockWord
        
        // When
        await viewModel.stopRecording()
        
        // Then
        XCTAssertFalse(viewModel.testIsRecording)
        XCTAssertTrue(mockAudioRecorder.stopRecordingCalled)
        XCTAssertEqual(viewModel.testScore, mockParrotApi.mockRecordingResponse.score)
        XCTAssertNil(viewModel.testErrorMessage)
    }
    
    func testStopRecordingFailure() async {
        // Given
        mockParrotApi.shouldSucceed = false
        viewModel.testWord = mockParrotApi.mockWord
        
        // When
        await viewModel.stopRecording()
        
        // Then
        XCTAssertFalse(viewModel.testIsRecording)
        XCTAssertTrue(mockAudioRecorder.stopRecordingCalled)
        XCTAssertNil(viewModel.testScore)
        XCTAssertEqual(viewModel.testErrorMessage, "The operation couldn’t be completed. (ParrotIos.ParrotApiService.ParrotApiError error 0.)")
    }
//    
//    // Toggle Recording Tests
//    func testToggleRecordingStart() async {
//        // Given
//        viewModel.testIsRecording = false
//        
//        // When
//        await viewModel.toggleRecording()
//        
//        // Then
//        XCTAssertTrue(viewModel.testIsRecording)
//        XCTAssertTrue(mockAudioRecorder.startRecordingCalled)
//    }
//    
//    func testToggleRecordingStop() async {
//        // Given
//        viewModel.testIsRecording = true
//        viewModel.testWord = mockParrotApi.mockWord
//        mockParrotApi.shouldSucceed = true
//        
//        // When
//        await viewModel.toggleRecording()
//        
//        // Then
//        XCTAssertFalse(viewModel.testIsRecording)
//        XCTAssertTrue(mockAudioRecorder.stopRecordingCalled)
//        XCTAssertEqual(viewModel.testScore, mockParrotApi.mockRecordingResponse.score)
//    }
//    
//    // MARK: - Loading State Tests
//    func testLoadingStatesDuringFetch() async {
//        // When starting fetch
//        Task {
//            await viewModel.fetchNewWord()
//        }
//        
//        // Then - Should be loading initially
//        XCTAssertTrue(viewModel.testIsLoading)
//        
//        // When fetch completes
//        await Task.yield()
//        
//        // Then - Should not be loading anymore
//        XCTAssertFalse(viewModel.testIsLoading)
//    }
//    
//    func testLoadingStatesDuringUpload() async {
//        // Given
//        viewModel.testWord = mockParrotApi.mockWord
//        
//        // When starting upload
//        Task {
//            await viewModel.stopRecording()
//        }
//        
//        // Then - Should be loading initially
//        XCTAssertTrue(viewModel.testIsLoading)
//        
//        // When upload completes
//        await Task.yield()
//        
//        // Then - Should not be loading anymore
//        XCTAssertFalse(viewModel.testIsLoading)
//    }
}
