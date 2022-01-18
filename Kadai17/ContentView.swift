//
//  ContentView.swift
//  Kadai17
//
//  Created by mana on 2022/01/18.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    var name: String
    var isChecked: Bool
}

struct ContentView: View {
    private enum Mode {
        case add, edit
    }

    @State private var isShowAddEditView = false
    @State private var name = ""
    @State private var mode: Mode = .add
    @State private var editId = UUID()
    @State private var items: [Item] = [.init(name: "りんご", isChecked: false),
                                        .init(name: "みかん", isChecked: true),
                                        .init(name: "バナナ", isChecked: false),
                                        .init(name: "パイナップル", isChecked: true)]

    var body: some View {
        NavigationView {
            List {
                ForEach($items) { $item in
                    HStack {
                        ItemView(item: $item)
                            .onTapGesture {
                                item.isChecked.toggle()
                            }

                        Spacer()

                        Label("", systemImage: "info.circle")
                            .onTapGesture {
                                mode = .edit
                                editId = item.id
                                name = item.name
                                isShowAddEditView = true
                            }
                    }
                }
                .onDelete { items.remove(atOffsets: $0) }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        mode = .add
                        name = ""
                        isShowAddEditView = true
                    }, label: { Image(systemName: "plus") })
                }
            }
        }
        .fullScreenCover(isPresented: $isShowAddEditView) {
            AddOrEditItemView(isShowView: $isShowAddEditView, name: $name) { item, editName in
                switch mode {
                case .add:
                    items.append(item)
                case .edit:
                    guard let targetIndex = items.firstIndex(where: { $0.id == editId }) else { return }
                    items[targetIndex].name = editName
                }
            }
        }
    }
}

struct AddOrEditItemView: View {
    @Binding var isShowView: Bool
    @Binding var name: String
    let didSave: (Item, String) -> Void

    var body: some View {
        NavigationView {
            HStack(spacing: 30) {
                Text("名前")
                    .padding(.leading)

                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.trailing)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowView = false
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        didSave(.init(name: name, isChecked: false), name)
                        isShowView = false
                    }
                }
            }
        }
    }
}

struct ItemView: View {
    @Binding var item: Item
    private let checkMark = Image(systemName: "checkmark")

    var body: some View {
        HStack {
            if item.isChecked {
                checkMark.foregroundColor(.orange)
            } else {
                checkMark.hidden()
            }

            Text(item.name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AddOrEditItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrEditItemView(isShowView: .constant(true), name: .constant("みかん"), didSave: { _, _ in })
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: .constant(.init(name: "みかん", isChecked: true)))
    }
}
