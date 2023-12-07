%Below is an example execution of the LSTM network to obtain medial and
%lateral knee joint contact forces from an sample dataset. Note that the
%Deep Learning Toolbox is required to run this script.

%A 4 (var) x 101 (timepoint) matrix of kinematics (degrees) is required to run the
%LSTM Network. Kinematic waveforms must follow the right hand rule, be in
%z-score format, and organized in the following rows
    %hip flx/ext
    %hip ad/abd
    %knee ad/abd
    %ankle drs/pltr


%Cite Bennett, et al. 2024 "PREDICTING KNEE JOINT CONTACT 
%FORCES DURING NORMAL WALKING USING KINEMATIC INPUTS WITH
%A LONG-SHORT TERM NEURAL NETWORK". J Bio Eng 

%% 

%read in sample dataset, including raw kinematic data and LSTM scalars
load ('KJCF_Sample_Data.mat')
%Sample_KinData is a table containing the requried kinematic data
%LSTM_mustd is a table of the scalar values requried to transform data to zscores

%Time-normalize kinematic data to 101 time points
norm_step=linspace(Sample_KinData.Time(1),Sample_KinData.Time(end),101);
nSample_KinData=interp1(Sample_KinData.Time,table2array(Sample_KinData(:,2:5)),norm_step,'pchip');

%Generate Z-Scores for kinematic data in a 4x101 mat format
zSample_KinData=(nSample_KinData'-LSTM_mustd.Mu)./LSTM_mustd.Std;

%Predict medial and lateral knee joint contact forces 
load ('KJCF_LSTM.mat') %Load network
Pred_KJCF=predict(KJCF_LSTM,zSample_KinData); %Predict function available from Deep Learning Toolbox

%Plot results
figure('name','Predictions from Sample Data')
subplot(2,1,1)
plot(Pred_KJCF(1,:))
title('Medial KJCF')
ylabel('Force (BWs)')
xlabel('Time (% Stance Phase)')
subplot(2,1,2)
plot(Pred_KJCF(2,:))
title('Lateral KJCF')
ylabel('Force (BWs)')
xlabel('Time (% Stance Phase)')