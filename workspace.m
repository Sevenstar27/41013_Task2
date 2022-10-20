clear all;
close all;
hold on;

%% Dobot testing for real use:
 
% d = Dobot(false);
% d.model.base = d.model.base*trotx(pi/2); % (x,z,y)
% drawnow;

% - Pickup: [0, 90, 30, 10, -30, 85]
% - Dropoff 1: [-1.33, 0, 0.5236, 0.1745, -0.5236, 1.4835]
% - Dropoff 2: [-1.33, 0, 0.5236, 0.8727, -0.5236, 1.4835]

% Pickup -> Open Gripper -> Close Gripper -> Dropoff 1 -> Dropoff 2 ->
% Open Gripper -> Dropoff 1 -> Close Gripper -> Pickup

% pickup = deg2rad([0, 90, 30, 10, -30, 85]);
% dropoff1 = [-1.33, 0, 0.5236, 0.1745, 0.8657, 1.4835];
% dropoff2 = [-1.33, 0, 0.5236, 0.8727, 0.1745, 1.4835];
% 
% DTravel(d, pickup, dropoff1, 50, 1);
% DTravel(d, dropoff1, dropoff2, 50, 1);
% DTravel(d, dropoff2, dropoff1, 50, 1);
% DTravel(d, dropoff1, pickup, 50, 1);
% d.model.teach;

%DTravel(d, q1, q2, 1);

%% GENERAL TO DO LIST:
% - Make environment
% - Make items
% - Make grippers
% - Visual servoing
% - System stop
% - Collision detection
% - GUI Movement/Controller Movement
% - Colour Rozum Pulse 75
% - Plan meal packaging
    % + Bagging vs... 
    % + Tray Placement?
    % + Cutlery
    % + Drinks
    % + Passing between robots
    % + Handover to customer/driver
% - Create pickup status for each robot and each item to indicate what each
% robot is holding. Travel functions will check for each robots' status and
% move whatever is set to true.
% - Safety


%% Plot Critical Points

% Handover point - where bag is passed between robots.


% Dropoff point - where Dobot releases bag for collection.


% Cutlery points:
    % Cutlery pickup point - where Rozum collects cutlery package.

    % Cutlery dropoff point - where Rozum drops 

% Drink points:
    % Drink cup pickup point - where Rozum 


    % Drink cup fill point - where cup is placed to be filled

%% Test gripper plotting
L1 = Link('d',0,'a',0,'alpha',0,'qlim',deg2rad([-180 180]), 'offset',0); 
gripper = SerialLink([L1], 'name', 'master');

% Plot the base and the master finger of the gripper.

            for linkIndex = 0:0
                %display(['Link',num2str(linkIndex),'.ply']);
                [ faceData, vertexData, plyData{linkIndex + 1} ] = plyread(['Gripper',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>                
                gripper.faces{linkIndex + 1} = faceData;
                gripper.points{linkIndex + 1} = vertexData;
            end

% Plot the slave finger of the gripper.

% Animate both master and slave gripper into the starting configuration.

%gripper.plot(zeros(1,1));

%% Generate Environment

% Set up robots.
r = RozumPulse75();
r.model.base = r.model.base*transl(0,-0.8,0.85);
r.model.animate(ones(1,6));

d = Dobot(false);
d.model.base = r.model.base*trotx(pi/2)*transl(0,0.04,-1.0); % (x,z,y)
d.model.animate(zeros(1,6));

% Soft drinks dispenser. When picking one up, make a new instance of
% object.
    % Cola (legally distinct)
    softDrinkColaCoords = r.model.base*transl(-0.4,-80/1000,0.3);
    softDrinkCola_h = PlaceObject('Items\SoftDrink_Cola.ply', softDrinkColaCoords(1:3,4)'); 
    
    softDrinkDispenserColaCoords = softDrinkColaCoords*transl(0,0,-60/1000);
    softDrinkDispenserCola_h = PlaceObject('Items\SoftDrinkDispenser.ply', softDrinkDispenserColaCoords(1:3,4)'); 

    % Orange 
    softDrinkOrangeCoords = softDrinkColaCoords*transl(0,100/1000,0);
    softDrinkOrange_h = PlaceObject('Items\SoftDrink_Orange.ply', softDrinkOrangeCoords(1:3,4)'); 
    
    softDrinkDispenserOrangeCoords = softDrinkOrangeCoords*transl(0,0,-60/1000);
    softDrinkDispenserOrange_h = PlaceObject('Items\SoftDrinkDispenser.ply', softDrinkDispenserOrangeCoords(1:3,4)'); 

    % Lemon 
    softDrinkLemonCoords = softDrinkOrangeCoords*transl(0,100/1000,0);
    softDrinkCola_h = PlaceObject('Items\SoftDrink_Lemon.ply', softDrinkLemonCoords(1:3,4)'); 
    
    softDrinkDispenserLemonCoords = softDrinkLemonCoords*transl(0,0,-60/1000);
    softDrinkDispenserLemon_h = PlaceObject('Items\SoftDrinkDispenser.ply', softDrinkDispenserLemonCoords(1:3,4)'); 

% Plot bench space.
    
    % Countertop of the robots.
    counterRobotCoords = r.model.base*transl(0,2.4,-0.3325);
    counterRobot_h = PlaceObject('Items\Counter.ply', counterRobotCoords(1:3,4)'); 
    
    % Countertop of the meal pickup.
    counterCollection_h = PlaceObject('Items\Counter.ply', counterRobotCoords(1:3,4)'); 
    counterCollectionVerts = get(counterCollection_h,'Vertices');
    counterCollectionAdjust = trotz(pi/2)*transl(1.19,2-0.1,0);
    counterCollectionCoords = [counterCollectionVerts, ones(size(counterCollectionVerts,1),1)]*counterCollectionAdjust';
    set(counterCollection_h, 'Vertices', counterCollectionCoords(:,1:3));

    
% Plot Meal Box next to Rozum bot.

    % Code Snippet for the closed box to be used after pushed into folding
    % space.
%     mealBox_ClosedCoords = r.model.base*transl(-0.4,0,0);
%     mealBox_Closed_h = PlaceObject('Items\MealBox_Closed.ply', mealBox_ClosedCoords(1:3,4)'); 

    % Place the open box model. 
    mealBox_OpenCoords = r.model.base*transl(0,-0.55,0);
    mealBox_Open_h = PlaceObject('Items\MealBox_Open.ply', mealBox_OpenCoords(1:3,4)'); 

% Plot cutlery boxes.



% Plot box folding space (Rozum bot is to push box in and pull it back
% out with the handles).



% Plot walls for holding equipment.



% Plot safety glass walls. Use these for link collision checks later.

yConstant = r.model.base(2,4)+2.4;
xHighBound = r.model.base(1,4)+0.4;
xLowBound = r.model.base(1,4)-0.4;
zHighBound = r.model.base(3,4)+1;
zLowBound = r.model.base(3,4);
SafetyGlass1_h = surf([xLowBound,xLowBound;xHighBound,xHighBound],[yConstant,yConstant;yConstant,yConstant],[zLowBound,zHighBound;zLowBound,zHighBound],'CData',imread('Items\SafetyGlass.png'),'FaceColor','texturemap', 'FaceAlpha', 0.2);

xConstant = r.model.base(1,4)+0.4;
yHighBound = r.model.base(2,4)+2.4;
yLowBound = r.model.base(2,4)+0.7;
zHighBound = r.model.base(3,4)+1;
zLowBound = r.model.base(3,4);
SafetyGlass2_h = surf([xConstant,xConstant;xConstant,xConstant],[yLowBound,yLowBound;yHighBound,yHighBound],[zLowBound,zHighBound;zLowBound,zHighBound],'CData',imread('Items\SafetyGlass.png'),'FaceColor','texturemap', 'FaceAlpha', 0.2);


% Sensor in the meal box placement area to protect personnel and shut off
% the Rozum's movement (if it's doing anything).


% Set up hazard area for robot
floor = r.model.base(3,4)-0.84;
xHighBound = r.model.base(1,4)+1.5;
xLowBound = r.model.base(1,4)-1.5;
yHighBound = r.model.base(2,4)+2.4;
yLowBound = r.model.base(2,4)-1;
hazardFloor_h = surf([xLowBound,xLowBound;xHighBound,xHighBound],[yLowBound,yHighBound;yLowBound,yHighBound],[floor,floor;floor,floor],'CData',imread('Items\hazardFloor.jpg'),'FaceColor','texturemap');

drawnow;
%% Perform Task

axis equal;

q1 = zeros(1,6);
q2 = ones(1,6);

view(3);

%% Navigation for ROZUM picking up soft drink. (In progress!)

% Decide which drink to pick up (cola, orange, lemon)
%softDrinkColaCoords
%softDrinkOrangeCoords
%softDrinkLemonCoords

% Extract the transform of the attach point of the soft drink.

softDrinkTr = softDrinkColaCoords*troty(-pi/2);

% Define the approach transform to the soft drink (away by 0.1 m in x axis)

softDrinkApproachTr = softDrinkTr*transl(0,0,-0.1);

% Define the initial pose to select the drink before approach.

qGuess = deg2rad([0, 0, 120, 60, 90,-180]);

% For the approach and pickup transforms, get their poses. Use initial
% guesses for best results.

qApproach = r.model.ikcon(softDrinkApproachTr, qGuess);
qPickup = r.model.ikcon(softDrinkTr, qApproach);

r.Travel(zeros(1,6), qApproach , 50);

r.Travel(qApproach, qPickup, 30);

% Take the pickup transform and lift it by 0.1 m in the local x.
drinkLiftTr = softDrinkTr*transl(0.1,0,0);

% Move to above the meal box for insertion. May require initial guess for
% good joint lengths to avoid funky collisions.
drinkBoxAboveTr = mealBox_OpenCoords*transl(0.07,0,0.35)*trotx(pi);

qGuess = deg2rad([80, 20, 90, -20, -90, 0]);

% Animate RMRC computed

% Move the soft drink out of the dispenser. Use RMRC to control velocity.
colaPickup = true;
lastPose = RMRC(r, softDrinkTr, drinkLiftTr, qPickup, 40, 0.2);

% Move the soft drink to over the meal box.
qAbove = r.model.ikcon(drinkBoxAboveTr, qGuess);
r.Travel(lastPose, qAbove, 100);

% Move the soft drink into the meal box and deposit it. Use RMRC to control
% velocity.
lastPose = RMRC(r, drinkBoxAboveTr, drinkBoxAboveTr*transl(0,0,0.5), qAbove, 40, 0.2);
colaPickup = false;

% Move the robot out of the box.
lastPose = RMRC(r, drinkBoxAboveTr*transl(0,0,0.5), drinkBoxAboveTr, lastPose, 40, 0.2);

% Return to neutral pose.

r.Travel(lastPose, zeros(1,6), 50);

%% Navigation for ROZUM picking up cutlery (in progress)


%% Navigation for handover of meal box.


pickup = deg2rad([0, 90, 30, 10, -30, 85]);
dropoff1 = [-1, 0, 0.5236, 0.1745, 0.8657, 1.4835];
dropoff2 = [-1, 0, 0.5236, 0.8727, 0.1745, 1.4835];

% ROZUM Assembles the following into bag held by dobot.
% Cutlery
% Meal Box
% Drink

DTravel(d, pickup, dropoff1, 50, 1);
DTravel(d, dropoff1, dropoff2, 50, 1);
DTravel(d, dropoff2, dropoff1, 50, 1);
DTravel(d, dropoff1, pickup, 50, 1);

%% VisualServoing test
VisualServoingSafety(r, d);


%%
%UniversalTravel(r, q1, q2, [20, 80], d, q1, [-1, ones(1,5)], [1, 50], 1);


%% VisualServoingSafety
% Start the visual servoing safety demonstration.
function VisualServoingSafety(r, d)
    % the Rozum will hold the safety sign that the Dobot has to retreat
    % from. The Dobot will have a camera mounted to its end effector. It is
    % assumed it occupies the same space as the Dobot's gripper.

    % Load in the safety sign and attach it to the Rozum's end effector at
    % a pose where the dobot can see it.'

    rozumTargetPose = deg2rad([104, 0, -101, 10.8, 90, 0]);
    dobotStartPose = deg2rad([0, 90, 30, 10, -30, 85]);

    r.Travel(r.model.getpos, zeros(1,6), 40); % Move Rozum to safe pose first.

    UniversalTravel(r, zeros(1,6), rozumTargetPose, [1, 40], d, d.model.getpos, dobotStartPose, [1, 40], 1);

    % Now that both robots are in their correct poses, get end effector
    % position of the Rozum.

    Tr = r.model.fkine(rozumTargetPose);
    
    yConstant = Tr(2,4);
    xHighBound = Tr(1,4)-0.11;
    xLowBound = Tr(1,4)+0.11;
    zHighBound = Tr(3,4)-0.1;
    zLowBound = Tr(3,4);
    VSSign_h = surf([xLowBound,xLowBound;xHighBound,xHighBound],[yConstant,yConstant;yConstant,yConstant],[zLowBound,zHighBound;zLowBound,zHighBound],'CData',imread('Items\SafetySign.jpg'),'FaceColor','texturemap');

    % Plot points on the safety sign to follow (use 3).

    P=[xLowBound,   xLowBound,   xHighBound;
       yConstant, yConstant,  yConstant;
       zLowBound,  zHighBound,  zLowBound];

    spherePoints_h = plot_sphere(P, 0.01, 'g');

%
    % Mount the camera onto the Dobot
cam = CentralCamera('focal', 0.08, 'pixel', 10e-5, ...
'resolution', [1024 1024], 'centre', [512 512],'name', 'DobotCamera');

cam.plot_camera('Tcam',Tc0, 'label','scale',0.15);


    % Begin visual servoing and RMRC retreat for specified steps.


end

%% UniversalTravel
% Function to move both robots at once at varying time steps.
function UniversalTravel(r1_h ,r1q1, r1q2, r1Steps, r2_h, r2q1, r2q2, r2Steps, mode)

% Format args as:
% robot handle, q1, q2, [starting step, steps]... , mode

    % mode:
    %   1 - Trapezoidal
    %   2 - Quintic Polynomial

    % TO DO LIST: 
    % - Manipulability measure for singularities and DLS
    % - Move simultaneously with other robots and all other ibjects with
    % this universal motion function.
    % - Attach points for items and grippers.

    % Build trajectories for Rozum and Dobot.
    if mode == 1
        % Building the Rozum trajectory:
        s = lspb(0,1,r1Steps(2));    % Create matrix describing trapezoidal trajectory 
        %                           movement varying smoothly from S0 to SF (time)
        %                           in M steps. V can be specified, but is computed
        %                           automatically. 
        qr1Matrix = nan(r1Steps(2), r1_h.model.n);
        for i=1:r1Steps(2)
          qr1Matrix(i,:) = (1-s(i))*r1q1 + s(i)*r1q2;
        end
    
        % Building the Dobot trajectory:
        s = lspb(0,1,r2Steps(2));    % Create matrix describing trapezoidal trajectory 
        %                           movement varying smoothly from S0 to SF (time)
        %                           in M steps. V can be specified, but is computed
        %                           automatically. 
        qr2Matrix = nan(r2Steps(2), r2_h.model.n);
        for i=1:r2Steps(2)
          qr2Matrix(i,:) = (1-s(i))*r2q1 + s(i)*r2q2;
        end

    elseif mode == 2
        qr1Matrix = jtraj(r1q1, r1q2, r1Steps(2));
        qr2Matrix = jtraj(r2q1, r2q2, r2Steps(2));      
    end

    % Decide the maximum step number for this specific function call.

    if (r1Steps(1) + r1Steps(2)) > (r2Steps(1) + r2Steps(2)) % r1 has the last step.
        maxSteps = r1Steps(1) + r1Steps(2);
    else % r2 has the last step.
        maxSteps = r2Steps(1) + r2Steps(2);
    end

    %size(qr1Matrix)
    %size(qr2Matrix)

    % Animate the movement.
    r1Index = 1;
    r2Index = 1;

    for i=1:maxSteps
    % Check if the starting step of each point has been reached.
        if (r1Steps(1) <= i) && (r1Index <= r1Steps(2)) % If the step is equal to or exceeds r1 starting step.
            r1_h.model.animate(qr1Matrix(r1Index,:));
            r1Index = r1Index + 1;

            % Move the designated object that has been picked up. Pass the
            % object's handle to the code.
% 
%             verticesAdjustTr = (r1_h.model.fkine(qr1Matrix(r1Index,:))); % Alters last position by this amount.
%             transformedVertices = [self.vertices(:,:,brick),ones(size(self.vertices(:,:,brick),1),1)] * verticesAdjustTr'; 
%             set(self.brick_h(brick,1), 'Vertices', transformedVertices(:,1:3));
            drawnow;

        end
        if (r2Steps(1) <= i) && (r2Index <= r2Steps(2)) % If the step is equal to or exceeds r2 starting step.
            r2_h.model.animate(qr2Matrix(r2Index,:));
            r2Index = r2Index + 1;

            % Move the designated object that has been picked up. Pass the
            % object's handle to the code.

%             verticesAdjustTr = (r2_h.model.fkine(qr2Matrix(r2Index,:))); % Alters last position by this amount.
%             transformedVertices = [self.vertices(:,:,brick),ones(size(self.vertices(:,:,brick),1),1)] * verticesAdjustTr'; 
%             set(self.brick_h(brick,1), 'Vertices', transformedVertices(:,1:3));
%             drawnow;

        end
    pause(0.01);
    end
end

%% RMRC
% Given a handle for a robot, coordinates
function lastPose = RMRC(robot, T1, T2, q0, steps, deltaT)

    % Function requires:
    % - Handle of the robot being used.
    % - Initial transform 
    % - Final transform
    % - Initial guess to help inverse kinematics
    % - Desired steps
    % - deltaT to set velocity
   
    % Set lowest manipulability threshold.
    epsilon = 0.1;

    % Create Cartesian waypoints for trajectory.
    x = zeros(3,steps);

        % Extract Cartesian coordinates from given transforms.
        x1 = T1(1:3,4);
        x2 = T2(1:3,4);
    
        s = lspb(0,1,steps);                                 % Create interpolation scalar
        for i = 1:steps
            x(:,i) = x1*(1-s(i)) + s(i)*x2;                  % Create trajectory in x-y-z plane
        end
    
    % Create RPY waypoints for trajectory.
    theta = zeros(3, steps);

        % Extract RPY from given transforms.
        theta1 = tr2rpy(T1)';
        theta2 = tr2rpy(T2)';

        s = lspb(0,1,steps);                % Trapezoidal trajectory scalar
        for i=1:steps
            theta(:,i) = theta1*(1-s(i)) + s(i)*theta2;       
        end


    % Create pose matrix.
    qRMatrix = nan(steps,6);
    qRMatrix(1,:) = q0;% From initial guess which is chosen pose.   %robot.model.ikcon(T1,q0);                 % Solve for joint angles
    
    m = zeros(1,steps-1);

    % Use RMRC to move between set Cartesian points.
    for i = 1:steps-1
        % Get linear velocity
        xdot = (x(:,i+1) - x(:,i))/deltaT;              % Calculate velocity at discrete time step
        
        % Get angular velocity

        T = robot.model.fkine(qRMatrix(i,:));

        Rd = rpy2r(theta(1,i+1),theta(2,i+1),theta(3,i+1));                     % Get next RPY angles, convert to rotation matrix
        Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    
        Rdot = (1/deltaT)*(Rd - Ra);                                                % Calculate rotation matrix error
        S = Rdot*Ra';                                                           % Skew symmetric!
        
        thetadot = [S(3,2);S(1,3);S(2,1)];                              % Check the structure of Skew Symmetric matrix!!
    
        velocity = [xdot;thetadot];

        J = robot.model.jacob0(qRMatrix(i,:));                    % Get the Jacobian at the current state

        m(i) = sqrt(det(J*J'));
        if m(i) < epsilon  % If manipulability is less than given threshold
            lambda = 0.1;%(1 - m(i)/epsilon)*5E-2;
        else
            lambda = 0;
        end
        invJ = inv(J'*J + lambda *eye(6))*J';                               % DLS Inverse

        qdot = invJ*velocity;                                                 % Solve velocitities via RMRC
        qRMatrix(i+1,:) =  qRMatrix(i,:) + deltaT*qdot';                    % Update next joint state
      
        for j = 1:6                                                         % Loop through joints 1 to 6
            if qRMatrix(i,j) + deltaT*qdot(j)' < robot.model.qlim(j,1)             % If next joint angle is lower than joint limit...
                qdot(i,j) = 0; % Stop the motor
            elseif qRMatrix(i,j) + deltaT*qdot(j)' > robot.model.qlim(j,2)         % If next joint angle is greater than joint limit ...
                qdot(i,j) = 0; % Stop the motor
            end
        end
        robot.model.animate(qRMatrix(i,:));
        pause(0.001);
    end 
    lastPose = qRMatrix(end,:);
end

%% Dobot Travel Method Outside of Class 
% Only for independent movement of the robot.
function DTravel(robot, q1, q2, steps, mode)

    % mode:
    %   1 - Trapezoidal
    %   2 - Quintic Polynomial

    % TO DO LIST:
    % - Add choice between trapezoidal, quintic polynomial, RMRC.
    % - Manipulability measure for singularities and DLS
    % - Move simultaneously with the other robot and all other
    % objects with some universal motion function. 
    % - Attach points for items and grippers.

    if mode == 1
        s = lspb(0,1,steps);    % Create matrix describing trapezoidal trajectory 
        %                           movement varying smoothly from S0 to SF (time)
        %                           in M steps. V can be specified, but is computed
        %                           automatically. 
        qMatrix = nan(steps,robot.model.n);
        for i=1:steps
            qMatrix(i,:) = (1-s(i))*q1 + s(i)*q2;
       end
    elseif mode == 2
        qMatrix = jtraj(q1, q2, steps);
    end
       for i=1:steps
           robot.model.animate(qMatrix(i,:));
           pause(0.01);
       end
end