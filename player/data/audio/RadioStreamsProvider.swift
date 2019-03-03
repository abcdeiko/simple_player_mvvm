import Foundation
import RxSwift

class RadioStreamsProvider: RadioStreamsProviderProtocol {
    
    private static let items = [
        RadioStreamModel(title: "Радио 1", url: "http://bigtunesradio.com:8000/bass.mp3"),
        RadioStreamModel(title: "Радио 2", url: "http://airspectrum.cdnstream1.com:8018/1606_192"),
        RadioStreamModel(title: "Радио 3", url: "http://uk7.internet-radio.com:8226/;stream")
    ]
    
    func getAudioList() -> Observable<[RadioStreamModel]> {
        return Observable
            .just(RadioStreamsProvider.items)
    }
}
