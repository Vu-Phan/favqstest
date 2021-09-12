//
//  AudioRecord.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit
import AVFoundation

protocol PRMediaAudioRecordDelegate {
	func didStartAudioRecord(sender: Pr.media.audioRecord)
	func didStop(sender: Pr.media.audioRecord)
	func recordTimeUpdate(sender: Pr.media.audioRecord, progress: Double, limit: Double)
}

public extension Pr {
	class media: NSObject {
		// MARK:
		// MARK: __ Video
		// require: import AVKit
		public class video: NSObject {
			public static func getThumbnail(fromUrl: String, size: CGSize? = nil) -> UIImage? {
				var forSize = CGSize(width: 230, height: 230)
				if let size = size {
					forSize = size
				}

				if let urlVideo = URL(string: fromUrl) {
					let asset = AVAsset(url: urlVideo)
					return self.getImage(fromAsset: asset, size: forSize)
				}
				return nil
			}

			private static func getImage(fromAsset asset: AVAsset, size: CGSize) -> UIImage? {
				let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
				let assetImgGenerate = AVAssetImageGenerator(asset: asset)
				assetImgGenerate.appliesPreferredTrackTransform = true
				assetImgGenerate.maximumSize = size

				do {
					let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
					let thumbnail = UIImage(cgImage: img)
					return thumbnail
				} catch {
					print(error.localizedDescription)
					return nil
				}
			}
		}


		// MARK:
		// MARK: __ Audio
		public class audio: NSObject {
			public var player: AVAudioPlayer?

			public func playSound(name: String, ext: String) {
				guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }

				do {
					if #available(iOS 10.0, *) {
						try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
					} else {
						// Fallback on earlier versions
					}
					try AVAudioSession.sharedInstance().setActive(true)
					/// > iOS 11
					player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
					/// < iOS 10
					/// player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
					guard let player = player else { return }

					player.play()
				} catch let error {
					print(error.localizedDescription)
				}
			}
		}

		// MARK:
		// MARK: __ Audio record
		public class audioRecord: NSObject {
			var delegate:PRMediaAudioRecordDelegate?
			// - data
			public var audioRecorder: AVAudioRecorder?
			public var recordingSession : AVAudioSession!
			public var filename = "audio_record"
			private var filenameWithExt = "audio_record.caf"
			// - record timer
			private var timer:Timer?
			private var durationValue = TimeInterval.init()
			private var durationLimit = TimeInterval(600)
			// - UI
			private var durationText = "00:00"

			// MARK: ____ Init
			public init(name: String, limit: TimeInterval = TimeInterval(600)) {
				super.init()
				filename = name
				filenameWithExt = "\(name).caf"
				durationLimit = limit
			}

			public init(name: String, limit: TimeInterval = TimeInterval(600), onPermission: ((_ allowed: Bool) -> Void)?) {
				super.init()
				filename = name
				durationLimit = limit
				checkPermision(onPermission)
			}


			// MARK: ____ Public
			public func checkPermision(_ onPermission: ((_ allowed: Bool) -> Void)?) {
				recordingSession = AVAudioSession.sharedInstance()

				do {
					try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
					try recordingSession.setActive(true)
					recordingSession.requestRecordPermission() { allowed in
						DispatchQueue.main.async {
							if onPermission != nil {
								onPermission!(allowed)
							}
						}
					}
				} catch {
					print("failed to record!")
				}
			}

			public func getFileURL() -> URL {
				/// - Apple record file extension is .caf !
				let fileManager = FileManager.default
				let dirPaths = fileManager.urls(for: .cachesDirectory,
												in: .userDomainMask)
				return dirPaths[0].appendingPathComponent("filenameWithExt")
			}

			public func start() {
				let recordSettings =
					[AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
					 AVEncoderBitRateKey: 16,
					 AVNumberOfChannelsKey: 2,
					 AVSampleRateKey: 44100.0] as [String : Any]

				let audioSession = AVAudioSession.sharedInstance()
				do {
					audioRecorder = try AVAudioRecorder(url: getFileURL(),
														settings: recordSettings)
					audioRecorder?.delegate = self as? AVAudioRecorderDelegate
					audioRecorder?.prepareToRecord()
				} catch {
					print(error)
				}
				do {
					try audioSession.setActive(true)
					audioRecorder?.record()
				} catch {

				}

				durationValue = 0
				timer?.invalidate()
				timer = nil
				timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
			}

			public func stop() {
				audioRecorder?.stop()

				timer?.invalidate()
				timer = nil
				do {
					try AVAudioSession.sharedInstance().setActive(false)
				} catch {
					print(error)
				}
				delegate?.didStop(sender: self)
			}

			public func reset() {
				audioRecorder = nil
				durationValue = 0
				durationText = "00:00"
			}

			// MARK: ____ UI Handlers
			@objc public func updateTimer() {
				durationValue += 1

				// - progress time str
				let date = Foundation.Date.init(timeIntervalSinceReferenceDate: TimeInterval.init(durationValue))
				let formatter = DateFormatter.init()
				formatter.dateFormat = "mm:ss"
				if durationValue > (60 * 60) {
					formatter.dateFormat = "HH:mm:ss"
				}
				let progressTimeStr = formatter.string(from: date)
				durationText = progressTimeStr

				// - update timeline
				if durationValue > 0 {
					delegate?.recordTimeUpdate(sender: self, progress: durationValue, limit: durationLimit)
				}

				// - limit stop
				if durationValue >= durationLimit {
					stop()
				}
			}
		}
	}
}
