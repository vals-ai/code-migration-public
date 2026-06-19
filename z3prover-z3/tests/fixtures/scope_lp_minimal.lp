\ Simple CPLEX LP problem
Minimize
  obj: x + 2 y
Subject To
  c1: x + y >= 3
  c2: x - y <= 2
Bounds
  0 <= x <= 10
  0 <= y <= 10
End
