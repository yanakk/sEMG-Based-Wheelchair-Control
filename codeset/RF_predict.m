function [r1,r2,r3,r4]=RF_predict(wave,lab,wav,la)

% trainset=wavetrain;
% predictset=wavetest; 
% 
% lab=trainset.lab;
% wave=trainset.wave;
% la=predictset.lab;
% wav=predictset.wave; 
% 
% lab = lab';
% la=la';
% wave = zscore(wave');
% wav = zscore(wav');

%modify so that training data is NxD and labels are Nx1, where N=#of
%examples, D=# of features

% X = inputs';
% Y = outputs;
%  
% [N D] =size(X);
%randomly split into 250 examples for training and 50 for testing
% randvector = randperm(N);

X_trn = wave;%X(randvector(1:250),:);
Y_trn = lab;%Y(randvector(1:250));
X_tst = wav;%X(randvector(251:end),:);
Y_tst = la;%Y(randvector(251:end));
mtry = 5;
% example 1:  simply use with the defaults
    model = classRF_train(X_trn,Y_trn, 800, mtry);
    obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb);
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 1: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));
%     err=find(Y_hat~=Y_tst);
    r1=1-length(find(Y_hat~=Y_tst))/length(Y_tst);
% example 2:  set to 100 trees
    model = classRF_train(X_trn,Y_trn, 700, mtry);
        obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb)
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 2: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));
    r2=1-length(find(Y_hat~=Y_tst))/length(Y_tst);
% example 3:  set to 100 trees, mtry = 2
    model = classRF_train(X_trn,Y_trn, 600, mtry);
        obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb);
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 3: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));
    r3=1-length(find(Y_hat~=Y_tst))/length(Y_tst);
% example 4:  set to defaults trees and mtry by specifying values as 0
%     model = classRF_train(X_trn,Y_trn, 200);
%     Y_hat = classRF_predict(X_tst,model);
%     fprintf('\nexample 4: error rate %f\n',   length(find(Y_hat~=Y_tst))/length(Y_tst));
%     model = classRF_train(X_trn,Y_trn, 700);
%     Y_hat = classRF_predict(X_tst,model);
%     fprintf('\nexample 4: error rate %f\n',   length(find(Y_hat~=Y_tst))/length(Y_tst));
% example 5: set sampling without replacement (default is with replacement)
%     extra_options.replace = 0 ;
    model = classRF_train(X_trn,Y_trn, 500, mtry);
        obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb);
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 4: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));
    r4=1-length(find(Y_hat~=Y_tst))/length(Y_tst);
    if 0
    model = classRF_train(X_trn,Y_trn, 900, mtry);
        obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb)
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 5: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));
    model = classRF_train(X_trn,Y_trn, 1000, mtry);
        obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb);
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 6: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));    
    model = classRF_train(X_trn,Y_trn, 1100, mtry);
        obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb)
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 7: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));      
    model = classRF_train(X_trn,Y_trn, 1200, mtry);
        obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb);
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 8: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));     
    model = classRF_train(X_trn,Y_trn, 1300, mtry);
        obbm = model.errtr;
    obb = obbm(:,1);
    mean(obb);
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 9: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));      
% example 6: Using classwt (priors of classes)
%     clear extra_options;
%     extra_options.classwt = ones(1,10); %for the [-1 +1] classses in twonorm
%     % if you sort the labels in training and arrange in ascending order then
%     % for twonorm you have -1 and +1 classes, with here assigning 1 to
%     % both classes
%     % As you have specified the classwt above, what happens that the priors are considered
%     % also is considered the freq of the labels in the data. If you are
%     % confused look into src/rfutils.cpp in normClassWt() function
% 
%     model = classRF_train(X_trn,Y_trn, 200, 15, extra_options);
%     Y_hat = classRF_predict(X_tst,model);
%     fprintf('\nexample 6: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));

% example 7: modify to make class(es) more IMPORTANT than the others
    %  extra_options.cutoff (Classification only) = A vector of length equal to
    %                       number of classes. The 'winning' class for an observation is the one with the maximum ratio of proportion
    %                       of votes to cutoff. Default is 1/k where k is the number of classes (i.e., majority
    %                       vote wins).    clear extra_options;
    extra_options.cutoff = ones(1,10)* (1/12); %for the [-1 +1] classses in twonorm
    % if you sort the labels in training and arrange in ascending order then
    % for twonorm you have -1 and +1 classes, with here assigning 1/4 and
    % 3/4 respectively
    % thus the second class needs a lot less votes to win compared to the first class
    
    model = classRF_train(X_trn,Y_trn, 500, 10, extra_options);
    Y_hat = classRF_predict(X_tst,model);
%     fprintf('\nexample 7: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));
%     fprintf('   y_trn is almost 50/50 but y_hat now has %f/%f split\n',length(find(Y_hat~=-1))/length(Y_tst),length(find(Y_hat~=1))/length(Y_tst));
    r3=1-length(find(Y_hat~=Y_tst))/length(Y_tst);

%  extra_options.strata = (not yet stable in code) variable that is used for stratified
%                       sampling. I don't yet know how this works.

% example 8: sampsize example
    %  extra_options.sampsize =  Size(s) of sample to draw. For classification, 
    %                   if sampsize is a vector of the length the number of strata, then sampling is stratified by strata, 
    %                   and the elements of sampsize indicate the numbers to be drawn from the strata.
    clear extra_options
    extra_options.sampsize = size(X_trn,1)*2/3;
    
    model = classRF_train(X_trn,Y_trn, 500, 15, extra_options);
    Y_hat = classRF_predict(X_tst,model);
%     fprintf('\nexample 8: accuracy rate %f\n',   1-length(find(Y_hat~=Y_tst))/length(Y_tst));
    r4=1-length(find(Y_hat~=Y_tst))/length(Y_tst);
    end
end
    