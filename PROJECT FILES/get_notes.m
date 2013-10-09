function notes = get_notes(I)
thresh_score = 25000;
thresh_num = 20;
%Get the image features of the Image
Ig = rgb2gray(I);
[f_I, d_I] = vl_sift(single(Ig));
disp('Finding Notes:');
%Get all of the notes image files
addpath('notes');
NoteName = {'five1'; 'five2'; 'ten1'; 'ten2'; 'twenty1'; 'twenty2'; 'fifty1'; 'fifty2'};
NoteVal = [5,5,10,10,20,20,50,50];
notes.money = 0;
for i=1:length(NoteName)
    %Get features
    eval([NoteName{i} ' = rgb2gray(imread(''' NoteName{i} '.jpg''));']);
    eval(['[f_' NoteName{i} ', d_' NoteName{i} '] = vl_sift(single(' NoteName{i} '));']);
    %Match them
    eval(['[matches scores] = vl_ubcmatch(d_' NoteName{i} ', d_I);']);
    disp(NoteName{i})
    %Check for threshold
    if sum(scores>thresh_score) > thresh_num
        eval(['notes.' NoteName{i} ' = 1;']);
        notes.money = notes.money + NoteVal(i);
    else
        eval(['notes.' NoteName{i} '= 0;']);
    end
end
end