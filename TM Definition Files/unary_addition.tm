[States]
q0
q1 
q2
q_accept
q_reject
End

[Input Alphabet]
0
+
$
End

[Tape Alphabet]
0
+
$
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
q0, 0, q0, 0, R
q0, +, q1, 0, R 
q1, 0, q1, 0, R 
q1, $, q2, _, L
q2, 0, q_accept, $, L
End
