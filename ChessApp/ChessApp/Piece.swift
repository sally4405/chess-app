//
//  Piece.swift
//  ChessApp
//
//  Created by Se Eun Lee on 2023/10/18.
//

import Foundation

// TODO: PieceType enum과 역할이 불분명함. 차라리 protocol로 만드는 것도?
// PieceType에서도 color를 뽑을 수 있을거 같긴한데, 역할 분리가 더 애매해지는 느낌

//protocol Piece: Equatable {
//    func getMovablePositions(from position: Position) -> [Position] {}
//}

class Piece: Equatable {
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.color == rhs.color && lhs.type == rhs.type
    }

    let color: PieceColor
    let type: PieceType

    init(_ color: PieceColor, _ type: PieceType) {
        self.color = color
        self.type = type
    }

    func getMovablePositions(from position: Position) -> [Position] {
        return self.type.actionList.map { action in
            // TODO: 계산 로직은 Action 객체나 Position 쪽으로 역할을 분리하는게 나을지?
            let movedRow = position.rank.rawValue + action.rowAction
            let movedColumn = position.file.value + action.columnAction

            guard let newRank = Rank(rawValue: movedRow),
                  let newFile = File(movedColumn) else {
                return nil
            }

            return Position(newRank, newFile)
        }.compactMap { $0 }
    }
}

enum PieceColor: String {
    case black, white
}

enum PieceType: Equatable, CustomStringConvertible {
    static var allCases: (PieceColor) -> [PieceType] {
        { color in return [.pawn(color), .bishop(color), .knight(color), .rook(color), .queen(color), .king(color)] }
    }

    case pawn(_ color: PieceColor? = nil)
    case bishop(_ color: PieceColor? = nil)
    case knight(_ color: PieceColor? = nil)
    case rook(_ color: PieceColor? = nil)
    case queen(_ color: PieceColor? = nil)
    case king(_ color: PieceColor? = nil)
}

extension PieceType {
    var description: String {
        switch self {
        case .pawn: return "pawn"
        case .bishop: return "bishop"
        case .knight: return "knight"
        case .rook: return "rook"
        case .queen: return "queen"
        case .king: return "king"
        }
    }

    var icon: String {
        switch self {
        case .pawn(let color):
            return color == .black ? "♟" : "♙"
        case .bishop(let color):
            return color == .black ? "♝" : "♗"
        case .knight(let color):
            return color == .black ? "♞" : "♘"
        case .rook(let color):
            return color == .black ? "♜" : "♖"
        case .queen(let color):
            return color == .black ? "♛" : "♕"
        case .king(let color):
            return color == .black ? "♚" : "♔"
        }
    }

    var point: Int {
        switch self {
        case .pawn: return 1
        case .bishop: return 3
        case .knight: return 3
        case .rook: return 5
        case .queen: return 9
        case .king: return 0
        }
    }

    var initPositions: [Position] {
        switch self {
        case .pawn(let color):
            if color == .black {
                return File.allCases.map { Position(.two, $0) }
            } else {
                return File.allCases.map { Position(.seven, $0) }
            }
        case .bishop(let color):
            if color == .black {
                return [Position(.one, .C), Position(.one, .F)]
            } else {
                return [Position(.eight, .C), Position(.eight, .F)]
            }
        case .knight(let color):
            if color == .black {
                return [Position(.one, .B), Position(.one, .G)]
            } else {
                return [Position(.eight, .B), Position(.eight, .G)]
            }
        case .rook(let color):
            if color == .black {
                return [Position(.one, .A), Position(.one, .H)]
            } else {
                return [Position(.eight, .A), Position(.eight, .H)]
            }
        case .queen(let color):
            if color == .black {
                return [Position(.one, .E)]
            } else {
                return [Position(.eight, .E)]
            }
        case .king(let color):
            if color == .black {
                return [Position(.one, .D)]
            } else {
                return [Position(.eight, .D)]
            }

        }
    }

    var actionList: [Action] {
        switch self {
        case .pawn(let color):
            if color == .black {
                return [Action(rowAction: 1)]
            } else {
                return [Action(rowAction: -1)]
            }
        case .bishop:
            return Action.getContinuosAction(.init(rowAction: 1, columnAction: 1))
            + Action.getContinuosAction(.init(rowAction: 1, columnAction: -1))
            + Action.getContinuosAction(.init(rowAction: -1, columnAction: -1))
            + Action.getContinuosAction(.init(rowAction: -1, columnAction: 1))
        case .knight:
            return [Action(rowAction: 2, columnAction: 1, true), 
                    Action(rowAction: 2, columnAction: -1, true),
                    Action(rowAction: -2, columnAction: 1, true),
                    Action(rowAction: -2, columnAction: -1, true),
                    Action(rowAction: 1, columnAction: 2, false),
                    Action(rowAction: -1, columnAction: 2, false),
                    Action(rowAction: 1, columnAction: -2, false),
                    Action(rowAction: -1, columnAction: -2, false)]
        case .rook:
            return Action.getContinuosAction(.init(rowAction: 1)) 
            + Action.getContinuosAction(.init(rowAction: -1))
            + Action.getContinuosAction(.init(columnAction: 1))
            + Action.getContinuosAction(.init(columnAction: -1))
        case .queen:
            return Action.getContinuosAction(.init(rowAction: 1, columnAction: 1)) 
            + Action.getContinuosAction(.init(rowAction: 1, columnAction: -1))
            + Action.getContinuosAction(.init(rowAction: -1, columnAction: -1))
            + Action.getContinuosAction(.init(rowAction: -1, columnAction: 1))
            + Action.getContinuosAction(.init(rowAction: 1))
            + Action.getContinuosAction(.init(rowAction: -1))
            + Action.getContinuosAction(.init(columnAction: 1))
            + Action.getContinuosAction(.init(columnAction: -1))
        case .king:
            return [Action(rowAction: 1), Action(rowAction: -1), 
                    Action(columnAction: 1), Action(columnAction: -1),
                    Action(rowAction: 1, columnAction: 1),
                    Action(rowAction: 1, columnAction: -1),
                    Action(rowAction: -1, columnAction: -1),
                    Action(rowAction: -1, columnAction: 1)]
        }
    }
}
