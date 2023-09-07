The domain considered is 

 |  o  |  o  |  o  |  o  |  o  |  o  |  o  |  o  |       --> 
ri                                               ro       x

o -> points(or nodes) where the charge density is evaluated
| -> interfaces between domain points (where E is evaluated)

There are 100 points, the coordinates of them are stored in the column vector x

There are 101 interfaces, the coordinates of them are stored in the column vector x_int

The electric potential(phi) is evaluated at the nodes(100), and in addition 
is fixed at the left and right interface, that represent the electrodes(+2)
The coordinates where phi is known are stored in the column vector x_phi, obtained as:
x_phi = [x_int(1); x; x_int(end)]
