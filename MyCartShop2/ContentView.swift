//
//  ContentView.swift
//  MyCartShop2
//
//  Created by ALUNO on 17/05/22.
//

import SwiftUI
import SwiftUIFontIcon
import PopupView

struct ContentView: View {
    
    //Array de itens
    @State var cartModels: [CartModel] = []
    
    //Verificar item selecionado para edicao
    @State var itemSelected: Bool = false
    
    //ID do item selecionado p/ editar ou deletar
    @State var selectedItemId : Int64 = 0
    
    @State var isShowingPopUp = false
    
    @State var soma : Double = 0.0
    
    var body: some View {
        
        NavigationView{
            VStack{
                HStack{
                    Spacer()
                    NavigationLink(destination: AddItemView(), label: {
                        Text("Adicionar")
                    })
                }
                
                NavigationLink (destination: EditItemView(id: self.$selectedItemId), isActive: self.$itemSelected){
                    EmptyView()
                }
                
                List (self.cartModels){ (model) in
                    HStack{
                        Text(model.item)
                        Spacer()
                        Text("R$ \(model.valor, specifier: "%.2f")")
                        
                        Spacer()
                        //Botao p/ editar
                        Button(action: {
                            self.selectedItemId = model.id
                            self.itemSelected = true
                        }, label: {
                            //Text("ED")
                            FontIcon.text(.materialIcon(code: .build))
                            .foregroundColor(Color.blue)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        
                        Button(action: {
                            let dbManager: DB_Manager = DB_Manager()
                            
                            dbManager.deleteItem(idValue:model.id)
                            
                            self.cartModels = dbManager.getItens()
                            
                        }, label: {
                            //Text("X")
                            FontIcon.text(.materialIcon(code: .delete_sweep))
                            .foregroundColor(Color.red)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                Button(action: {
                    self.isShowingPopUp = true
                    self.cartModels = DB_Manager().selectVals()
                }, label: {
                    Text("Calcular Total")
                        .frame(width:220, height:50, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(8)
                        .padding()
                })
                
                
            }
            .popup(isPresented: $isShowingPopUp, type: .toast, position: .bottom, animation: .easeIn, autohideIn: 5, closeOnTap: true, closeOnTapOutside: true, view:{ Toast()
            })
            .padding()
            .navigationBarTitle("Lista de compras")
            // carregar dados no array
            .onAppear(perform: {
                self.cartModels = DB_Manager().getItens()
            })
        }
    }
}

struct Toast: View{
    
    @State var cartModels2: [CartModel] = []
    
    //@State var soma: Double = 0.0
    
    var body: some View{
        ZStack{
            Color.gray
            List(self.cartModels2){ (model2) in
                HStack (){
                    FontIcon.text(.materialIcon(code: .monetization_on))
                        .foregroundColor(Color.yellow)
                    Text("Total: R$ \(model2.valor, specifier: "%.2f")")
                }
            }
        }
        .frame(width: 250, height: 100, alignment: .center)
        .cornerRadius(12)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
