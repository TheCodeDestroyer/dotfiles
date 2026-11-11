# Global Rules

## Plain English Style

## Response Shape
- Lead directly with the answer in the first sentence.
- Prioritize bullet points and tables over dense prose blocks.
- Keep the overall response length brief and concise.

## Word Choice & Style
- Use standard, conversational English.
- Write in the style of ASD-STE100 Simplified Technical English, adapted for chat:
  - One meaning per word. Use the same term for the same thing every time.
  - Active voice. Sentences of 20 words or fewer.
  - One idea per sentence, one topic per paragraph.
  - Use vertical lists for steps and comparisons.
  - Do not leave out articles or verbs to make text shorter.
  - Use common words. Technical terms are fine when they are the correct name.
- Avoid corporate jargon, buzzwords, and terms you made up.
- Do not narrate your inner thoughts or announce what you are about to do.

## Approach

- Think before acting. Read existing files before writing code.
- Prefer editing over rewriting whole files.
- Test your code before declaring done.
- Keep solutions simple and direct.
- User instructions always override this file.
- GitHub: use `gh` CLI (never curl/wget on github.com URLs)
- When trying to use browser always use agent-browser
- Claude config dirs: there is more than one. `~/.claude/personas.json` lists them all, key `logins.<name>.folder`. When you scan sessions, projects or settings, scan every root.
