<#
Tic Tac Toe

We love playing Tic Tac Toe (also called Crosses and Bones, Kółko i krzyżyk)
and want to write a program to eliminate the need for expensive pens and paper. 

Let's play!

Here are the stories:

As a player, I want to be able to print the current state of the board. E.g.
X| |O
 | |
X|X|O
As a player, I want to be able to place a piece on the board.
As a player, I want to be able to take turns with an opponent placing pieces on the board
As a player, I want to make sure my opponent can not cheat
As a player, I want to know when the game is over
As a player, I want to play against the computer to sharpen my skills
#>


#player choice
#$playerOne = Read-Host -Prompt 'Enter Player one name:'
#$playerTwo = Read-Host -Prompt 'Enter Player two name:'




#make the board
$board = @{
    place01 = " ";
    place02 = " ";
    place03 = " ";
    place04 = " ";
    place05 = " ";
    place06 = " ";
    place07 = " ";
    place08 = " ";
    place09 = " ";
}

$board = @(
    
)





#board selection

#game logic
$gameStart
$gameEnd
$whosTurn


Function Clear-Board {
    $place01 = " "
    $place02 = " "
    $place03 = " "
    $place04 = " "
    $place05 = " "
    $place06 = " "
    $place07 = " "
    $place08 = " "
    $place09 = " "
}

Function Make-Board {
    $boardLine01 = "$place01 | $place02 | $place03"
    $boardLine02 = "$place04 | $place05 | $place06"
    $boardLine03 = "$place07 | $place08 | $place09"
    Write-Output $boardLine01
    Write-Output $boardLine02
    Write-Output $boardLine03
}

Function Place-Mark {
    param (
        [ValidateSet('x', 'o')][string]$mark
    )
    [int]$place = Read-Host -Prompt "Player, please select a place:"
    If ($place -eq 1) {
        $place01 = $mark
    }
    Elseif ($place -eq 2) {
        $place02 = $mark
    }
    Elseif ($place -eq 3) {
        $place03 = $mark
    }
    Elseif ($place -eq 4) {
        $place04 = $mark
    }
    Elseif ($place -eq 5) {
        $place05 = $mark
    }
    Elseif ($place -eq 6) {
        $place06 = $mark
    }
    Elseif ($place -eq 7) {
        $place07 = $mark
    }
    Elseif ($place -eq 8) {
        $place08 = $mark
    }
    Elseif ($place -eq 9) {
        $place09 = $mark
    }
    Else {
        Write-Host 'ERROR!!!'
    }
    Make-Board
}


#
Place-Mark -mark 'x'