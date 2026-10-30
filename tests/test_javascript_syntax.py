import os
import shutil
import subprocess
import pytest

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAIN_JS = os.path.join(BASE_DIR, "html", "main", "azam-features.js")
CANVAS_JS = os.path.join(BASE_DIR, "html", "azam-ops", "azamlabs-features.js")
DOCK_JS = os.path.join(BASE_DIR, "html", "azam-ops", "azamlabs-docked-console.js")
SEQ_JS = os.path.join(BASE_DIR, "html", "azam-ops", "azamlabs-sequenced-console.js")
SYNTAX_JS = os.path.join(BASE_DIR, "html", "azam-ops", "azam-cli-syntax.js")

ALL_JS_FILES = [MAIN_JS, CANVAS_JS, DOCK_JS, SEQ_JS, SYNTAX_JS]

def test_javascript_files_exist():
    for jf in ALL_JS_FILES:
        assert os.path.isfile(jf), f"JS file not found: {jf}"

def test_app_register_hook_intact():
    with open(MAIN_JS, "r", encoding="utf-8") as f:
        content = f.read()
    assert "App.register('azam-features'" in content or 'App.register("azam-features"' in content, (
        "App.register('azam-features', ...) is missing in html/main/azam-features.js"
    )

def test_no_dangling_trailing_operators():
    # Detect accidental dangling trailing '+' before statement boundaries
    for js_path in ALL_JS_FILES:
        with open(js_path, "r", encoding="utf-8") as f:
            lines = f.readlines()
        for idx, line in enumerate(lines[:-1]):
            s = line.strip()
            # If line ends with '+' and next line starts a new statement
            if s.endswith("+"):
                next_line = lines[idx + 1].strip()
                if (next_line.startswith("container.") or 
                    next_line.startswith("var ") or 
                    next_line.startswith("let ") or 
                    next_line.startswith("const ") or 
                    next_line.startswith("function ") or
                    next_line.startswith("document.")):
                    pytest.fail(f"Dangling trailing '+' operator at {os.path.basename(js_path)}:{idx+1} before statement: {next_line}")

def test_iife_closures_balanced():
    for js_path in ALL_JS_FILES:
        with open(js_path, "r", encoding="utf-8") as f:
            content = f.read()
        
        # Tokenizer-style bracket balance check
        stack = []
        in_str = False
        str_char = ''
        in_block_comment = False
        i = 0
        n = len(content)
        while i < n:
            c = content[i]
            if in_block_comment:
                if c == '*' and i + 1 < n and content[i+1] == '/':
                    in_block_comment = False
                    i += 2
                    continue
                i += 1
                continue

            if in_str:
                if c == '\\':
                    i += 2
                    continue
                if c == str_char:
                    in_str = False
                i += 1
                continue

            if c == '/' and i + 1 < n and content[i+1] == '/':
                while i < n and content[i] != '\n':
                    i += 1
                continue
            if c == '/' and i + 1 < n and content[i+1] == '*':
                in_block_comment = True
                i += 2
                continue
            if c in ("'", '"', '`'):
                in_str = True
                str_char = c
                i += 1
                continue

            # Skip regex literal simplistically
            if c == '/' and i + 1 < n and content[i+1] not in ('/', '*'):
                # heuristic check if regex
                prev = content[:i].rstrip()
                if prev and prev[-1] in ('(', '=', ':', ',', '[', '!', '&', '|', '?'):
                    # scan regex
                    i += 1
                    in_cc = False
                    while i < n:
                        if content[i] == '\\':
                            i += 2
                            continue
                        if content[i] == '[':
                            in_cc = True
                        elif content[i] == ']':
                            in_cc = False
                        elif content[i] == '/' and not in_cc:
                            break
                        i += 1
                    i += 1
                    continue

            if c in ('(', '{', '['):
                stack.append(c)
            elif c in (')', '}', ']'):
                assert len(stack) > 0, f"Unmatched closing '{c}' in {os.path.basename(js_path)}"
                top = stack.pop()
                expected = {'(': ')', '{': '}', '[': ']'}[top]
                assert expected == c, f"Mismatched bracket in {os.path.basename(js_path)}: expected '{expected}', got '{c}'"
            i += 1

        assert len(stack) == 0, f"Unclosed tokens remaining in {os.path.basename(js_path)}: {stack}"

def test_node_syntax_check_if_available():
    node_cmd = shutil.which("node")
    if not node_cmd:
        pytest.skip("node.js not installed on local host; balance tests passed")
    for js_path in ALL_JS_FILES:
        res = subprocess.run([node_cmd, "-c", js_path], capture_output=True, text=True)
        assert res.returncode == 0, f"node -c failed on {js_path}: {res.stderr}"

