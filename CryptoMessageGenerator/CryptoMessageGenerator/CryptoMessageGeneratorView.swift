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
    @State private var equal = ""

    
    var body: some View {
        NavigationView {
            
            
            Form{
                
                Section(header: Text("Enter Secret Message")) {
                    
                    TextField("secret message", text: $messageToEncrypt)
                    
                    
                    
                    Button {
                        let privateKey = Encryption.generatePrivateKey()
                        
                        let publicKey = Encryption.extractPublicKeyFromPrivate(privateKey: privateKey)
                        
                        do{
                            let k2 = Encryption.generatePrivateKey()
                            let pb = Encryption.extractPublicKeyFromPrivate(privateKey: k2)
                            let symmetricKey = try Encryption.deriveSymmtericKey(privateKey: privateKey, publicKey: pb)
                            let encryptedMessage = try Encryption.encryptTest(text: messageToEncrypt, using: symmetricKey)
                            self.errorMessage = encryptedMessage
                            
                            
                            
                            let sym = try Encryption.deriveSymmtericKey(privateKey: k2, publicKey: publicKey)
                            
                            
                            
                            self.decryptedMessage = Decrpytion.decryptText(text: encryptedMessage, using: sym)
                            
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
                    Text( decryptedMessage)
                    
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
