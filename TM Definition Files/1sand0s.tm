[States]
q0

q_accept
q_reject
End

[Input Alphabet]
0
1
$
#
End

[Tape Alphabet]
0
1
$
#
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
q0, 0, q1, 1, R
End
