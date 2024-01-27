import Foundation
import Alamofire
import Combine

class OpenAIService {
    
    let endpointURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(messages: [Message], completion: @escaping (OpenAIChatResponse?) -> Void) {
        let openAIMessages = messages.map({ OpenAIChatMessage(role: $0.role, content: $0.content)})
        let body = OpenAIChatBody(model: "gpt-3.5-turbo-16k-0613", messages: openAIMessages)
        
        guard let url = URL(string: endpointURL) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Constants.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = try JSONEncoder().encode(body)
            request.httpBody = requestBody
        } catch {
            print("request error")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("response error")
                completion(nil)
                return
            }
            
            do {
                let openAIResponse = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
                completion(openAIResponse)
            } catch {
                print("decode error")
                completion(nil)
            }
        }.resume()
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

struct Question: Codable {
    let question: String
    let options: [String]
    let answer: String
    let explanation: String
}
