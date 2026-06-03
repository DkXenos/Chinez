#!/bin/bash
set -e

cd Chinezy

# 1. Delete dead code
rm -f Core/Components/ThemeCard.swift
rm -f Core/Components/CanvasPlaceholder.swift
rm -f Core/Components/ExerciseNavBar.swift
rm -f Core/Components/PlaceholderView.swift
rm -f Core/Services/HanziDataManager.swift
rm -f Core/Models/HanziData.swift

# 2. Setup folders
mkdir -p Features/Course/Models
mkdir -p Features/Course/Services
mkdir -p Features/Course/Components
mkdir -p Features/Course/ViewModel

mkdir -p Features/Writing/Models
mkdir -p Features/Writing/Services
mkdir -p Features/Writing/Components

mkdir -p Features/Quiz/Models
mkdir -p Features/Quiz/Services

mkdir -p Features/TonePractice/Models
mkdir -p Features/TonePractice/Services

# 3. Move Course Feature Files
mv Features/Home/CourseSelection/CourseListView.swift Features/Course/CourseListView.swift
mv Features/Home/CourseSelection/CourseListViewModel.swift Features/Course/ViewModel/CourseListViewModel.swift
mv Features/Home/CourseSelection/CourseRowView.swift Features/Course/Components/CourseRowView.swift
mv Features/Home/CourseSelection/CourseCardView.swift Features/Course/Components/CourseCardView.swift
rm -rf Features/Home

mv Core/Models/Course.swift Features/Course/Models/Course.swift
mv Core/Models/SubChapter.swift Features/Course/Models/SubChapter.swift
mv Core/Models/DialogLineModel.swift Features/Course/Models/DialogLineModel.swift
mv Core/Models/Flashcard.swift Features/Course/Models/Flashcard.swift
mv Core/Services/CourseService Features/Course/Services/

# 4. Move Writing Feature Files
mv Core/Models/WritingModels.swift Features/Writing/Models/WritingModels.swift
mv Core/Services/WritingDataService.swift Features/Writing/Services/WritingDataService.swift
mv Core/Components/HanziWebView.swift Features/Writing/Components/HanziWebView.swift

# 5. Move Quiz Feature Files
mv Core/Models/QuizModels.swift Features/Quiz/Models/QuizModels.swift
mv Core/Services/QuizDataService.swift Features/Quiz/Services/QuizDataService.swift

# 6. Move Tone Practice Feature Files
mv Core/Models/HanziTarget.swift Features/TonePractice/Models/HanziTarget.swift
mv Core/Services/ToneEvaluatorService.swift Features/TonePractice/Services/ToneEvaluatorService.swift

echo "Restructure complete."
