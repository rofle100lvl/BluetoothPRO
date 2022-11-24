import Alamofire
import Foundation

extension SomeRealisation {
    fileprivate struct Const {
        static let api = "https://bluetoothpro.herokuapp.com"
    }
}

protocol ToNetworkManagerProtocol {
    func sendUser(user: User, completion: @escaping (() -> Void)) -> Void
    func fetchFriends(user: UUID, completion: @escaping (([UUID]) -> Void)) -> Void
    func fetchUsers(completion: @escaping (([UserDTO]) -> Void))
    func fetchUser(id: UUID, completion: @escaping ((UserDTO) -> Void))
    func addToFriend(query: AddToFriendQuery, completion: @escaping (() -> Void))

}

final class SomeRealisation: ToNetworkManagerProtocol {
    func sendUser(user: User, completion: @escaping (() -> Void)) {
        AF.request(Const.api + "/user", method: .post, parameters: user.dictionary).responseString { string in
            completion()
        }
    }
    
    func fetchUser(id: UUID, completion: @escaping ((UserDTO) -> Void)) {
        AF.request(Const.api + "/user" + "/\(id.uuidString)", method: .get)
            .responseDecodable(of: UserDTO.self) { response in
                switch response.result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    completion(user)
                }
            }
    }
    
    func fetchFriends(user: UUID, completion: @escaping (([UUID]) -> Void)) {
        AF.request(Const.api + "/user/friends/\(user.uuidString)", method: .get)
            .responseDecodable(of: [UUID].self) { response in
                switch response.result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let ids):
                    completion(ids)
                }
            }
    }
    
    func fetchUsers(completion: @escaping (([UserDTO]) -> Void)) {
        AF.request(Const.api + "/user", method: .get)
            .responseDecodable(of: [UserDTO].self) { response in
                switch response.result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let users):
                    print(users)
                }
            }
    }
    
    func addToFriend(query: AddToFriendQuery, completion: @escaping (() -> Void)) {
        AF.request(Const.api + "/user/friends/add", method: .post, parameters: query.dictionary).responseString { string in
            print(string)
            completion()
        }
    }
                  
}

