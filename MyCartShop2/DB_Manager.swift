//
//  DB_Manager.swift
//  MyCartShop2
//
//  Created by ALUNO on 17/05/22.
//

import Foundation
// import library
import SQLite
import SQLite3

class DB_Manager{
    //sqlite inst
    private var db: Connection!
    //tb inst
    private var lista: Table!
    //cols inst
    private var id: Expression<Int64>!
    private var item: Expression<String>!
    private var valor: Expression<Double>!
    
    //Construtor
    init(){
        
        do{
            //path
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            //Conexao c/ bd
            db = try Connection("\(path)/my_compras.sqlite3")
            
            //Criar tabela
            lista = Table("lista")
            
            //Criar instancias das colunas
            id = Expression<Int64>("id")
            item = Expression<String>("item")
            valor = Expression<Double>("valor")
            
            //Verificar se a tabela ja foi criada
            if (!UserDefaults.standard.bool(forKey: "is_db_created")){
                
                //Se nao, cria a tabela
                try db.run(lista.create{ (t) in
                    t.column(id, primaryKey: true)
                    t.column(item)
                    t.column(valor)
                })
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // INSERT dos itens
    public func addItem(itemValue: String, valorValue: Double = 0.0){
        do {
            try db.run(lista.insert(item <- itemValue, valor <- valorValue))
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // SELECT p/ listar itens
    public func getItens() -> [CartModel]{
        
        var cartModels: [CartModel] = []
        
        lista = lista.order(id.asc)
        
        do{
            //Iterar pelos itens com loop for
            for item_compra in try db.prepare(lista){
                let cartModel: CartModel = CartModel()
                cartModel.id = item_compra[id]
                cartModel.item = item_compra[item]
                cartModel.valor = item_compra[valor]
                cartModels.append(cartModel)
            }
        }catch{
            print(error.localizedDescription)
        }
        return cartModels
    }
    
    
    public func selectVals() -> [CartModel]{
        
        var cartModels2: [CartModel] = []
        lista = lista.select(valor)
        do{
            for item_compra in try db.prepare(lista){
                let cartModel2: CartModel = CartModel()
                cartModel2.valor += item_compra[valor]
                cartModels2.append(cartModel2)
            }
        }catch{
            print(error.localizedDescription)
        }
        return cartModels2
    }
    
    
    // OBTER um unico item da lista
    public func getItem(idValue: Int64) -> CartModel {
        
        let cartModel: CartModel = CartModel() //Criar objeto vazio
        
        do {
            let item_compra: AnySequence<Row> = try db.prepare(lista.filter(id == idValue)) //Obter o item pelo ID
            
            //Obter a linha
            try item_compra.forEach({ (rowValue) in
                
                //Setar valores no model
                cartModel.id = try rowValue.get(id)
                cartModel.item = try rowValue.get(item)
                cartModel.valor = try rowValue.get(valor)
    
            })
        }catch{
            print(error.localizedDescription)
        }
        return cartModel //Retornar o model
    }
    
    
    // UPDATE p/ editar as informacoes do item
    public func updateItem(idValue: Int64, itemValue: String, valorValue: Double = 0.0){
        do{
            let item_compra: Table = lista.filter(id == idValue) //Obter o item pelo ID
            
            try db.run(item_compra.update(item <- itemValue, valor <- valorValue)) //Executa a query
        
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    // DELETE p/ deletar um item
    public func deleteItem(idValue: Int64){
        do{
            let item_compra: Table = lista.filter(id == idValue) //Obter o item pelo ID
            
            try db.run(item_compra.delete()) //Executa a query
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
