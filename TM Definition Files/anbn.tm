[States]
q0
q1
q2
q3
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
X
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
# In q0, scan right to find the first 'a', replace it with 'X' and go to q1
q0, a, q1, X, R
# If we see 'X', keep moving right in q0 (skip marked letters)
q0, X, q0, X, R
# If we see 'b' before marking all a's, reject
q0, b, q_reject, b, R
# If we see blank (no more a's), go to q3 to check for unmatched b's
q0, _, q3, _, L

# In q1, scan right to find first unmarked 'b' and mark it
q1, a, q1, a, R
q1, X, q1, X, R
q1, b, q2, X, L
# If no b found but input ends, reject
q1, _, q_reject, _, R

# In q2, move left back to the start (leftmost tape position)
q2, a, q2, a, L
q2, b, q2, b, L
q2, X, q2, X, L
q2, _, q0, _, R

# In q3, verify all letters are marked (X) or blanks
q3, X, q3, X, L
q3, _, q_accept, _, R
q3, a, q_reject, a, R
q3, b, q_reject, b, R
End
