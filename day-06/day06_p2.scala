import scala.io.StdIn
import java.util.ArrayList

val MESSAGE_START_UNIQUE_COUNT = 14

@main def main() = 
    var line = StdIn.readLine()
    println(s"Message start: ${find_message_start(line.toList)}")

def find_message_start(sequence: List[Char]) = 
    find_first_unique_sequence(sequence, MESSAGE_START_UNIQUE_COUNT, 0)

def find_first_unique_sequence(sequence: List[Char], numUnique: Int, currentIndex: Int): Int =
    if (sequence.length >= numUnique) then {
        val sequenceToCheck = sequence.take(numUnique)
        
        if is_sequence_unique(sequenceToCheck) then {
            currentIndex + numUnique
        }  else {
            find_first_unique_sequence(sequence.drop(1), numUnique, currentIndex+1)
        }
    } else {
        -1
    }

def is_sequence_unique(sequence: List[Char]) = 
        sequence.forall((c: Char) => is_item_unique(sequence, c))

def is_item_unique(sequence: List[Char], item: Char) = 
    sequence.count((c: Char) => c == item) == 1


