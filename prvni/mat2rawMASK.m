function [] = mat2rawMASK(im, path, name)
% mat2rawMASK(ones(100,100), 'V:\mpc\ab2\Lecture5\prvni', 'test')

mkdir(path);

imSize = size(im);
imDim = ndims(im);

%% MHD
mhd = cell(13,1);
mhd{1} = 'ObjectType = Image';
mhd{2} = ['NDims = ', num2str(imDim)];
mhd{3} = 'ElementType = MET_USHORT';
mhd{4} = 'CompressData = False';

if imDim == 2
    mhd{5} = ['DimSize = ', num2str(imSize(2)), ' ', num2str(imSize(1))];
    mhd{6} = 'ElementSpacing = 1 1';
    mhd{7} = 'TransformMatrix = 1 0 0 1';
    mhd{8} = 'Offset = 0 0';
    mhd{9} = 'CenterOfRotation = 0 0';
elseif imDim == 3
    mhd{5} = ['DimSize = ', num2str(imSize(2)), ' ', num2str(imSize(1)), ' ', num2str(imSize(3))];
    mhd{6} = 'ElementSpacing = 1 1 1';
    mhd{7} = 'TransformMatrix = 1 0 0 0 1 0 0 0 1';
    mhd{8} = 'Offset = 0 0 0';
    mhd{9} = 'CenterOfRotation = 0 0 0';
end

mhd{10} = 'BinaryData = True';
mhd{11} = 'BinaryDataByteOrderMSB = False';
mhd{12} = 'AnatomicalOrientation = RAI';
mhd{13} = ['ElementDataFile = ', name, '.raw'];

fileID = fopen(fullfile(path, [name, '.mhd']),'w');
for i=1:length(mhd)
    fprintf(fileID, '%s\n', mhd{i});
end
fclose(fileID);

%% RAW
% im = im2double(im);
% im = uint16(im.*(2.^15));
im = permute(im, [2 1 3]);

fileID = fopen(fullfile(path, [name, '.raw']),'w');
fwrite(fileID, im(:), 'uint16');
fclose(fileID);

end