function [im] = raw2mat(path)  %path to mhd
fileID = fopen(path);
%f = strjoin(cellstr(fread(fileID,'*char')));
tline = fgetl(fileID);
mhd = cell(1,1);
i = 0;
while ischar(tline)
    i= i+1;
    mhd{i} = tline;
    tline = fgetl(fileID);
end

line = find(contains(mhd,'DimSize'));
num = regexp(mhd{line}, '\d+', 'match');
imsize = [str2num(num{1}) str2num(num{2})];

fclose(fileID);

im = zeros(imsize,'uint16');
fileID = fopen(regexprep(path,'mhd','raw'));
tmp = fread(fileID, imsize(1)*imsize(2),'uint16=>uint16');
im(:) = tmp;
im = permute(im, [2 1]);
fclose(fileID);

end