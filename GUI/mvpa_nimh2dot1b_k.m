function [subj_results] = mvpa_nimh2dot1b()

% Script to analyse fMRI data.
%
% [SUBJ RESULTS] = mvpa_script()
%
% This is the sample script for the Vanderweyen Zhu Joseph study. 
% See the accompanying TUTORIAL_EASY.HTM, the
% MVPA manual (MANUAL.HTM) and then TUTORIAL_HARD.HTM.

% License:
%=====================================================================
%
% This is part of the Princeton MVPA toolbox, released under
% the GPL. See http://www.csbmb.princeton.edu/mvpa for more
% information.
%
% Modified by Davy Vanderweyen, staring on July 9th, 2014.
% 
% The Princeton MVPA toolbox is available free and
% unsupported to those who might find it useful. We do not
% take any responsibility whatsoever for any problems that
% you have related to the use of the MVPA toolbox.
%
% ======================================================================

% Check to make sure the Neuralnetwork toolbox is in the path or this
% won't work.
if ~exist('newff') %#ok<EXIST>
    error('This tutorial requires the neural networking toolbox, if it is unavailable this will not execute');
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZING THE SUBJ STRUCTURE

% user input is required to load a specific subject
% then create an empty subj structure
subj_number=input('Please input subject number ','s');
exp_design=input('Got it, now what is the experimental design? (cat/sim)','s');
subj = init_subj('mvpa',subj_number);
x=0;
while x<1                                       % checks the spelling
    if strcmpi(exp_design,'cat')==1
        fprintf('Loading subject %s information...\n',subj_number);
        x=2;
    elseif strcmpi(exp_design,'sim')==1
        fprintf('Loading subject %s information...\n',subj_number);
        x=2;
    else
        warning('mywarning:warncode','Experimantal design unrecognized. Try again.')
        exp_design=input('What is the experimental design? (cat/sim)','s');
    end
end
clear x;
disp('Subject workplace created.')

%%% create the masks that will be used when loading in the data
disp('Loading masks...')
origin = pwd;
cd('C:\Users\davy\Documents\MATLAB\nimh2.1b\mask')
x=0;
while x<1
    mask_id=input('Which FFA mask do you want to use? (r/l)','s');
    if strcmpi(mask_id,'r')==1
        subj=load_afni_mask(subj,'Right Fusiform Face Area','Fusiform_R+tlrc');
        side='right';
        x=2;
    elseif strcmpi(mask_id,'l')==1
        subj=load_afni_mask(subj,'Left Fusiform Face Area','Fusiform_L+tlrc');
        side='left';
        x=2;
    else
        warning('mywarning:warncode','Mask specification unrocognized. Try again.')
    end
end
clear x;
disp('Mask(s) fully loaded.');
cd(origin)
% now we can check our masks if we feel like it
x=0;
while x<1
    R=input('Would you like to check your mask(s)? (y/n)','s');
    if strcmpi(R,'y')==1
        x=2;
        summarize(subj,'objtype','mask')
    elseif strcmpi(R,'n')==1
        disp('As you wish.')
        x=2;
    else
        warning('mywarning:warncode','Typo, please try again')
    end
end
clear x;


% now, read and set up the actual data. load_AFNI_pattern reads in the
% EPI data from a BRIK file, keeping only the voxels active in the
% mask (see above)

frag_number=input('How many data fragments per subject?');
frag_mat=zeros(1,frag_number);
raw_filenames={frag_mat(1),frag_mat(2),frag_mat(3),frag_mat(4)};
if strcmpi(exp_design,'cat')==1
    for i=1:4
        cc={'Guita','FaceS','Fish2','FaceY'};
        raw_filenames{i}= sprintf('%s_TP_%s+tlrc', subj_number, cc{i});
    end
elseif strcmpi(exp_design,'sim')==1
    for i=1:4
        dd={'SS3','SS2','SS1','SS4'};
        raw_filenames{i}=sprintf('%s_%s+tlrc',subj_number,dd{i});
    end
end
cd(sprintf('C:\\Users\\davy\\Documents\\MATLAB\\nimh2.1b\\%s',subj_number))
if strcmpi(exp_design,'cat')==1   
        switch mask_id        
            case 'r'   
                subj = load_afni_pattern(subj,'epi_cat_right','Right Fusiform Face Area',raw_filenames);      
            case 'l'         
                subj = load_afni_pattern(subj,'epi_cat_left','Left Fusiform Face Area',raw_filenames);
        end
elseif strcmpi(exp_design,'sim')==1   
        switch mask_id
            case 'r'           
                subj = load_afni_pattern(subj,'epi_sim_right','Right Fusiform Face Area',raw_filenames);      
            case 'l'         
                subj = load_afni_pattern(subj,'epi_sim_left','Left Fusiform Face Area',raw_filenames);   
        end
end

x=0;                           % check pattern
while x<1
    R=input('Visualize imported data? (y/n)','s');
    if strcmpi(R,'y')==1
        summarize(subj,'objtype','pattern')
        x=2;
    elseif strcmpi(R,'n')==1
        disp('Your choice.')
        x=2;
    else
        disp('Typo, try again.')
    end
end


% initialize the regressors object in the subj structure, load in the
% contents from a file, set the contents into the object, add a
% cell array of condnames to the object for future reference, and
% store the names of the regressor conditions
disp('Loading condition regressor.')
subj = init_object(subj,'regressors','conds');
load(sprintf('%s_regressor',exp_design));
subj = set_mat(subj,'regressors','conds',regs);
if strcmpi(exp_design,'cat')==1
    condnames = {'Guitar','Synthetic_face','Fish','Yearbook_face'};
    subj = set_objfield(subj,'regressors','conds','condnames',condnames);
elseif strcmpi(exp_design,'sim')==1
    condnames={'SS3','SS2','SS1','SS4'};
    subj = set_objfield(subj,'regressors','conds','condnames',condnames);
end

x=0;
while x<1
    R=input('Check regressor information? (y/n)','s');
    if strcmpi(R,'y')==1
        summarize(subj,'objtype','regressors')
        x=2;
    elseif strcmpi(R,'n')==1
        disp('You said it.')
        x=2;
    else
        disp('Typo, try again.')
    end
end
clear x;

% initialize the selectors object, then read in the contents
% for it from a file, and set them into the object
subj = init_object(subj,'selector','runs');
load('runs');
subj = set_mat(subj,'selector','runs',runs);
x=0;
while x<1
    R=input('Check run selector? (y/n)','s');
    if strcmpi(R,'y')==1
        summarize(subj,'objtype','selector')
        x=2;
    elseif strcmpi(R,'n')==1
        disp('Alright.')
        x=2;
    else
        disp('Typo, try again.')
    end
end
clear x;

% regressor convolution to take into account the haemodynamic response lag
%subj=convolve_regressors_afni(subj,'conds','runs','overwrite_if_exist',true,'binarize_thresh',0.5);

% getting rid of rest
%subj=create_norest_sel(subj,'conds_convt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRE-PROCESSING - z-scoring in time and no-peeking anova

% we want to z-score the EPI data (called 'epi'),
% individually on each run (using the 'runs' selectors)
subj = zscore_runs(subj,sprintf('epi_%s_%s',exp_design,side),'runs');

% now, create selector indices for the n different iterations of
% the nminusone
subj = init_object(subj,'selector','blocks');
blocks=runs_to_blocks(regs);
subj = set_mat(subj,'selector','blocks',blocks);
subj = create_xvalid_indices(subj,'blocks');%,'actives_selname','conds_convt_norest','new_selstem','runs_norest_xval');

% run the anova multiple times, separately for each iteration,
% using the selector indices created above
selection_method=input('Anova (a) or Kruskal-Wallis (k)?','s');
switch selection_method
    case 'a'
        [subj] = feature_select(subj,sprintf('epi_%s_%s_z',exp_design,side),'conds','blocks_xval');%'conds_convt','runs_norest_xval');
    case 'k'
        [subj] = feature_select_kruskalwallis(subj,sprintf('epi_%s_%s_z',exp_design,side),'conds','blocks_xval');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASSIFICATION - n-minus-one cross-validation

% set some basic arguments for a backprop classifier
class_args.train_funct_name = 'train_bp';
class_args.test_funct_name = 'test_bp';
class_args.nHidden = 0;

% now, run the classification multiple times, training and testing
% on different subsets of the data on each iteration
[subj_results] = cross_validation(subj,sprintf('epi_%s_%s_z',exp_design,side),'conds','blocks_xval',sprintf('epi_%s_%s_z_thresh0.05',exp_design,side),class_args);%'conds_convt','runs_norest_xval',sprintf('epi_%s_%s_z_thresh0.05',exp_design,side),class_args);
end