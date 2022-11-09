%% run after script 1
clear
addpath(genpath('/opt/fsl/6.0.1/etc/matlab'))

datapath='/project/3022035.03/LEAP_long/data/flica_output/VBM_DWI_congrads/';
%datapath='/project/3022035.03/Ting_ICA_LICA/ICA_VBM/';
%datapath='/project/3022035.03/Ting_ICA_LICA/linkedICA_VBM_DTI/';

mods={'G2'};

for k=1
    mod=mods{k};
    [img,dims,scales,bpp,endian] = read_avw(strcat(datapath, '/niftiOut_mi7.nii.gz'));

    for i=1:dims(4)
        tmp=img(:,:,:,i);
        tmp=tmp(:);
        idx=find(tmp~=0);
        tmp2=tmp(idx);
        %tmp2=(tmp2-mean(tmp2))/std(tmp2);
        tmp(idx)=tmp2;
        dum=reshape(tmp,dims(1),dims(2),dims(3));
        img2(:,:,:,i)=dum;

    end

    save_avw(img2,strcat(datapath,'/Non_normalized_',mod,'.nii.gz'),'f',scales);
    clear img2
    clear img
end
