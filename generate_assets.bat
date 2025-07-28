@echo off
REM Generate character model
ai-windsurf generate --prompt-file character_prompt.json --output-dir assets/characters

REM Generate project visualization models
ai-windsurf generate --prompt-file crypto_visual_prompt.json --output-dir assets/projects
ai-windsurf generate --prompt-file chess_visual_prompt.json --output-dir assets/projects

REM Generate AI service code
ai-windsurf generate --prompt-file gemini_service_prompt.dart --output-file lib/services/ai_service.dart

REM Generate main scene
ai-windsurf generate --prompt-file main_scene_prompt.dart --output-file lib/screens/portfolio_scene.dart

REM Format all Dart code
flutter format .

echo Generation and formatting complete.
pause
