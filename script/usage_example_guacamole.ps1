# Version: 1.0
# Date: October 21, 2025

# Description:
# This script is designed to insert usage examples into the literate-octo-guacamole-JavaDocs project.
# It simplifies deployment by ensuring that the Java documentation remains up-to-date with current usage examples.

# Author: © PWSS Org

function ReplaceStringInFiles {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$sourceFilePaths,

        [Parameter(Mandatory=$true)]
        [string[]]$destinationFilePaths
    )

    # Ensure both arrays have the same length
    if ($sourceFilePaths.Length -ne $destinationFilePaths.Length) {
        Write-Host "The number of source and destination files must be the same."
        return
    }

    for ($i = 0; $i -lt $sourceFilePaths.Length; $i++) {
        $sourceFilePath = $sourceFilePaths[$i]
        $destinationFilePath = $destinationFilePaths[$i]

        # Read the content of the destination file (if it exists) into a variable
        if (Test-Path $destinationFilePath) {
            $content = Get-Content -Path $destinationFilePath -Raw
        } else {
            Write-Host "The destination file does not exist: $destinationFilePath"
            continue
        }

        # Read the replacement text from the source file
        if (Test-Path $sourceFilePath) {
            $replacementText = (Get-Content -Path $sourceFilePath -Raw)
        } else {
            Write-Host "The source file does not exist: $sourceFilePath"
            continue
        }

        # Replace the specified string with the content of the source file in the destination file's content
        $newContent = $content -replace "No usage of",$replacementText

        # Write the updated content to the destination file
        Set-Content -Path $destinationFilePath -Value $newContent

        Write-Host "String replacement completed successfully and saved to $destinationFilePath."
    }
}


$sourceFiles = @(
    "..\usage_example\enable_algorithm_switch.txt",
    "..\usage_example\choose_algorithm.txt",
    "..\usage_example\file_hash_handler.txt",
    "..\usage_example\big_file_hash_handler.txt"
    
)

$destinationFiles = @(
    "..\docs\lib\pwss\algorithm_switch\class-use\AlgorithmSwitchingInitializer.html",
    "..\docs\lib\pwss\algorithm_switch\class-use\ChooseAlgorithm.html",
    "..\docs\lib\pwss\hash\file_hash_handler\class-use\FileHashHandler.html",
    "..\docs\lib\pwss\hash\file_hash_handler\class-use\BigFileHashHandler.html"
)

ReplaceStringInFiles -sourceFilePaths $sourceFiles -destinationFilePaths $destinationFiles