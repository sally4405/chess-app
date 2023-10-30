//
//  BoardView.swift
//  ChessApp
//
//  Created by Se Eun Lee on 2023/10/18.
//

import SwiftUI

struct BoardView: View {
    var board = Board()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Rank.allCases, id: \.self) { rank in
                    LazyHStack(spacing: 0) {
                        ForEach(File.allCases, id: \.self) { file in
                            Rectangle()
                                .fill((file.value + rank.rawValue) % 2 == 0 ? Color.white : Color.yellow)
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    let piece = board.getPositionInfo(.init(rank, file))
                                    print(piece?.type.icon ?? "")
                                }
                                .overlay {
                                    let piece = board.getPositionInfo(.init(rank, file))
                                    Text(piece?.type.icon ?? "")
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                        }
                    }
                }
                .border(Color.yellow)
            }
        }
        .padding()
        .onAppear {
            board.initPiece(.black)
            board.initPiece(.white)
        }
    }
}

#Preview {
    BoardView()
}
