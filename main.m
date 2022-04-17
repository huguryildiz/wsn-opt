% WSN Lifetime Maximization Problem
% Author: Huseyin Ugur Yildiz
% Date: May 26, 2021

clc; clear; close all;

iter=20;    % Number of iterations
Ns=30;      % Number of sensor nodes in the network
Rnet=150;   % Network radius (m)
Rb=1000;    % data generation rate (bps)
e_bat=1000; % battery energy (J)

% Radio Parameters [1]
EAmp=100e-12;  % Transmitter amplifier’s efficiency (J/bit)
EElec=50e-9;   % Electronics energy (J/bit)

% Print the basic parameters
fprintf('Number of Nodes: %d, ', Ns);
fprintf('Network Radius: %d (m), ', Rnet);
fprintf('Initial Battery: %d (J), ', e_bat);
fprintf('Data Generation Rate: %d (bps) \n ', Rb);
fprintf('\n');
    
% Start the iterations
for tries=1:iter
    
    % Create a random network topology.
    for i=1:Ns+1
        if (i==1) % Coordinates of the sink node (node-1)
            x_coor(i)=0;
            y_coor(i)=0;
        else      % Coordinates of the sensor nodes (uniform distribution) [2]
            angle=2*pi*rand(1);
            r=Rnet*sqrt(rand(1));
            x_coor(i)=r*cos(angle);
            y_coor(i)=r*sin(angle);
        end
    end

    % Data generation rate (bps)
    for i=1:Ns+1
        if i==1 % The sink node (node-1) cannot generate data
           sr(i)=0;
        else    % Sensor nodes generates Rb bits per second
           sr(i)=Rb;
        end
    end

    for i=1:Ns+1
        for j=1:Ns+1
            % Distance between node-i and node-j
            dist(i,j)=sqrt((x_coor(i)-x_coor(j))^2 + (y_coor(i)-y_coor(j))^2);
            % The amount of energy to transmit a bit over link-(i,j)
            Etx(i,j)=EElec+EAmp*dist(i,j)^2;
            % Reception Energy
            Erx=EElec;
        end
    end

    % Generate GDX files and call GAMS to solve the optimization problem.
    trrun;

    % Print the results of the optimization problem
    fprintf('Iter #: %d, ', tries);
    fprintf('Lifetime: %.f s, ', lifetime);
    fprintf('Sol. Time: %.3f s, ', elapsedTime);
    fprintf('Avg. Energy Cons. per Node: %.f J', mean(energy(:,2)));
    fprintf('\n');
    
    % Store the lifetime, solution times, and energy values in an array
    LT_arr(tries)=lifetime;
    ST_arr(tries)=elapsedTime;
    EN_arr(tries)=mean(energy(:,2));
end

% Display the average results (Post-processing)
fprintf('\n');
fprintf('************************** \n');
fprintf('Avg. Lifetime: %.f s, ', mean(LT_arr));
fprintf('Avg. Sol. Time: %.3f s, ', mean(ST_arr));
fprintf('Avg. Energy Cons: %.f J', mean(EN_arr));
fprintf('\n');

%% References:
% [1] Z. Cheng, M. Perillo, and W. Heinzelman, “General network lifetime 
% and cost models for evaluating sensor network deployment strategies,” 
% IEEE Trans. on Mobile Computing, vol. 7, pp. 484–497, 2008.
% [2] https://stats.stackexchange.com/questions/120527/simulate-a-uniform-distribution-on-a-disc