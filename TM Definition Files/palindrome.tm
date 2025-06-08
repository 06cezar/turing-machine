[States]
q0
q1
q2
q3
q4
q_accept
q_reject
End

[Input Alphabet]
0
1
End

[Tape Alphabet]
0
1
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


q0, 0, q1, X, R
q0, 1, q2, X, R
q0, X, q_accept, X, R
q0, _, q_accept, _, R


q1, 0, q1, 0, R
q1, 1, q1, 1, R
q1, X, q1, X, R
q1, _, q3, _, L

q2, 0, q2, 0, R
q2, 1, q2, 1, R
q2, X, q2, X, R
q2, _, q4, _, L


q3, 0, q0, X, L
q3, X, q_accept, X, R
q3, 1, q_reject, 1, R
q3, _, q_accept, _, R


q4, 1, q0, X, L
q4, X, q_accept, X, R
q4, 0, q_reject, 0, R
q4, _, q_accept, _, R
End
