
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

let resultToInt result =
    match result with
    | InOrder -> -1
    | Indeterminate -> 0
    | OutOfOrder -> 1

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

let marker1 = "[[2]]"
let marker2 = "[[6]]"

let lines = marker1::marker2:: List.ofSeq(File.ReadLines("input.txt"))

let parsedMarker1 = parseList [for c in marker1->c]
let parsedMarker2 = parseList [for c in marker2->c]

// Parsers the lines into a list of DeepLists
let parsedLines = lines |> Seq.filter (fun line -> line <> "") |> Seq.map (fun line -> [for c in line ->c]) |> Seq.map parseList

// Sort the elements using the compare packet funnction
let sorted = parsedLines |> Seq.sortWith (fun(line1) -> fun(line2) -> resultToInt (comparePacket line1 line2)) 

// find the two divider packets
let marker1Index = sorted |> Seq.findIndex (fun(item) -> item = parsedMarker1)
let marker2Index = sorted |> Seq.findIndex (fun(item) -> item = parsedMarker2)

printfn $"Decoder key: {(marker1Index+1) * (marker2Index+1)}"



