# turing-machine

A Turing Machine (TM) is a 7-tuple **(Q, Σ, Γ, δ, q₀, q<sub>accept</sub>, q<sub>reject</sub>)**, consisting of:

- A finite set of **states** `Q`
- A finite set of **input symbols** (input alphabet) `Σ`
- A finite set of **tape symbols** (tape alphabet) `Γ`, where `Σ ⊆ Γ` and `_ ∈ Γ` represents the **blank symbol**
- A **transition function** δ : `Q × Γ → Q × Γ × {L, R, S}`
- An **initial (start) state** `q₀ ∈ Q`
- An **accept state** q<sub>accept</sub> ∈ Q
- A **reject state** q<sub>reject</sub> ∈ Q, where q<sub>accept</sub> ≠ q<sub>reject</sub>

The TM reads and writes symbols on an **infinite tape** and moves its head **Left (L)**, **Right (R)**, or **Stay (S)** based on `δ`.  
It halts when it reaches either the **accept** or **reject** state.

# Table of Contents

- [Definition Format](#definition-format)
- [Example Definition](#example-definition)
- [Error Handling](#error-handling)
- [TM Emulator](#tm-emulator)
- [Folder Structure](#folder-structure)
- [Usage](#usage)

---

## Definition Format

A Turing Machine definition file consists of multiple clearly marked sections, each enclosed in square brackets. Every section ends with an `End` marker on its own line.

### Sections:

- `[States]`  
  Lists all the states in the machine, including start, accept, and reject states.

- `[Input Alphabet]`  
  The set of valid input symbols. These are the characters the input tape may initially contain.

- `[Tape Alphabet]`  
  The set of all symbols that may appear on the tape (including input symbols and the blank symbol `_`).

- `[Start]`  
  The unique start state.

- `[Accept]`  
  The state where the TM accepts input.

- `[Reject]`  
  The state where the TM rejects input (must be different from Accept).

- `[Transitions]`  
  Each transition is a 5-tuple in the format:  
```
currentState, readSymbol, nextState, writeSymbol, direction
```
- `direction` must be one of: `L`, `R`, or `S`  
- The transition function must be **total**, meaning the TM must define exactly one rule for each `(state, readSymbol)` pair.

### 📝 Comments

- Lines starting with `#` are treated as comments.
- Multi-line comments use `/* ... */`.

### 🔚 End Markers

Every section must end with a line containing only: End.

This ensures accurate parsing and avoids accidental section problems.

⚠️ This format is intentionally kept **consistent** with the format used in [this DFA project](https://github.com/06cezar/deterministic-finite-automata#clearly-defined-sections), with added support for tape operations unique to Turing Machines.

## Example Definition
Below is an example `.tm` definition file, located in the `TM Definition Files/` folder (the `evenas.tm` file). This Turing Machine accepts strings over `{a, b}` that contain an even number of `a` symbols, regardless of the number of `b`s.

It uses two main states (`q0`, `q1`) to alternate on each a encountered, effectively counting as modulo 2. When the input ends (blank `_` is read), it accepts or rejects based on the parity.
```
[States]
q0
q1
q_accept
q_reject
End

[Input Alphabet]
a
b
End

[Tape Alphabet]
a
b
_
End

[Start]
q0
End

[Accept]
q_accept
End

[Reject]
q_reject
End

[Transitions]
q0, a, q1, a, R    
q0, b, q0, b, R   
q0, _, q_accept, _, R

q1, a, q0, a, R    
q1, b, q1, b, R    
q1, _, q_reject, _, R 
End

```

### 🔍 Description
`q0` = even number of `a`s so far

`q1` = odd number of `a`s so far

Transitions loop on `b` without changing state

On reaching the end (`_`), the machine decides:

- ✅ Accept if in `q0`

- ❌ Reject if in `q1`

✅ Accepted examples:
- `""` (empty string)
- `"bb"`
- `"aabb"`
- `"abab"`

❌ Rejected examples:
- `"a"`
- `"ab"`
- `"bba"`

## Error Handling

The Turing Machine (TM) parser and emulator include robust error handling through custom Python exception classes. These help detect malformed definitions, illegal transitions, and runtime issues during simulation.

### 📌 Defined Exceptions

| Exception                          | Trigger Condition                                                                 |
|-----------------------------------|------------------------------------------------------------------------------------|
| `TMError`                         | Base class for all TM-related errors                                              |
| `DuplicateRuleError`              | A transition rule for the same (state, read symbol) pair is defined more than once |
| `UndefinedStartStateError`        | The `[Start]` section is missing or refers to a state not in `[States]`          |
| `UndefinedAcceptRejectStatesError`| Accept or Reject state is missing or not listed in `[States]`                    |
| `InvalidSymbolError`              | A read/write symbol is not found in the `[Tape Alphabet]`                        |
| `UndefinedRuleError`              | No rule exists for the current (state, tape symbol) during execution             |

### ⚠️ Notes

- Transitions must be unique per `(state, readSymbol)`. Any duplicate will trigger a `DuplicateRuleError`.
- All referenced states and symbols must be declared explicitly.
- The tape will dynamically expand with blanks (`_`) when the head moves past the current tape end.
- Only `"L"` and `"R"` are allowed as move directions. `"S"` (stay) is **not supported** in this version.

### Example Error Messages

```
DuplicateRuleError: Duplicate transition for (q0, a)
UndefinedStartStateError: Start state qX not in states
UndefinedAcceptRejectStatesError: Accept or Reject state not in states
InvalidSymbolError: Symbol not in tape alphabet: b, _
UndefinedRuleError: No rule for (q1, _)
TMError: Transition state q99 not in states
```
## TM Emulator

The Turing Machine emulator consists of two main components:

- A **parser** that reads a `.tm` or `.txt` file and builds an internal representation of the machine.
- An **execution engine** that simulates the machine's operation on a given input tape.

---

### ✅ Features

- Supports reading and writing over a dynamically growing tape
- Clearly separates start, accept, and reject states
- Allows verbose output showing each step of execution
- Validates all transitions and symbols before running
- Expands the tape with blanks (`_`) automatically if needed

---

### 🧪 How It Works

The TM operates on an infinite tape initialized with your input string. At each step, it:

1. **Reads** the symbol under the head
2. **Checks** the transition rule for (current state, read symbol)
3. **Writes** a new symbol on the tape
4. **Moves** the head Left (`L`) or Right (`R`)
5. **Transitions** to the next state

The machine **halts** when it reaches either the **accept** or **reject** state.

---

### 🔧 Input Format

To run the machine, you'll need:

- A **Turing Machine definition file** (`.tm`) placed in your `TM Definition Files/` folder
- A **plain string input file** (e.g., `abba`) inside `Input Files/`
- Optional verbosity and control via command-line arguments

---

## Folder Structure
```
project/
│
├── TM.py
├── emulateTM.py
├── TM Definition Files/
│ └── your_machine.tm
├── Input Files/
│ └── your_input.txt
```

- All Python scripts (`TM.py`, `emulateTM.py`) are located in the **project root**.
- Turing Machine definitions (`.tm` or `.txt`) are stored in the **TM Definition Files/** folder.
- Input strings (raw tape inputs) are stored in the **Input Files/** folder.

---

### 📌 Cross-Platform File Paths

The emulator uses the `os` module and `chdir` to handle file access in a **platform-independent** way:

- On **Linux/macOS**, paths look like:
```
TM Definition Files/your_machine.tm
```


- On **Windows**, paths look like:
```
TM Definition Files\your_machine.tm
```


This ensures that file access works smoothly regardless of the operating system you're using.

## ▶Usage

You can run the Turing Machine emulator either **interactively** or via **command-line arguments**.

---

### 🔹 Option 1: Interactive Mode

From the project root directory, run:
```
python3 emulateTM.py
```

You will be prompted for:

- **TM definition file name**:  
  Name of a `.tm` or `.txt` file in the `TM Definition Files/` folder  
  _(e.g., `parityChecker.tm`)_

- **Input string file name**:  
  Name of a `.txt` file in the `Input Files/` folder  
  _(e.g., `myInput.txt`)_

- **Verbose mode**:
  - `1` → Show step-by-step transitions and tape updates
  - `0` → Show only final result: `Accepted` or `Rejected`

- **Separator used between input symbols:**
  - `SPACE` → separator is a space (`' '`)
  - `NOSEPARATOR` → no separator (e.g., `abba`)
  - or any custom string (e.g., `;`, `,`, `|`)
---

### 🔹 Option 2: CLI Mode (Command-Line Arguments)

You can also run the emulator directly with arguments:
```
python3 emulateTM.py <tm_filename> <input_filename> [verbosity] [separator]
```

- `<tm_filename>`: Turing Machine definition file (from `TM Definition Files/`)
- `<input_filename>`: Input tape file (from `Input Files/`)
- `[verbosity]`: *(Optional)*  
  `1` → verbose mode (default)  
  `0` → no step-by-step output
- `[separator]`: *(Optional)*  
  Use:
  - `SPACE` for `' '`
  - `NOSEPARATOR` for no separator
  - Or any other string like `;`, `,`, `|`
    
> ⚠️ If your separator is a shell-special character like ;, &, |, etc., wrap it in single quotes (';') to prevent shell misinterpretation.

#### Example
```
python3 emulateTM.py evenas.tm anbnInput.txt 1 NOSEPARATOR
```

## Custom exceptions 
Custom exceptions are raised for:

- Missing TM/input files

- Not enough CLI arguments

- Invalid working directories


