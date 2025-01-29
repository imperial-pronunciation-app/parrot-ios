
import Testing
@testable import ParrotIos
import AVFoundation

@Suite("RecordingViewModel Tests")
struct RecordingViewModelTests {
    
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
                // Wait for 2 seconds, this had to be added for loading testing
                await Task.sleep(2_000_000_000)
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
    
    

    @Test("Fetching new word successfully returns expected word")
    @MainActor
    func testFetchNewWordSuccess() async {
        // Given
        let state = TestState()
        
        // When
        await state.viewModel.fetchNewWord()
        
        // Then
        #expect(state.viewModel.testWord?.word == "hello")
        #expect(state.viewModel.testWord?.word_id == 1)
        #expect(state.viewModel.testWord?.word_phonemes.count == 1)
        #expect(state.viewModel.testErrorMessage == nil)
        #expect(!state.viewModel.testIsLoading)
    }
    
    
    @Test("Fetching new word fails")
    @MainActor
    func testFetchNewWordFailure() async {
        // Given
        let state = TestState()
        state.mockParrotApi.shouldSucceed = false
        
        // When
        await state.viewModel.fetchNewWord()
        
        // Then
        #expect(state.viewModel.testWord == nil)
        #expect(state.viewModel.testErrorMessage == "The operation couldn’t be completed. (ParrotIos.ParrotApiService.ParrotApiError error 0.)")
        #expect(!state.viewModel.testIsLoading)
    }
    
    //  Recording Tests
    @Test("Test the ability of the View Model to start recording")
    @MainActor
    func testStartRecording() {
        // Given
        let state = TestState()
        
        // When
        state.viewModel.startRecording()

        // Then
        #expect(state.viewModel.testIsRecording)
        #expect(state.mockAudioRecorder.startRecordingCalled)
    }
    
    @Test("Test the ability of the View Model to stop recording")
    @MainActor
    func testStopRecording() async {
        // Given
        let state = TestState()
        state.mockParrotApi.shouldSucceed = true
        state.viewModel.testWord = state.mockParrotApi.mockWord

        // When
        await state.viewModel.stopRecording()

        // Then
        #expect(!state.viewModel.testIsRecording)
        #expect(state.mockAudioRecorder.stopRecordingCalled)
        #expect(state.viewModel.testScore == state.mockParrotApi.mockRecordingResponse.score)
        #expect(state.viewModel.testErrorMessage == nil)
    }
    @Test("Test the ability of the View Model to stop recording")
    @MainActor
    func testStopRecordingFailure() async {
        // Given
        let state = TestState()
        state.mockParrotApi.shouldSucceed = false
        state.viewModel.testWord = state.mockParrotApi.mockWord

        // When
        await state.viewModel.stopRecording()

        // Then
        #expect(!state.viewModel.testIsRecording)
        #expect(state.mockAudioRecorder.stopRecordingCalled)
        #expect(state.viewModel.testScore == nil)
        #expect(state.viewModel.testErrorMessage == "The operation couldn’t be completed. (ParrotIos.ParrotApiService.ParrotApiError error 0.)")

    }

    // Toggle Recording Tests
    @Test("Testing the toggle audio recorder can start")
    @MainActor
    func testToggleRecordingStart() async {
        // Given
        let state = TestState()
        state.viewModel.testIsRecording = false

        // When
        await state.viewModel.toggleRecording()

        // Then
        #expect(state.viewModel.testIsRecording)
        #expect(state.mockAudioRecorder.startRecordingCalled)
    }
    
    @Test("Test toggle audio recorder can stop")
    @MainActor
    func testToggleRecordingStop() async {
        // Given
        let state = TestState()
        state.viewModel.testIsRecording = true
        state.viewModel.testWord = state.mockParrotApi.mockWord
        state.mockParrotApi.shouldSucceed = true

        // When
        await state.viewModel.toggleRecording()

        // Then
        #expect(!state.viewModel.testIsRecording)
        #expect(state.mockAudioRecorder.stopRecordingCalled)
        #expect(state.viewModel.testScore == state.mockParrotApi.mockRecordingResponse.score)
    }

    // Loading State Tests
    @Test("Tests the loading status during a new word fetch")
    @MainActor
    func testLoadingStatesDuringFetch() async {
        // When starting fetch
        let state = TestState()
        Task {
            await state.viewModel.fetchNewWord()
        }

        // Then - Should be loading initially
        async #expect(state.viewModel.testIsLoading)

        // When fetch completes
        await Task.yield()

        // Then - Should not be loading anymore
        async #expect(!state.viewModel.testIsLoading)
    }
    
    @Test("Test the loading status during an upload")
    @MainActor
    func testLoadingStatesDuringUpload() async {
        // Given
        let state = TestState()
        state.viewModel.testWord = state.mockParrotApi.mockWord
        
        // When starting upload
        Task {
            await state.viewModel.stopRecording()
        }

        // Then - Should be loading initially
        async #expect(state.viewModel.testIsLoading)

        // When upload completes
        await Task.yield()

        // Then - Should not be loading anymore
        async #expect(!state.viewModel.testIsLoading)
    }
    
}

// Test State Management
extension RecordingViewModelTests {
    @MainActor
    struct TestState {
        let viewModel: RecordingView.ViewModel
        let mockAudioRecorder: MockAudioRecorder
        let mockParrotApi: MockParrotApi
        
        init() {
            self.mockAudioRecorder = MockAudioRecorder()
            self.mockParrotApi = MockParrotApi()
            self.viewModel = RecordingView.ViewModel(
                audioRecorder: mockAudioRecorder,
                parrotApi: mockParrotApi
            )
        }
    }
}

