<?php

$head_position_x = 0;
$head_position_y = 0;

$tail_position_x = 0;
$tail_position_y = 0;

function moveInDirection(string $direction, int &$position_x, int &$position_y)
{
    switch ($direction) {
        case 'L':
            $position_x -= 1;
            break;
        case 'R':
            $position_x += 1;
            break;
        case 'U':
            $position_y += 1;
            break;
        case 'D':
            $position_y -= 1;
            break;
        default:
            break;
    }
}

function copySign(int $x, int $sign)
{
    $output = abs($x);

    if($sign < 0)
    {
        return -$output;
    }

    return $output;
}

function updateChild($parent_position_x, $parent_position_y, &$child_position_x, &$child_position_y)
{
    $delta_x = $parent_position_x - $child_position_x;
    $delta_y = $parent_position_y - $child_position_y;

    $direct_x = $delta_y == 0 && abs($delta_x) == 2;
    $direct_y = $delta_x == 0 && abs($delta_y) == 2;

    $diagonal_x = abs($delta_x) == 2 && abs($delta_y) == 1;
    $diagonal_y = abs($delta_y) == 2 && abs($delta_x) == 1;
    $diagonal_both = abs($delta_x) == 2 && abs($delta_y) == 2;

    if ($direct_x) { 
        $child_position_x += copySign(1, $delta_x);

    }  else if ($direct_y) { 
        $child_position_y += copySign(1, $delta_y);

    } else if ($diagonal_x || $diagonal_y || $diagonal_both){
        $child_position_x += copySign(1, $delta_x);
        $child_position_y += copySign(1, $delta_y);
    }
}

function isPositionUnique($values, $position_x, $position_y)
{
    foreach ($values as $position) {
        if ($position[0] == $position_x && $position[1] == $position_y)
        {
            return false;
        }
    }

    return true;
}

$file = fopen("input.txt", "r");

$visited_positions = array();

while(!feof($file)) 
{
    $line = fgets($file);
    if ($line == "") {
        continue;
    }
    $tokens = explode(' ', $line);

    $direction = $tokens[0];
    $amount =  intval($tokens[1]);

    for ($i=0; $i < $amount; $i++) { 
        moveInDirection($direction, $head_position_x, $head_position_y);

        updateChild($head_position_x, $head_position_y, $tail_position_x, $tail_position_y);

        if(isPositionUnique($visited_positions, $tail_position_x, $tail_position_y)) {
            array_push($visited_positions, array($tail_position_x, $tail_position_y));
        }
    }
}
fclose($file);

echo count($visited_positions), "\n";
?>