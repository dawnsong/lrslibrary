%%% convert_video2d_to_avi(2dmatrix,int,int,int)
% I - Input matrix
% nFrames - Number of frames
% vidHeight - Video height
% vidWidth - Video width
%
function convert_video2d_to_avi(I,nFrames,vidHeight,vidWidth,filename)
  %warning('off','all');
  
  if(~isempty(I)) 
    movobj_I(1:nFrames) = struct('cdata', [], 'colormap', []);
  else
    error('Invalid input matrix!');
  end
  
  for i = 1 : nFrames
    %
    % Convert input to rgb image 
    %
    Input = reshape(I(:,i),vidHeight,vidWidth);
    Input = mat2gray(Input);
    Input = im2uint8(Input);
    rgbImage = repmat(Input,[1 1 3]);
    movobj_I(i).cdata = rgbImage;
  end
  
  disp(['Saving results at: ' filename]);
  %movie2avi(movobj_I, filename, 'compression', 'None'); %obsolete in
  %Matlab 2016b
  v = VideoWriter(filename, 'Uncompressed AVI');
  open(v);   writeVideo(v, movobj_I); close(v);
  
  disp('OK');
  
  %warning('on','all');
end
