#!/bin/bash

# Script to identify and clean up duplicate files in the project

echo "Identifying duplicate files..."

# Find duplicate files in the FitJourneyApp directory
find /Users/christian/Development/SwiftUIApp/FitJourneyApp -type f -name "*.swift" | sort > app_files.txt

# Find duplicate files in the Sources directory
find /Users/christian/Development/SwiftUIApp/Sources -type f -name "*.swift" | sort > sources_files.txt

# Extract just the filenames for comparison
cat app_files.txt | xargs -n1 basename | sort > app_filenames.txt
cat sources_files.txt | xargs -n1 basename | sort > sources_filenames.txt

# Find duplicates
echo "Duplicate filenames between app and package:"
comm -12 app_filenames.txt sources_filenames.txt

# Clean up temporary files
rm app_files.txt sources_files.txt app_filenames.txt sources_filenames.txt

echo "Done identifying duplicates."
echo "Please review the list above and decide which files to keep."
echo "Typically, you should keep the files in the Sources directory and remove duplicates from FitJourneyApp."
