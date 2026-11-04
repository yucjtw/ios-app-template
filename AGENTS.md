# Agent Instructions

- `AGENTS.md` is the single source of truth; `CLAUDE.md` and `README.md` are symlinks to it. Edit `AGENTS.md` only and never replace a symlink with a regular file, or the copies will drift apart.
- `.claude/skills/` is a symlink to `.agents/skills/`. Add or edit skills under `.agents/skills/`, so every agent client reads the same skills.

## Initializing a repo created from this template

- If `scripts/rename.sh` still exists, the project has not been initialized: run `scripts/rename.sh <AppName> <bundle-id-prefix>` (for example `scripts/rename.sh MyApp com.mycompany`) before adding any code. It replaces the placeholder name `iOSAppTemplate` and prefix `com.example` in file contents and paths, then deletes itself. Doing this first keeps the placeholder from leaking into bundle ids, type names, and test targets.
- The template sets no signing team on purpose. After renaming, open the project in Xcode once and pick the Team under Signing & Capabilities; do not hand-write `DEVELOPMENT_TEAM` into `project.pbxproj`.

## Working on the project

- Add, move, or delete source files on the file system only; never edit `project.pbxproj` to register them. The targets use Xcode 16 synchronized folders, so the project picks up whatever is in `<AppName>/`, `<AppName>Tests/`, and `<AppName>UITests/`.
- Build and test from the command line with `xcodebuild -scheme <AppName> -destination 'platform=iOS Simulator,name=<an installed iPhone simulator>' build` (or `test`). Find simulator names with `xcrun simctl list devices available`. If `xcodebuild` reports that the active developer directory is a command line tools instance, prefix the command with `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` instead of changing `xcode-select`, which needs sudo.
- Unit tests use Swift Testing (`import Testing`, `@Test`, `#expect`), not XCTest. UI tests stay on XCTest because Swift Testing cannot drive `XCUIApplication`.
