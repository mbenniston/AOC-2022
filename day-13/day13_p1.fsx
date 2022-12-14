open System.IO
open System

// Parsing functions

let rec takeWhile characters pred acc =
    match characters with 
    | [] -> ([], acc)
    | x :: xs -> if pred x then takeWhile xs pred (acc @ [x]) else (characters, acc)

let parseInt characters = 
    let (leftOver, numChars)= takeWhile [for c in characters -> c] Char.IsDigit []

    (leftOver, Int32.Parse  (new String (numChars|> List.toArray)))
   
// Recursive list  (list that can contain lists)
type DeepListOfNumbers = 
    | Number of int
    | DeepList of list<DeepListOfNumbers> 

// Combines two deep lists
let rec combine l r = 
    match l with
    | DeepList ls -> DeepList (ls@[r])
    | Number n -> match r with  
                    | DeepList ls -> DeepList ((Number n)::ls)
                    | Number rn -> (combine DeepList[Number n] DeepList[Number rn])

// Parses a multidimensional list
let rec parseListRec characters acc = 
    match characters with
    | [] -> ([], acc)
    | x :: xs -> match x with
                    | '[' -> let (remaining, parsedList) = parseListRec xs (DeepList []) in (parseListRec remaining (combine acc parsedList)) 
                    | ',' -> parseListRec xs acc
                    | ']' ->  (xs, acc)
                    | _ when Char.IsDigit x -> let (remainder, i) = (parseInt characters) in (parseListRec remainder (combine acc (Number i)))
                    | _ -> (parseListRec xs acc)
                          
let parseList characters = 
    match snd (parseListRec characters DeepList[]) with
    | Number n -> DeepList []
    | DeepList l-> l.Head

// Compare packets

type Result = InOrder | OutOfOrder | Indeterminate 

type ComparePacket = DeepListOfNumbers -> DeepListOfNumbers -> Result

let compareNumber l r =
    if l < r then 
        InOrder 
    elif r < l then 
        OutOfOrder 
    else 
        Indeterminate

let rec comparePacket:ComparePacket = fun left right -> 
    match left with
    | Number ln -> match right with
                    | Number rn -> compareNumber ln rn
                    | DeepList rls -> comparePacket (DeepList [Number ln]) (DeepList rls)
    | DeepList lls -> match lls with
                        | [] -> match right with
                                        // left ran out first
                                        | Number rn -> InOrder
                                        | DeepList rls -> match rls with
                                                            // both ran out
                                                            | [] -> Indeterminate
                                                            // left ran out first
                                                            | r::rs -> InOrder
                        | l::ls -> match right with
                                        // right is number, convert to list
                                        | Number rn -> comparePacket  (DeepList lls) (DeepList [Number rn])
                                        | DeepList rls ->  match rls with
                                                            // right ran out first 
                                                            | [] -> OutOfOrder 
                                                            // compare both va
                                                            | r::rs -> let result = (comparePacket l r) in if (result <> Indeterminate) then result else (comparePacket (DeepList ls) (DeepList rs))

// takes two lines an compares them 
let rec compareLines lines = 
    match lines with
    | line1::line2::lines-> (comparePacket line1 line2)::compareLines lines
    | _ -> []

let lines = File.ReadLines("input.txt")

// Parsers the lines into a list of DeepLists
let parsedLines = lines |> Seq.filter (fun line -> line <> "") |> Seq.map (fun line -> [for c in line ->c]) |> Seq.map parseList

// Takes every two elements and compares them adding them to a total
// if they are in order
let results = compareLines (List.ofSeq parsedLines) |> Seq.indexed |> Seq.filter (fun (index, result) -> result = InOrder) |> Seq.map (fun (index, result) -> index + 1) |>  Seq.sum

printfn $"Number of packets in order: {results}"



