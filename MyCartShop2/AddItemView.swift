//
//  AddItemView.swift
//  MyCartShop2
//
//  Created by ALUNO on 17/05/22.
//

import SwiftUI

struct AddItemView: View {
    
    @State var item: String = ""
    @State var valor: String = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack{
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
                
                DB_Manager().addItem(itemValue: self.item, valorValue: Double(self.valor) ?? 0.0)
                
                self.mode.wrappedValue.dismiss()}, label: { Text("Adicionar a Lista de Compras")
            })
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }.padding()
        
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
