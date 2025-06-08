class TMError(Exception): pass
class DuplicateRuleError(TMError): pass
class UndefinedStartStateError(TMError): pass
class UndefinedAcceptRejectStatesError(TMError): pass
class InvalidSymbolError(TMError): pass
class UndefinedRuleError(TMError): pass

def parseTMFile(file):
    states, inputAlphabet, tapeAlphabet = [], [], []
    transitions = {}  # transitions[state][readSymbol] = (nextState, writeSymbol, direction)
    start = accept = reject = None
    section = None

    for line in file:
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("[") and line.endswith("]"):
            section = line[1:-1]
            continue
        if line == "End":
            section = None
            continue

        if section == "States":
            states.append(line)
        elif section == "Input Alphabet":
            inputAlphabet.append(line)
        elif section == "Tape Alphabet":
            tapeAlphabet.append(line)
        elif section == "Start":
            start = line
        elif section == "Accept":
            accept = line
        elif section == "Reject":
            reject = line
        elif section == "Transitions":
            parts = [x.strip() for x in line.split(",")]
            if len(parts) != 5:
                raise TMError(f"Invalid transition line: {line}")
            state, read, nextState, write, direction = parts
            state = state.strip()
            read = read.strip()
            nextState = nextState.strip()
            if state not in transitions:
                transitions[state] = {}
            if read in transitions[state]:
                raise DuplicateRuleError(f"Duplicate transition for ({state}, {read})")
            transitions[state][read] = (nextState, write, direction)

    file.close()

    TM = (states, inputAlphabet, tapeAlphabet, transitions, start, accept, reject)
    validateTM(TM)
    return TM

def validateTM(TM):
    states, _, tapeAlphabet, transitions, start, accept, reject = TM
    if start not in states:
        raise UndefinedStartStateError(f"Start state {start} not in states")
    if accept not in states or reject not in states:
        raise UndefinedAcceptRejectStatesError("Accept or Reject state not in states")
    for state in transitions:
        if state not in states:
            raise TMError(f"Transition state {state} not in states")
        for readSymbol in transitions[state]:
            nextState, writeSymbol, direction = transitions[state][readSymbol]
            if nextState not in states:
                raise TMError(f"Next state {nextState} not in states")
            if writeSymbol not in tapeAlphabet or readSymbol not in tapeAlphabet:
                raise InvalidSymbolError(f"Symbol not in tape alphabet: {readSymbol}, {writeSymbol}")
            if direction not in ("L", "R"):
                raise TMError(f"Invalid direction {direction} in transition")

def runTM(TM, tapeInput, printSteps=True):
    states, _, tapeAlphabet, transitions, start, accept, reject = TM
    tape = list(tapeInput)
    head = 0
    currentState = start

    if printSteps:
        print(f"Initial Tape: {''.join(tape)}")
        print(f"Start at state: {currentState}, head at: {head}")

    while currentState != accept and currentState != reject:
        if head >= len(tape):
            tape.append('_')
        readSymbol = tape[head]
        if currentState not in transitions or readSymbol not in transitions[currentState]:
            raise UndefinedRuleError(f"No rule for ({currentState}, {readSymbol})")
        nextState, writeSymbol, direction = transitions[currentState][readSymbol]
        tape[head] = writeSymbol
        currentState = nextState
        if direction == "L" and head > 0:
            head = head - 1
        elif direction == "R":
            head = head + 1

        if printSteps:
            print(f"State: {currentState}, Head: {head}, Tape: {''.join(tape)}")

    return currentState == accept