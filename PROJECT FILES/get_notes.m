function notes = get_notes(I)
%A function that takes an input image, I, and using the sift algorithm,
%returns the total note value in the picture with how many of each note
%there are
%Input:
%I - An rgb image of a scene with (possibly) notes in it.
%Output:
%notes - A struct array with fields: money - the total note money in the
%   picture and {'five1'; 'five2'; 'ten1'; 'ten2'; 'twenty1'; 'twenty2';
%'fifty1'; 'fifty2'} which are how many of each note type there are. Note
%that five1 and five2 are both 5 dollar notes, just different sides of the
%note.
%
%Lewis Chambers October 2013

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