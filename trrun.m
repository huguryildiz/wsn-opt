%% INPUTS
% Generate the input GDX file 

% Set of nodes
nodes.name = 'I';
nodes.val  = linspace(1,length(x_coor),length(x_coor))';
nodes.type = 'set';

% x coordinate of nodes
xcors.name = 'x';
xcors.type = 'parameter';
xcors.val = x_coor';
xcors.form = 'full';
xcors.dim=1;

% y coordinate of nodes
ycors.name = 'y';
ycors.type = 'parameter';
ycors.val = y_coor';
ycors.form = 'full';
ycors.dim=1;

% Data generation rate
sr1.name = 's';
sr1.type = 'parameter';
sr1.val = sr;
sr1.form = 'full';
sr1.dim=1;

% Transmission energy
Etx1.name = 'Etx';
Etx1.type = 'parameter';
Etx1.val = Etx;
Etx1.form = 'full';
Etx1.dim=2;

% Reception energy
Erx1.name = 'Erx';
Erx1.type = 'parameter';
Erx1.val = Erx;

% Battery energy
e_bat1.name = 'e_bat';
e_bat1.type = 'parameter';
e_bat1.val = e_bat;

% Write the parameters into the inputGDX.gdx file
wgdx ('inputGDX',nodes,xcors,ycors,sr1,Etx1,Erx1,e_bat1);

%% OPTIMIZATION
tic;

% Call GAMS and solve the optimization model.
gams('model');
%system (['gams model lo=2 --TRIP=', int2str(tries)]);

% Solution time of the optimization model
elapsedTime=toc;

%% Outputs

% Network lifetime
rs1.name = 't';
rs1.field = 'l';
r1 = rgdx ('outputGDX', rs1);
lifetime = r1.val;

% Energy consumption
rs2.name = 'e';
rs2.form = 'sparse';
r2 = rgdx ('outputGDX', rs2);
energy= r2.val;

% Optimal flows
rs3.name = 'f';
rs3.form = 'sparse';
r3 = rgdx ('outputGDX', rs3);
flows = r3.val;