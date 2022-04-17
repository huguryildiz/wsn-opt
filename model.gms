* WSN Lifetime Maximization Problem
* Author: Huseyin Ugur Yildiz
* Date: May 26, 2021

Set i nodes;

Alias (i,j);

Parameters
         y(i)     y coordinate of node-i
         x(i)     x coordinate of node-i
         s(i)     Data generation rate of node-i (bits per second)
         Etx(i,j) The amount of energy to transmit a bit over link-(ij) (J)
         Erx      Reception energy per bit (J)
         e_bat    Initial battery energy of sensor nodes (J)
;

* Loading data from inputGDX.gdx file, which is generated in MATLAB
$gdxin inputGDX
$load i x y s Etx Erx e_bat
$gdxin

Variables
         t      Network lifetime (in seconds)
;

Positive Variables
         e(i)   Total energy consumred by node-i during the network lifetime
         f(i,j) Total number of bits flowing over link-(ij) during the network lifetime
;

Equations
         noFlow(i,j)          No flow generation constraint (sink node cannot generate data and a node cannot transmit data to itself)
         flowBalance(i)       Flow balance constraint
         energyConstraint(i)  Total energy consumred by node-i during the network lifetime
         batteryConstraint(i) Battery constraint
;
         noFlow(i,j)$(ord(i)=ord(j) or ord(i)=1)..             f(i,j) =e= 0;
         flowBalance(i)$(ord(i)<>1)..                          sum(j,f(i,j)) - sum(j$(ord(j)<>1),f(j,i)) =e= s(i)*t;
         energyConstraint(i)$(ord(i)<>1)..                     sum(j,Etx(i,j)*f(i,j)) + Erx*(sum(j$(ord(j)<>1),f(j,i))) =e= e(i);
         batteryConstraint(i)$(ord(i)<>1)..                    e(i) =l= e_bat;

* Generate the optimization model (maxLT) using all of the constraints
Model maxLT /ALL/;

* Solve the optimization model (LP) for maximizing the network lifetime
Solve maxLT using lp maximizing t;

* Write the optimal values of "t", "f", and "e" into outputGDX.gdx file
execute_unload 'outputGDX', t,f,e


