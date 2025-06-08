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
