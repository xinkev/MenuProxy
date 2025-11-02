import Foundation

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()

extension UserDefaults: KvStore {
    func set<T>(_ key: KvStoreKey<T>, _ value: T) {
        self.set(value, forKey: key.rawValue)
    }

    func get<T>(_ key: KvStoreKey<T>) -> T? {
        return self.object(forKey: key.rawValue) as? T
    }
    
    func setData<T: Encodable>(_ key: KvStoreKey<T>, _ value: T) {
        do {
            let encoded = try encoder.encode(value)
            self.set(encoded, forKey: key.rawValue)
        } catch {
            print("Error encoding.", error)
        }
    }

    func getData<T: Decodable>(_ key: KvStoreKey<T>) -> T? {
        guard let stored = self.data(forKey: key.rawValue) else { return nil }

        do {
            let decoded = try decoder.decode(T.self, from: stored)
            return decoded
        } catch {
            return nil
        }
    }
}
