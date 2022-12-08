-- Splits a string at whitespace
function Split(str)
    local output = {}

    for matched in string.gmatch(str, "%S+") do
        table.insert(output, matched)
    end

    return output
end

-- Read all lines into an array
local f = io.open("input.txt", "r")

Lines = {}

if f ~= nil then
    local line = f:read("l")

    while line ~= nil do
        table.insert(Lines, line)

        line = f:read("l")
    end

    f:close()
end

-- Define line by line parsing functions

CurrentLineIndex = 1

function Finished()
    return CurrentLineIndex > #Lines
end

function GetCurrentLine()
    return Lines[CurrentLineIndex]
end

function AdvanceLine()
    CurrentLineIndex = CurrentLineIndex + 1
end

CurrentDirectory = {}
FileSystem = { ["/"] = {} }

-- Handle each line

while Finished() == false do
    if GetCurrentLine():find("^[$] cd") ~= nil then
        -- Handle cd command
        local tokens = Split(GetCurrentLine())
        local directory = tokens[3]

        if directory == "/" then
            CurrentDirectory = { [1] = "/" }
        elseif directory == ".." then
            table.remove(CurrentDirectory, #CurrentDirectory)
        else
            table.insert(CurrentDirectory, directory)
        end

        AdvanceLine()

    elseif GetCurrentLine():find("^[$] ls") ~= nil then
        -- Handle ls command
        AdvanceLine()

        -- get base directory

        local baseDirectory = FileSystem

        for index, directory in pairs(CurrentDirectory) do
            baseDirectory = baseDirectory[directory]
        end

        -- Add directory contents
        while Finished() == false and GetCurrentLine():find("^[$]") == nil do
            local tokens = Split(GetCurrentLine())
            if tokens[1] == "dir" then
                local newDirectory = {}
                baseDirectory[tokens[2]] = newDirectory
            else
                local size = tonumber(tokens[1])
                baseDirectory[tokens[2]] = size
            end
            AdvanceLine()
        end
    else
        AdvanceLine()
    end
end

-- Get size of directory given by the sum of its contents

function GetDirectorySize(directory)
    local sum = 0
    for name, value in pairs(directory) do
        if type(value) == "number" then
            -- file
            sum = sum + tonumber(value)
        else
            -- directory
            sum = sum + GetDirectorySize(value)
        end
    end

    return sum
end

-- Get directories under size 100000

function GetDirectorySizeUnder100000(directory)
    local sum = 0

    local directorySum = GetDirectorySize(directory)
    if directorySum < 100000 then
        sum = sum + directorySum
    end

    for index, value in pairs(directory) do
        if type(value) == "table" then
            sum = sum + GetDirectorySizeUnder100000(value)
        end
    end

    return sum
end

print(GetDirectorySizeUnder100000(FileSystem))
