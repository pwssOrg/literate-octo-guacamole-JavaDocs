# Version: 1.0
# Date: October 6, 2025

# Description:
# This script is designed to insert the PWSS copyright notice into every file within a JavaDocs directory.

# Author: © PWSS Org

Add-Type -AssemblyName System.Windows.Forms

function Choose-Folder {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select Directory"
    [void]$folderBrowser.ShowDialog()
    return $folderBrowser.SelectedPath
}

# Prompt user to choose a directory
$directory = Choose-Folder

if (-not $directory) {
    Write-Host "No directory selected. Exiting."
    exit
}

# Define search string and replacement string
$searchString = "Copyright &#169; 2026. All rights reserved."
$replacementString = "Copyright &#169; PWSS ORG 2026. All rights reserved.<br>SPDX-License-Identifier: MIT"

# Get all files in the chosen directory and its subdirectories
$files = Get-ChildItem -Path $directory -Recurse -File

foreach ($file in $files) {
    try {
        # Read file content
        $content = [System.IO.File]::ReadAllText($file.FullName)

        # Check if the search string is present in the file
        if ($content -match $searchString) {
            # Replace the search string with the replacement string
            $newContent = $content -replace $searchString, $replacementString

            # Write new content back to the file
            [System.IO.File]::WriteAllText($file.FullName, $newContent)
            Write-Host "Updated: $($file.FullName)"
        }
    } catch {
        Write-Warning "Error processing file: $($file.FullName). $_"
    }
}

Write-Host "Operation completed."