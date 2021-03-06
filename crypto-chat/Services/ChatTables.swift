//
//  ChatViewController.ext.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/24/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import SwiftyJSON

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == msgsTableView ? msgs.count : chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == chatsTableView) {
            let chat = chats[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
            cell.setChat(chat: chat)
            
            cell.selectionColor = UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1)
            
            return cell
        }
        
        let msg = msgs[indexPath.row]
        if (msg.userId == self.userId) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageRightCell") as! MessageRightCell
            cell.setMessage(message: msg)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageLeftCell") as! MessageLeftCell
            cell.setMessage(message: msg)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == chatsTableView) {
            socket.socketOn(event: "add-message-response", callback: { data in
                let json = JSON(data)[0]
                
                if (json["fromUserId"].stringValue == self.selectedChatId) {
                    self.msgs.append(Message(
                        userId: json["fromUserId"].stringValue,
                        msg: json["message"].stringValue,
                        time: "xx:xx"
                    ))
                    self.updateMessages()
                }
            })
            
            self.selectedChatId = chats[indexPath.row].chatId

            getMessages(chatId: self.selectedChatId)
            
            topBarUsername.text = chats[indexPath.row].name
            topBarAvatar.image = chats[indexPath.row].avatar
            topBarChatType.image = chats[indexPath.row].chatTypeSelected
        }
    }
    
    func updateMessages() {
        self.msgsTableView.reloadData()
        if self.msgs.count > 0 {
            self.msgsTableView.scrollToRow(at: IndexPath(item:self.msgs.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
}
