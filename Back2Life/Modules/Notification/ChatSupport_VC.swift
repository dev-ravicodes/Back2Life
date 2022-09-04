//
//  ChatSupport_VC.swift
//  Back2Life
//
//  Created by Mohini's Mac on 12/10/21.
//

import UIKit
import Designable

class ChatSupport_VC: MainBaseViewController {
    
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak var txt_Message: UITextView!
    
    
    //MARK: - Properties
    var router : HTTPRequest<AuthenticationEndPoint>?
    var ticketsData: [GetTicketsData] = []
    var consumerId: Int?
    var ticketId: Int?

    

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_Message.layer.cornerRadius = 5
        txt_Message.layer.borderWidth = 0.5
        txt_Message.layer.borderColor = UIColor.gray.cgColor
    }
    
    
    //MARK: - Interface Builder Actions
    @IBAction func btn_Submit(_ sender: DesignableButton) {
        self.callingCreateTicketsAPI()
    }
    
    
    //MARK: - Helpers
    private func callingCreateTicketsAPI() {
        self.showActivity()
        let parameters = ["reason": "Any Reason","comment": txt_Message.text ?? ""] as [String : Any]
        var request = URLRequest(url: URL(string: "http://52.14.21.106:5000/api/v1/create-ticket")!,timeoutInterval: Double.infinity)
        request.addValue(UserStoreSingleton.shared.userToken ?? "", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                self.hideActivity()
            }
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(CreateTicketModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        self.hideActivity()
                        let responseMessage = json.status;
                        if responseMessage == 200 {
                            self.showMessage(json.message ?? "")
                            self.callingGetTicketsAPI()
                        }else{
                            self.hideActivity()
                            self.showMessage(json.message ?? "")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()

    }
    
    private func callingGetTicketsAPI() {
            self.showActivity()
            var request = URLRequest(url: URL(string: "http://52.14.21.106:5000/api/v1/get-tickets")!,timeoutInterval: Double.infinity)
            request.addValue("\(UserStoreSingleton.shared.userToken ?? "")", forHTTPHeaderField:"Authorization")
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let json =  try JSONDecoder().decode(GetTicketsModel.self, from: data ?? Data())
                    debugPrint(json)
                    DispatchQueue.main.async {
                        self.hideActivity()
                        self.ticketsData = json.data!
                        self.ticketId = self.ticketsData[0].id
                        self.consumerId = self.ticketsData[0].consumer_id
                        self.callingReplyTicketsAPI()
                    }
                } catch {
                    self.hideActivity()
                    print(error)
                }
            }
            task.resume()
        }
    
    private func callingReplyTicketsAPI() {
        let parameters = ["message": "Any Reason","tickets_id": ticketId ?? ""] as [String : Any]
        var request = URLRequest(url: URL(string: "http://52.14.21.106:5000/api/v1/reply-tickets")!,timeoutInterval: Double.infinity)
        request.addValue(UserStoreSingleton.shared.userToken ?? "", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                self.hideActivity()
            }
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(CreateTicketModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        self.hideActivity()
                        let responseMessage = json.status;
                        if responseMessage == 200 {
                            self.showMessage(json.message ?? "")
                            self.callingGetTicketReplyAPI()
                        }else{
                            self.hideActivity()
                            self.showMessage(json.message ?? "")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    private func callingGetTicketReplyAPI() {
        self.showActivity()
        var request = URLRequest(url: URL(string: "http://52.14.21.106:5000/api/v1/get-tickets-reply/\(ticketId!)")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.userToken ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetTicketsReplyModel.self, from: data ?? Data())
                debugPrint(json)
                DispatchQueue.main.async {
                    self.hideActivity()
                    
                }
            } catch {
                self.hideActivity()
                print(error)
            }
        }
        task.resume()
    }
}

extension ChatSupport_VC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Nachricht eingeben" {
            textView.text = ""
        }
    }
}
