
fun main() {
    var score = 0

    var line: String? = readLine()
    while (line != null)
    {
        val tokens =  line.split(' ')
        val theirMove = getMoveFromSymbol(tokens[0])
        val yourMove = getMoveFromSymbol(tokens[1])
        score += getGameScore(theirMove, yourMove)
        line = readLine();
    }

    println(score)
}

fun getMoveFromSymbol(moveSymbol: String) : Move = when (moveSymbol){
    "A","X" -> Move.Rock
    "B","Y" -> Move.Paper
    "C","Z" -> Move.Scissors
    else -> throw IllegalArgumentException()
}


fun getGameScore(theirMove: Move, yourMove: Move): Int =
    getMoveScore(yourMove) + getResultScore(getGameResult(theirMove, yourMove))


fun getMoveScore(move: Move) = when(move) {
    Move.Rock -> 1
    Move.Paper -> 2
    Move.Scissors -> 3
}

fun getResultScore(result: Result) = when(result) {
    Result.Lose -> 0
    Result.Draw -> 3
    Result.Win -> 6
}

fun getGameResult(theirMove: Move, yourMove: Move): Result = when(Pair(theirMove, yourMove)){
    Pair(Move.Rock, Move.Rock) -> Result.Draw
    Pair(Move.Rock, Move.Paper) -> Result.Win
    Pair(Move.Rock, Move.Scissors) -> Result.Lose
    Pair(Move.Paper, Move.Rock) -> Result.Lose
    Pair(Move.Paper, Move.Paper) -> Result.Draw
    Pair(Move.Paper, Move.Scissors) -> Result.Win
    Pair(Move.Scissors, Move.Rock) -> Result.Win
    Pair(Move.Scissors, Move.Paper) -> Result.Lose
    Pair(Move.Scissors, Move.Scissors) -> Result.Draw
    else -> throw IllegalArgumentException()
}

enum class Move {
    Rock,
    Paper,
    Scissors
}

enum class Result {
    Lose,
    Draw,
    Win
}