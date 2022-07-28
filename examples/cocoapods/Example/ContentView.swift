//
//  ContentView.swift
//  Example
//
//  Created by Scott on 2022/6/9.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = ViewModel()

    var body: some View {
        List {
            HStack {
                Button("ping") {
                    Task {
                        await viewModel.callPing()
                    }
                }.foregroundColor(.green)
                if let ping = viewModel.ping {
                    Text(String(ping))
                }
            }
            Section {
                Button("getLatestBlock") {
                    Task {
                        await viewModel.callGetLastest()
                    }
                }.foregroundColor(.green)
                if viewModel.latestBlockText.isEmpty == false {
                    Text(viewModel.latestBlockText)
                }
            }
            Section {
                Button("sendTransaction") {
                    Task {
                        await viewModel.sendTransaction()
                    }
                }.foregroundColor(.green)
                if viewModel.sendTransactionText.isEmpty == false {
                    Text(viewModel.sendTransactionText)
                }
                Button("getTransaction") {
                    Task {
                        await viewModel.getTransaction()
                    }
                }.foregroundColor(.green)
                if viewModel.getTransactionText.isEmpty == false {
                    Text(viewModel.getTransactionText)
                }
                Button("getTransactionResult") {
                    Task {
                        await viewModel.getTransactionResult()
                    }
                }.foregroundColor(.green)
                if viewModel.getTransactionResultText.isEmpty == false {
                    Text(viewModel.getTransactionResultText)
                }
            }
            Section {
                Button("getAccountAtLatestBlock") {
                    Task {
                        await viewModel.getAccountAtLatestBlock()
                    }
                }.foregroundColor(.green)
                if viewModel.getAccountAtLatestBlockText.isEmpty == false {
                    Text(viewModel.getAccountAtLatestBlockText)
                }
            }
            Section {
                Button("executeScriptAtLatestBlock") {
                    Task {
                        await viewModel.executeScriptAtLatestBlock()
                    }
                }.foregroundColor(.green)
                if viewModel.executeScriptAtLatestBlockText.isEmpty == false {
                    Text(viewModel.executeScriptAtLatestBlockText)
                }
            }
            Section {
                Button("getEventsForHeightRange") {
                    Task {
                        await viewModel.getEventsForHeightRange()
                    }
                }.foregroundColor(.green)
                if viewModel.getEventsForHeightRangeText.isEmpty == false {
                    Text(viewModel.getEventsForHeightRangeText)
                }
            }
            Section {
                Button("getNetworkParameters") {
                    Task {
                        await viewModel.getNetworkParameters()
                    }
                }.foregroundColor(.green)
                if viewModel.getNetworkParametersText.isEmpty == false {
                    Text(viewModel.getNetworkParametersText)
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
