function Generate-DwarfInsult
{
    $Part1 = @(
        "dainty",
        "no-beard",
        "poor",
        "lazy",
        "demented",
        "pointy-eared",
        "girly",
        "smelly",
        "dirty",
        "weak",
        "no-name",
        "stone-headed",
        "unskilled",
        "pixie-loving",
        "old",
        "ugly",
        "clanless",
        "little",
        "drunk",
        "runt-voiced")

    $Part2 = @(
        "blathering",
        "tiny",
        "hairless",
        "wide-eyed",
        "ass",
        "elf-kissing",
        "milk-drinking",
        "fucking",
        "dandelion-eating",
        "sissy",
        "beardless",
        "shit-smelling",
        "troll-faced",
        "spineless",
        "gemless",
        "dress-wearing",
        "tree-hugging",
        "lily",
        "perfumed",
        "soft-wristed")

    $Part3 = @(
        "troll",
        "orc",
        "ponce",
        "mincer",
        "fancy boy",
        "berry muncher",
        "coward",
        "bat dropping",
        "pansy",
        "piece of camel dung",
        "goblin friend",
        "son of a beast",
        "lightweight",
        "liar",
        "bastard",
        "yellow belly",
        "cry baby",
        "imp",
        "tunnel worm",
        "rock runt"
    )

    $ExtraP1 = $false
    $Line = ""

    if ( $(Get-Random -min 1 -max 5) -eq 4) ## 25% chance of more than one starter
    {
        1..$(Get-Random -min 1 -max 4) | % {
            $Line += (Get-Random -InputObject $Part1) + " "
        }
    }
    else
    {
        $Line += (Get-Random -InputObject $Part1) + " "
    }

    if ( $(Get-Random -min 1 -max 6) -eq 5) ## 20% chance of more than one mid
    {
        1..$(Get-Random -min 1 -max 3) | % {
            $Line += (Get-Random -InputObject $Part2) + " " 
        }
    }
    else
    {
        $Line += (Get-Random -InputObject $Part2) + " "
    }

    $Line += Get-Random -InputObject $Part3
    
    $Line = $Line.ToCharArray()
    $Line[0] = [char]::ToUpper($Line[0])
    $Line = $line -join ""

    $Line
}