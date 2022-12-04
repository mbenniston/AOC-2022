#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

struct Range
{
    int start, end;
};

struct Range string_to_range(char* str)
{
    struct Range range;

    char* dash = strchr(str, '-');
    char numStr[128] = { 0 };
    int startLen = strlen(str) - strlen(dash);
    strncpy(numStr, str, startLen);
    numStr[startLen] = 0;

    range.start = atoi(numStr);
    range.end = atoi(dash + 1);

    return range;
}

bool do_ranges_fully_overlap(struct Range leftRange, struct Range rightRange)
{
    if (leftRange.start >= rightRange.start && leftRange.end <= rightRange.end)
    {
        return true;
    }

    if (rightRange.start >= leftRange.start && rightRange.end <= leftRange.end)
    {
        return true;
    }

    return false;
}

bool do_ranges_partially_overlap(struct Range leftRange, struct Range rightRange)
{
    if (leftRange.end < rightRange.start) {
        return false;
    }
    else if (leftRange.start > rightRange.end) {
        return false;
    }

    if (leftRange.start <= rightRange.start) {
        return leftRange.end >= rightRange.start;
    }

    return rightRange.end >= leftRange.start;
}

int main(int argc, const char* argv[])
{
    char lineBuffer[128];
    char* line = fgets(lineBuffer, 128, stdin);

    int num_overlapping_ranges = 0;

    while (line != NULL)
    {
        char* comma = strchr(line, ',');
        char rangeStr[128] = { 0 };
        size_t rightLength = strlen(comma);
        strncpy(rangeStr, line, strlen(line) - rightLength);

        struct Range leftRange = string_to_range(rangeStr);
        struct Range rightRange = string_to_range(comma + 1);

        if (do_ranges_fully_overlap(leftRange, rightRange))
        {
            num_overlapping_ranges++;
        }
        
        line = fgets(lineBuffer, 128, stdin);
      }  
      

    printf("%d\n", num_overlapping_ranges);

    return 0;
}