//
//  ContentView.swift
//  cryptoMessageSender
//
//  Created by Sahil Sahu on 10/12/21.
//

import SwiftUI
import CryptoKit

struct CryptoMessageGeneratorView: View {
    
    @State private var messageToEncrypt = ""
    @State private var errorMessage = ""
    @State private var decryptedMessage = ""
    var privateKey: P256.KeyAgreement.PrivateKey
    
    init() {
        privateKey = Encryption.generatePrivateKey()
    }
    
    var body: some View {
        NavigationView {
            
            
            
            
            Form{
                
                Section(header: Text("Enter Secret Message")) {
                    
                    TextField("secret message", text: $messageToEncrypt)
                    
                    
                    
                    Button {
                        let publicKey = Encryption.extractPublicKeyFromPrivate(privateKey: privateKey)
                        do{
                            let symmetricKey = try Encryption.deriveSymmtericKey(privateKey: privateKey, publicKey: publicKey)
                            let encryptedMessage = try Encryption.encryptTest(text: messageToEncrypt, using: symmetricKey)
                            self.errorMessage = encryptedMessage
                            
                            self.decryptedMessage = Decrpytion.decryptText(text: encryptedMessage, using: symmetricKey)
                            
                        }
                        catch{
                            self.errorMessage = "failed encryption"
                        }
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("Encrypt")
                            Spacer()
                        }
                        
                    }
                    
                }
                
                Section(header: Text("Message after encrpyting")) {
                    Text(errorMessage)
                }
                
                Section(header: Text("Message after decrypting")) {
                    Text(decryptedMessage)
                }
                
            }
            
            .navigationTitle("Message Encryption")
            .background(Color(.init(white: 0, alpha:0.05)).ignoresSafeArea())
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoMessageGeneratorView()
    }
}
