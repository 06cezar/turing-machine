[States]
q0
q1
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
q0, 0, q1, 1, R
q1, 1, q_accept, 1, R
q1, _, q_reject, _, R
End
