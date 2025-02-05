// MARK: - Bu Swift kodu, Combine framework'i kullanarak asenkron ağ (network) isteklerini yürütmek için bir servis oluşturur. Kod, Future ve Combine yayıncıları (publishers ile veri çekme ve hata yönetimi işlemlerini yürütüyor.

import Foundation
import Combine


/// NetworkServiceProtocol, ağ isteği  yapmak için bir request fonksiyonu tanımlar.
protocol NetworkServiceProtocol {
    
    /// 'request' fonksiyonu:
    /// Generic bir tür (T: Decodable) ile çalışır -> Dönen verinin JSON'dan çözümlenebilmesini sağlar.
    /// Future<T, Error> döndürür -> Gelecekte bir başarı ( T ) veya hata ( Error ) döneceğini garanti eden bir Combine yayıncısıdır.
    /// url: String parametresi, istek yapılacak URL'yi belirtir.
    func request<T: Decodable>(url: String, decodeType: T.Type) -> Future<T, Error>
}


/// final class -> Kalıtımı engeller, yani başka sınıflar bu sınıftan türeyemez.
/// NetworkServiceProtocol ’ü uygular, yani request metodunu içerir.
final class NetworkService: NetworkServiceProtocol {

    /// Combine framework 'ünde kullanılan iptal edilebilir ( Cancellable ) işlemleri saklar.
    /// Bellek sızıntılarını (memory leaks) önlemek için kullanılır.
    private var cancellables = Set<AnyCancellable>()

    /// Gelen url adresine HTTP isteği yapar, yanıtı decodeType türüne çözümler ve br Future<T, Error> döndürür.
    ///  Veri çekme işlemi asenkron olarak çalışır.
    func request<T: Decodable>(url: String, decodeType: T.Type) -> Future<T, Error> {
        
        return Future<T, Error> { [weak self] promise in // self burada zayıf (weak) olarak tutuluyor. Böylece, ağ isteği sırasında self'in tutulduğu nesne (örneğin, bir ViewModel) ortadan kalkarsa retain cycle oluşmasını engeller.
            
            /// Güvenlik Kontrolleri
            /// URL(string: url) kontrolü -> Geçerli bir URL olup olmadığı denetlenir, aksi takdirde invalidURL hatası döndürülür.
            guard let self = self,
                  let url = URL(string: url) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            /// URLSessionConfiguration.default kullanılarak bir oturum oluşturulur.
            /// timeoutIntervalForResource = 60.0 -> 60 saniye boyunca yanıt alınmazsa zaman aşımına uğrar.
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = 60.0 // 60 seconds
            let session = URLSession(configuration: configuration)
            
            /// Veri İsteği ve Yanıt İşleme
            session.dataTaskPublisher(for: url) ///URL'ye HTTP isteği yapar ver bir Combine yayıncısı ( Publisher ) döndürür.
            
            /// tryMap Bloğu - Yanıttaki HTTP durum kodunu ( statusCode ) kontrol eder.
            /// Eğer 200 OK değilse, hata fırlatır ( throw NetworkError.invalidResponse )
                .tryMap { (data, response) -> Data in
                    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                        throw NetworkError.invalidResponse
                    }
                    return data
                }
            
                /// decode(type: decodeType.self, decoder: JSONDecoder()) -> Gelen JSON verisini belirtilen decodeType türüne çözümler.
                .decode(type: decodeType.self, decoder: JSONDecoder())
            
                /// receive(on: RunLoop.main)  -> İşlemi ana iş parçacığında ( main thread ) çalıştırır.
                .receive(on: RunLoop.main)
            
                /// Combine Sink ile Hata ve Veri Yönetimi
                /// Hata Durumu ( completion bloğu )
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError: /// JSON verisi çözülememişse yakalanır.
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:  /// API hata mesajı içeriyorsa yakalanır.
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown)) /// Diğer durumlar için NetworkError.unknown atanır.
                        }
                    }
                } receiveValue: { /// Başarılı Durum ( receiveValue bloğu )
                    promise(.success($0))  /// Veri başarıyla alındığında promise( .success($0) ) çağrılır ve sonuç döndürülür.
                }
                .store(in: &self.cancellables)
                /// Combine aboneliğini cancellables içine kaydedilir.
                ///  Böylece istek tanımlandığında otomatik olarak iptal edilebilir (cancel) hale gelir ve retain cycle önlenir.
        }
    }

}
