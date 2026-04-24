#!/usr/bin/env python3
import re
from pathlib import Path

root = Path('.').resolve()
pattern = re.compile(r"(\\caption(?:\[[^\]]*\])?\{)([^}]*)\}")
modified_files = []

for path in root.rglob('*.tex'):
    text = path.read_text(encoding='utf-8')
    def repl(m):
        prefix = m.group(1)
        caption = m.group(2)
        if caption.strip() == '':
            return m.group(0)
        last = caption.rstrip()[-1]
        if last == '.':
            return m.group(0)
        # preserve trailing spaces inside braces
        trailing = ''
        if caption.endswith(' '):
            trailing = ' '
        return f"{prefix}{caption.rstrip()}.{trailing}}}"
    new_text = pattern.sub(repl, text)
    if new_text != text:
        backup = path.with_suffix(path.suffix + '.bak')
        backup.write_text(text, encoding='utf-8')
        path.write_text(new_text, encoding='utf-8')
        modified_files.append(str(path.relative_to(root)))

print('Modified files:')
for f in modified_files:
    print(f)
print(f"Total modified: {len(modified_files)}")
