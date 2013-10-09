% Author: Kevin Kowalski (Caltech '12, B.S. Computer Science)
% Neural Signal Processing Laboratory (http://www.nsplab.org), UCLA
% Last revision: 30 May 2012

% -------- OVERVIEW --------
% This function runs 'nTrials' consecutive cursor movement trials where the
% goal of the subject is to move the cursor from its start position into
% the center target by controlling it with his or her hand, and to hold it
% there for the duration of the hold period, 'holdLength'. Before the
% trials begin, the Kinect must be calibrated by holding the "phi pose"
% until the Kinect recognizes it (see our tutorial document).

function [] = runKinectTrialSet()
addpath('Mex');

try
% Set the system parameters.
humanHandedness = 'right'; % Which hand the subject uses to control cursor.
nTrials = 10; % Number of trials the demo runs for.
timeBetweenTrials = 2; % Number of seconds of downtime between trials.
timeBin = 1 / 30; % Updates velocity every 'timeBin' sec. Kinect max = 1/30
maxTrialLength = 3; % Max trial length in seconds.
startMag = 0.2; % Cursor starts this many (simulated) meters from origin.
target = [0; 0]; % Location of reaching target relative to screen center.
targetRadius = 0.05; % The radius of the target in meters.
holdLength = 0.5; % Hold period length in seconds. 

% Initialize the Kinect.
humanKinect = mxNiCreateContext('Config/SamplesConfig.xml');

% Get positions of human skeleton components.
humanSkeletonPosList = mxNiSkeleton(humanKinect);
if(strcmp(humanHandedness, 'right'))
    humanHandPos = humanSkeletonPosList(8, 3:5)'; % (x,y,z) of right hand
elseif(strcmp(humanHandedness, 'left'))
    humanHandPos = humanSkeletonPosList(5, 3:5)'; % (x,y,z) of left hand
end

% Initialize the window that displays the starting circle, target, and
% cursor position.
figureHandle = figure('Position', get(0,'ScreenSize'));
hold on;
plot(startMag * cos(0:pi/32:2*pi), ...
   startMag * sin(0:pi/32:2*pi), 'k-', 'LineWidth', 3); % starting circle
plot(targetRadius * cos(0:pi/32:2*pi), ...
   targetRadius * sin(0:pi/32:2*pi), 'r-', 'LineWidth', 3); % target circle
axis(startMag * 1.25 * [-1 1 -1 1]);
axis square;
drawnow;

% The calibration period. The code loops here until the subject
% successfully calibrates the Kinect by assuming the "phi pose".
while(humanSkeletonPosList(1) == 0)
    mxNiUpdateContext(humanKinect);
    humanSkeletonPosList = mxNiSkeleton(humanKinect);
end

% Initializes and executes each trial.
for trialNum = 1:nTrials
    % -------- INITIALIZE THE TRIAL --------
    % Clear the image and redraw the starting circle and target circle.
    clf(figureHandle);
    hold on;
    plot(startMag * cos(0:pi/32:2*pi), ...
       startMag * sin(0:pi/32:2*pi), 'k-', 'LineWidth', 3);
    plot(targetRadius * cos(0:pi/32:2*pi), ...
       targetRadius * sin(0:pi/32:2*pi), 'r-', 'LineWidth', 3);
    axis(startMag * 1.25 * [-1 1 -1 1]);
    axis square;
    drawnow;

    % Randomly choose a starting position on the starting circle.
    startAngle = 2 * pi * rand();
    cursorPos = [startMag * cos(startAngle); startMag * sin(startAngle)];
    
    % Draw the location of the cursor.
    plot(cursorPos(1), cursorPos(2), 'g.')
    drawnow;

    % Wait for 'timeBetweenTrials' seconds, periodically drawing a blue
    % sequence of dots that point towards the start position to cue the
    % user.
    breakStart = tic();
    timeElapsed = 0;
    numDrawn = 0;
    startPos = 1.2 * cursorPos;
    while(timeElapsed < timeBetweenTrials)
        if(timeElapsed / timeBetweenTrials > numDrawn / 20)
            currentPos = timeElapsed / timeBetweenTrials * ...
                (cursorPos - startPos) + startPos;
            numDrawn = numDrawn + 1;
            hold on;
            plot(currentPos(1), currentPos(2), 'b.')
            hold off;
            drawnow;
        end
        mxNiUpdateContext(humanKinect);

        timeElapsed = toc(breakStart);
    end

    % Acquire initial human hand location.
    timeStepStart = tic();
    mxNiUpdateContext(humanKinect);
    humanSkeletonPosList = mxNiSkeleton(humanKinect);
    if(strcmp(humanHandedness, 'right'))
        humanHandPos = humanSkeletonPosList(8, 3:5)';
    elseif(strcmp(humanHandedness, 'left'))
        humanHandPos = humanSkeletonPosList(5, 3:5)';
    end
    
    % -------- EXECUTE THE TRIAL --------
    timeStep = 1;
    holdCount = 0;
    while timeStep <= maxTrialLength / timeBin && ...
            holdCount < holdLength / timeBin

        % Obtain the human's new hand position.
        mxNiUpdateContext(humanKinect);
        humanSkeletonPosList = mxNiSkeleton(humanKinect);
        if(strcmp(humanHandedness, 'right'))
            newHumanHandPos = humanSkeletonPosList(8, 3:5)';
        elseif(strcmp(humanHandedness, 'left'))
            newHumanHandPos = humanSkeletonPosList(5, 3:5)';
        end

        % Values returned by mxNiSkeleton() are in millimeters, so we need
        % to multiply by 0.001 to convert them to meters. Also, we ignore
        % the z-component of the human's hand position for this
        % illustration.
        cursorVelocity = 0.001 * ...
            (newHumanHandPos(1:2) - humanHandPos(1:2));
        cursorPos = cursorPos + cursorVelocity;
        humanHandPos = newHumanHandPos;
        
        % Update 'timeStep', and check to see if the subject has kept the
        % cursor in the target area for the hold period.
        timeStep = timeStep + 1;
        if(sum((cursorPos - target(1:2)).^2) < targetRadius^2)
            holdCount = holdCount + 1;
        else
            holdCount = 0;
        end

        % Draw the location of the cursor as a green dot.
        hold on;
        plot(cursorPos(1), cursorPos(2), 'g.');
        hold off;
        drawnow;

        timeStepLength = toc(timeStepStart);
        % Wait until end of time bin before moving on to next time step.
        while(timeStepLength < timeBin)
            timeStepLength = toc(timeStepStart);
        end
    end
end

mxNiDeleteContext(humanKinect); % Stops the Kinect.

catch err
    mxNiDeleteContext(humanKinect);
    rethrow(err);
end