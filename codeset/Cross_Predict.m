function acc = Cross_Predict(merge_dir, current, result_dir, dataname)

load([merge_dir, current]);  % »ñÈ¡ data ºÍ label
wave(isnan(wave)) = 0;
x = length(lab);
k = 10;
indices=crossvalind('Kfold',x,k);
wave = (wave');
features = (length(wave(1,:)))/5;
for i = 1:2
    train_wave = wave(indices~=i,[(1:features),(features+1:2*features),(2*features+1:3*features),(3*features+1:4*features),(4*features+1:5*features)]~=0);
    train_lab = lab(indices~=i);
    test_wave = wave(indices==i,[(1:features),(features+1:2*features),(2*features+1:3*features),(3*features+1:4*features),(4*features+1:5*features)]~=0);
    test_lab = lab(indices==i);    
    [r1,r2,r3,r4]=RF_predict(train_wave,train_lab',test_wave,test_lab');
    matrix(i,:)=[r1,r2,r3,r4];
end
acc = max(matrix(:));
save([result_dir,dataname],'matrix','acc');