%{
  !scp -rp rangan@access1.cims.nyu.edu:/data/rangan/dir_bcc/dir_tutorial_081915/tutorial_*.m /scratch/avr209/dir_bcc/dir_tutorial_081915/ ;
   !scp -rp /scratch/avr209/dir_bcc/dir_tutorial_081915/dir_GSE17536/GSE17536_n0x* rangan@access1.cims.nyu.edu:/data/rangan/dir_bcc/dir_tutorial_081915/dir_GSE17536/ ;
   !scp -rp /scratch/avr209/dir_bcc/dir_tutorial_081915/dir_GSE17536/dir_GSE17536_n0x_prm/ rangan@access1.cims.nyu.edu:/data/rangan/dir_bcc/dir_tutorial_081915/dir_GSE17536/ ;
   !scp -rp /scratch/avr209/dir_bcc/dir_tutorial_081915/dir_GSE17536/dir_FIGS/GSE17536*.* rangan@access1.cims.nyu.edu:/data/rangan/dir_bcc/dir_tutorial_081915/dir_GSE17536/dir_FIGS/ ;
   !scp -rp /scratch/avr209/dir_bcc/dir_tutorial_081915/dir_GSE17536/GSE17536_n0x*.* rangan@access1.cims.nyu.edu:/data/rangan/dir_bcc/dir_tutorial_081915/dir_GSE17536/dir_txt/ ;
  %}

local_flag=0; 
%{
  bash ;
  cd /data/rangan/dir_bcc/dir_tutorial_081915/hierarchical/ ;
  source init.sh ;
  javac seek/GeneEnrichmentTest.java ;
  java seek.GeneEnrichmentTest -h
  %}

run_type = []; run_type = input(' %% run_type: ? [-1 = 0 & 1; 0 = run biclustering on data(default); 1 = run permutations; 2 = collate; 3 = gene_enrichment; 4 = summarize] '); if isempty(run_type); run_type = 0; end;
if run_type==3; 
local_flag=1; 
end; %if run_type==3;
if run_type==4;
local_flag=0;
end;% if run_type==4;
rerun_flag=0;
if (run_type==-1 | run_type==0 | run_type==1);
rerun_flag=[]; rerun_flag = input(' %% rerun_flag: ? [0 = no, preserve older finished runs; 1 = yes, rerun everything (default)]'); if isempty(rerun_flag); rerun_flag = 1; end;
end;%if (run_type==-1 | run_type==0 | run_type==1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if local_flag==1; path_base = '/data/rangan/dir_bcc/dir_tutorial_081915/'; else path_base = '/scratch/avr209/dir_bcc/dir_tutorial_081915/'; end;
%GSEstr_ra = {'GSE10072','GSE11024','GSE17536','GSE17612','GSE17895','GSE31552','GSE3307','GSE3790','GSE4290','fineILCs'};
GSEstr_ra = {'GSE17536'};
for ngse = 1:length(GSEstr_ra);
GSEstr = GSEstr_ra{ngse};
GSE_path = sprintf('%sdir_%s/',path_base,GSEstr);
if run_type==3;
if exist(sprintf('%stutorial_genri.sh',GSE_path),'file'); delete(sprintf('%stutorial_genri.sh',GSE_path)); end;
end;%if run_type==3;
gen_fname_ra = {sprintf('%s_n0_',GSEstr),sprintf('%s_n1_',GSEstr),sprintf('%s_n2_',GSEstr),sprintf('%s_n0x',GSEstr),sprintf('%s_n1x',GSEstr),sprintf('%s_n2x',GSEstr),sprintf('%s_nA_',GSEstr),sprintf('%s_nAx',GSEstr)};
for ng=1:length(gen_fname_ra);
gen_fname = gen_fname_ra{ng};
nnodes = 1; ppn = 2; memdecl = 18; walltime = 24;
run_flag=1;nthreads=2;
for frwd_vs_back = {'frwd','back'};
if run_type==1 | run_type==0 | run_type==-1; 
if run_type==0 | run_type==-1;
fname_to_find = sprintf('%s%s_%s_out_xdrop.txt',GSE_path,gen_fname,frwd_vs_back{1});
if (~rerun_flag & exist(fname_to_find,'file')); if ~rerun_flag; disp(sprintf(' %% found %s, not rerunning...',fname_to_find)); end; end;
if rerun_flag | (~rerun_flag & ~exist(fname_to_find,'file')); if ~rerun_flag; disp(sprintf(' %% could not find %s, rerunning...',fname_to_find)); end;
if local_flag;
tutorial_w1(GSE_path,gen_fname,1,0,6,frwd_vs_back{1},nthreads);
 else;% if not local;
command_string = sprintf('tutorial_w1(''%s'',''%s'',%d,%d,%d,''%s'',%d);',GSE_path,gen_fname,1,0,6,frwd_vs_back{1},nthreads);
hpc_launcher(command_string,nnodes,ppn,memdecl,walltime);
end;% if local_flag;  
end;% if run;
end;%if run_type==0 | run_type==-1;
if run_type==1 | run_type==-1;
path_pre_prm = sprintf('%sdir_%s_prm/',GSE_path,gen_fname);
prm_batch_max = 64;
prm_batch_num=0; command_string = '';
for (prm_flag=1:2048);
path_use = path_pre_prm;
prm_pre = 'prm';prefix_use = sprintf('%s_%s%.3d',gen_fname,prm_pre,prm_flag);
fname_to_find = sprintf('%s%s_%s_out_trace.txt',path_use,prefix_use,frwd_vs_back{1});
if rerun_flag | (~rerun_flag & ~exist(fname_to_find,'file')); if ~rerun_flag; disp(sprintf(' %% could not find %s, rerunning...',fname_to_find)); end;
if local_flag;
tutorial_w1(GSE_path,gen_fname,0,prm_flag,1,frwd_vs_back{1},nthreads);
 else;% if not local;
command_string = sprintf('%s;\n tutorial_w1(''%s'',''%s'',%d,%d,%d,''%s'',%d);',command_string,GSE_path,gen_fname,0,prm_flag,1,frwd_vs_back{1},nthreads);
prm_batch_num = prm_batch_num+1;
if (prm_batch_num==prm_batch_max);
%disp(command_string);
hpc_launcher(command_string,nnodes,ppn,memdecl,walltime);
prm_batch_num=0; command_string = '';
end;% if (prm_batch_num==prm_batch_max);
end;% if local_flag;
end;% if run;
end;% for (prm_flag=1:2048);
if (prm_batch_num>0); % leftovers;
%disp(command_string);
hpc_launcher(command_string,nnodes,ppn,memdecl,walltime);
prm_batch_num=0; command_string = '';
end;% if (prm_batch_num>0);
end;% if run_type==1 | run_type==-1;
end;% if run_type==1 | run_type==0 | run_type==-1;
if run_type==2; % tutorial_collate;
if local_flag;
tutorial_collate(GSE_path,gen_fname,frwd_vs_back{1});
 else;% if not local;
command_string = sprintf('tutorial_collate(''%s'',''%s'',''%s'');',GSE_path,gen_fname,frwd_vs_back{1});
hpc_launcher(command_string,nnodes,ppn,memdecl,walltime);
end;% if local_flag;  
end;% if run_type==2;
if run_type==3; % tutorial_genri;
% designed to evalute gene-enrichments of gene-sets stored in files such as GSE3307_n2x_frwd_1_glist.txt ;
% note that this uses seek.GeneEnrichTest. ;
% Must run something like: ;
% bash; cd /data/rangan/dir_bcc/dir_code_012015/hierarchical/; javac seek/GeneEnrichmentTest.java;
% before seek will function ;
tutorial_genri(sprintf('%sdir_txt/',GSE_path),gen_fname,frwd_vs_back{1},sprintf('%stutorial_genri.sh',GSE_path));
end;%if run_type==3;
if run_type==4; % tutorial_summarize;
% designed to summarize gene-enrichments of gene-sets stored in files such as GSE3307_n2x_frwd_1_genri.txt ;
if 1 | local_flag; 
try; tutorial_summarize(sprintf('%s',GSE_path),gen_fname,frwd_vs_back{1}); catch; end;%try; 
 else;% if not local;
command_string = sprintf('tutorial_summarize(''%s'',''%s'',''%s'');',GSE_path,gen_fname,frwd_vs_back{1});
hpc_launcher(command_string,nnodes,ppn,memdecl,walltime);
end;%if local_flag;
end;%if run_type==4;
end;% for frwd_vs_back = {'fwrd','back'};
end;% for ng = 1:length(gen_fname_ra);
end;% for ngse = 1:length(GSEstr_ra);
