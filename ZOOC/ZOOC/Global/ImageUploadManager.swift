//
//  URLSessionTransformToBackgroundManager.swift
//  ZOOC
//
//  Created by 장석우 on 11/27/23.
//

import UIKit

import RxSwift
import RxCocoa

enum UploadStatus {
    case none
    case uploading // iOS -> Fap Server
    case modeling  // FapServer -> leonardo Server
}

protocol ImageManagerSettable {
    func setRequest(_ request: URLRequest, with body: Data)
}

protocol ImageManagerResponseSendable {
    func responseSuccess()
    func responseFail(willContinue: Bool)
}

protocol ImageUploadProgressDelegate: AnyObject {
    func progressTaskDidCreate()
    func progressTaskIsProcessing(with ratio: Float)
    func progressTaskCompleted()
}

protocol ImageUploadResponseDelegate: AnyObject {
    func responseSuccess()
    func responseFail(willContinue: Bool)
}

protocol ImageUploadExceptionDelegate: AnyObject {
    func didEnterBackground(_ status: UploadStatus)
    func willTerminate(_ status: UploadStatus)
}

final class ImageUploadManager: NSObject {
    
    typealias ImageUploadManagerDelegate = ImageUploadProgressDelegate & ImageUploadResponseDelegate & ImageUploadExceptionDelegate
    
    //MARK: - Properties
    
    static let shared = ImageUploadManager()
    private let disposeBag = DisposeBag()
    
    weak var delegate: ImageUploadManagerDelegate?
    
    private var status: UploadStatus = .none
    private var request: URLRequest?
    private var fileURL: URL?
    private var progressTask: URLSessionTask?
    private var backgroundTask: URLSessionTask?
    
    //MARK: - Life Cycle
    
    private override init() {
        super.init()
        
        UIApplication.rx.didFinishLaunching
            .do(onNext: { print("😍didFinishLaunching") })
            .bind(onNext: reset)
            .disposed(by: disposeBag)
        
//        UIApplication.rx.didBecomeActive
//            .bind(onNext: DefaultPetRepository.shared.updatePet)
//            .disposed(by: disposeBag)
        
        UIApplication.rx.didEnterBackground
            .do(onNext: { print("😍didEnterBackground") })
            .do(onNext: { self.delegate?.didEnterBackground(self.status) })
            .filter { self.status != .modeling}
            .filter { self.progressTask != nil }
            .map { self.progressTask! }
            .map(cancelProgressTask)
            .filter { self.request != nil }
            .filter { self.fileURL != nil }
            .map { (self.request!, self.fileURL!) }
            .map(resumeWithBackground)
            .map { PushNotificationCase.resumeWithBackground.model }
            .bind(onNext: PushNotification.send)
            .disposed(by: disposeBag)
        
        UIApplication.rx.willTerminate
            .do(onNext: { print("😍willTerminate") })
            .do(onNext: { self.delegate?.willTerminate(self.status)})
            .filter { self.status == .uploading}
            .map { PushNotificationCase.warnningWhenTerminate.model }
            .bind(onNext: PushNotification.send)
            .disposed(by: disposeBag)
    }
    
}

extension ImageUploadManager: ImageManagerSettable {

    func setRequest(_ request: URLRequest, with body: Data) {
        reset()
        let fileURL = writeFile(with: body)
        self.request = request
        self.fileURL = fileURL
    }
}

extension ImageUploadManager {
    func getStatus() -> UploadStatus {
        return status
    }
    
    func reset() {
        request = nil
        fileURL = nil
        progressTask = nil
        status = .none
        backgroundTask?.cancel()
    }
}


extension ImageUploadManager: ImageManagerResponseSendable {
    func responseSuccess() {
        print("😎responseSuccess😎")
        delegate?.responseSuccess()
        reset()
    }
    
    func responseFail(willContinue: Bool) {
        print("😎responseFail😎")
        delegate?.responseFail(willContinue: willContinue)
        if !willContinue {
            reset()
        }
    }
}

extension ImageUploadManager: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64,
                    totalBytesExpectedToSend: Int64) {
        
        if self.progressTask == nil {
            self.progressTask = task
            delegate?.progressTaskDidCreate()
            status = .uploading
        }
        
        
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("🤩\(progress)🤩")
        
        
        
        if progress >= 1 {
            delegate?.progressTaskCompleted()
            status = .modeling
        } else {
            delegate?.progressTaskIsProcessing(with: progress)
        }
    }
}

extension ImageUploadManager {
    
    private func writeFile(with body: Data) -> URL {
        let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = directoryURL.appendingPathComponent(APIConstants.boundary)
        let filePath = fileURL.path
        FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        let file = FileHandle(forWritingAtPath: filePath)!
        file.write(body)
        file.closeFile()
        
        return fileURL
    }
    
    private func cancelProgressTask(_ task: URLSessionTask) {
        print("🥰진행중인 task를 중지합니다.")
        task.cancel()
        self.progressTask = nil
    }
    
    private func resumeWithBackground(with request: URLRequest, fromFile fileURL: URL) {
        print("🥰백그라운드 task를 시작합니다.")
        let config = URLSessionConfiguration.background(withIdentifier: "com.melsplit.ZOOC.backgroundSession")
        let session = URLSession(configuration: config)
        
        backgroundTask = session.uploadTask(with: request, fromFile: fileURL)
        backgroundTask!.resume()
        
        self.request = nil
        self.fileURL = nil
    }
}
