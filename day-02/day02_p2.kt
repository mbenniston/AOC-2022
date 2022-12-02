
fun main() {
    var score = 0

    var line: String? = readLine()
    while (line != null)
    {
        val tokens =  line.split(' ')
        val theirMove = getMoveFromSymbol(tokens[0])
        val desiredResult = getResultFromSymbol(tokens[1])

        val desiredMove = getDesiredMoveFromResult(theirMove, desiredResult)
        score += getMoveScore(desiredMove) + getResultScore(desiredResult)
        line = readLine();
    }

    println(score)
}

fun getMoveFromSymbol(move_symbol: String) : Move = when (move_symbol){
    "A" -> Move.Rock
    "B" -> Move.Paper
    "C" -> Move.Scissors
    else -> throw IllegalArgumentException()
}

fun getResultFromSymbol(resultSymbol: String) : Result = when (resultSymbol) {
    "X" -> Result.Lose
    "Y" -> Result.Draw
    "Z" -> Result.Win
    else -> throw IllegalArgumentException()
}

fun getDesiredMoveFromResult(theirMove: Move, desiredResult: Result): Move = when(Pair(theirMove, desiredResult)){
    Pair(Move.Rock, Result.Lose) -> Move.Scissors
    Pair(Move.Rock, Result.Draw) -> Move.Rock
    Pair(Move.Rock, Result.Win) -> Move.Paper
    Pair(Move.Paper, Result.Lose) -> Move.Rock
    Pair(Move.Paper, Result.Draw) -> Move.Paper
    Pair(Move.Paper, Result.Win) -> Move.Scissors
    Pair(Move.Scissors, Result.Lose) -> Move.Paper
    Pair(Move.Scissors, Result.Draw) -> Move.Scissors
    Pair(Move.Scissors, Result.Win) -> Move.Rock
    else -> throw IllegalArgumentException()
}

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