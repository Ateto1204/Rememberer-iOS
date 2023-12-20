import Foundation
import Alamofire
import Combine

class OpenAIService {
    
    let baseURL = "https://api.openai.com/v1/"
    
    func sendMessage(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        let body = OpenAICompletionsBody(model: "davinci-002", prompt: message, temperature: 0.7) 
     
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)"
        ]
        
        return Future { [weak self] promise in 
            
            guard let self = self else { return }
            
            AF.request(self.baseURL + "completions", method: .post, parameters: body, encoder: .json, headers: headers)
                .responseDecodable(of: OpenAICompletionsResponse.self) { response in 
                    
                    print("response.result")
                    
                    switch response.result {
                    case .success(let result): 
                        promise(.success(result))
                        
                    case .failure(let error): 
                        promise(.failure(error))
                    }
                    
                }
        }
        .eraseToAnyPublisher()
    }
}

struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
}

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionsChoice]
}

struct OpenAICompletionsChoice: Decodable {
    let text: String
}
