//
//  EditItemView.swift
//  MyCartShop2
//
//  Created by ALUNO on 18/05/22.
//

import SwiftUI

struct EditItemView: View {
    
    @Binding var id: Int64
    
    @State var item: String = ""
    @State var valor: String = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack {
            
            TextField("Item:", text: $item)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
            
            TextField("Valor:", text: $valor)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
                .keyboardType(.numbersAndPunctuation)
            
            Button(action: {
                
                DB_Manager().updateItem(idValue: self.id, itemValue: self.item, valorValue: Double(self.valor) ?? 0.00)
                
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Salvar")
            }).frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
                .padding(.bottom, 10)
        }.padding()
            .onAppear(perform: {
                let cartModel: CartModel = DB_Manager().getItem(idValue: self.id)
                self.item = cartModel.item
                self.valor = String(cartModel.valor)
            })
        
    }
}

struct EditItemView_Previews: PreviewProvider {
    
    @State static var id: Int64 = 0
    
    static var previews: some View {
        EditItemView(id: $id)
    }
}
