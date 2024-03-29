A = A_orig; Z = Z_orig; T = T_orig>0; S = S_orig>0;
[MA,NA] = size(A); [MZ,NZ] = size(Z); 
ncovs = size(T,2)-1; % the first column of T,S should be all ones ;
cov_cat_A = T*transpose(2.^(0:ncovs)); cov_cat_Z = S*transpose(2.^(0:ncovs));
cov_A_up_orig_=cell(ncovs,1); 
cov_A_dn_orig_=cell(ncovs,1); 
cov_Z_up_orig_=cell(ncovs,1);
cov_Z_dn_orig_=cell(ncovs,1);
for ncov=0:ncovs-1;
cov_A_up_orig_{1+ncov} = find(T(:,1+1+ncov)==1);
cov_A_dn_orig_{1+ncov} = find(T(:,1+1+ncov)==0);
cov_Z_up_orig_{1+ncov} = find(S(:,1+1+ncov)==1);
cov_Z_dn_orig_{1+ncov} = find(S(:,1+1+ncov)==0);
end;%for ncov=0:ncovs-1;
X__AnAt_full = A*transpose(A);
X__AnZt_full = A*transpose(Z);
X__ZnZt_full = Z*transpose(Z);
XR_AAAA_full = diag( X__AnAt_full * transpose(X__AnAt_full) );
XC_AAAA_full = diag( transpose(A) * X__AnAt_full * A);
XR_AZZA_full = diag( X__AnZt_full * transpose(X__AnZt_full) );
XC_AZZA_full = diag( transpose(A) * X__AnZt_full * Z);
clear X__AnAt_full X__AnZt_full X__ZnZt_full ;
X__AnAt_upup_ = cell(ncovs,1); X__AnZt_upup_ = cell(ncovs,1); X__ZnZt_upup_ = cell(ncovs,1);
XR_AAAA_upup_ = cell(ncovs,1); XC_AAAA_upup_ = cell(ncovs,1); XR_AZZA_upup_ = cell(ncovs,1); XC_AZZA_upup_ = cell(ncovs,1);
X__AnAt_updn_ = cell(ncovs,1); X__AnZt_updn_ = cell(ncovs,1); X__ZnZt_updn_ = cell(ncovs,1);
XR_AAAA_updn_ = cell(ncovs,1); XC_AAAA_updn_ = cell(ncovs,1); XR_AZZA_updn_ = cell(ncovs,1); XC_AZZA_updn_ = cell(ncovs,1);
X__AnAt_dnup_ = cell(ncovs,1); X__AnZt_dnup_ = cell(ncovs,1); X__ZnZt_dnup_ = cell(ncovs,1);
XR_AAAA_dnup_ = cell(ncovs,1); XC_AAAA_dnup_ = cell(ncovs,1); XR_AZZA_dnup_ = cell(ncovs,1); XC_AZZA_dnup_ = cell(ncovs,1);
X__AnAt_dndn_ = cell(ncovs,1); X__AnZt_dndn_ = cell(ncovs,1); X__ZnZt_dndn_ = cell(ncovs,1);
XR_AAAA_dndn_ = cell(ncovs,1); XC_AAAA_dndn_ = cell(ncovs,1); XR_AZZA_dndn_ = cell(ncovs,1); XC_AZZA_dndn_ = cell(ncovs,1);
for ncov=0:ncovs-1;
X__AnAt_upup = A(cov_A_up_orig_{1+ncov},:)*transpose(A(cov_A_up_orig_{1+ncov},:));
X__AnZt_upup = A(cov_A_up_orig_{1+ncov},:)*transpose(Z(cov_Z_up_orig_{1+ncov},:));
X__ZnZt_upup = Z(cov_Z_up_orig_{1+ncov},:)*transpose(Z(cov_Z_up_orig_{1+ncov},:));
XR_AAAA_upup_{1+ncov} = diag( X__AnAt_upup * transpose(X__AnAt_upup) );
XC_AAAA_upup_{1+ncov} = diag(transpose(A(cov_A_up_orig_{1+ncov},:)) * X__AnAt_upup * A(cov_A_up_orig_{1+ncov},:) );
XR_AZZA_upup_{1+ncov} = diag( X__AnZt_upup * transpose(X__AnZt_upup) );
XC_AZZA_upup_{1+ncov} = diag(transpose(A(cov_A_up_orig_{1+ncov},:)) * X__AnZt_upup * Z(cov_Z_up_orig_{1+ncov},:) );
clear X__AnAt_upup X__AnZt_upup X__ZnZt_upup ;
X__AnAt_updn = A(cov_A_up_orig_{1+ncov},:)*transpose(A(cov_A_dn_orig_{1+ncov},:));
X__AnZt_updn = A(cov_A_up_orig_{1+ncov},:)*transpose(Z(cov_Z_dn_orig_{1+ncov},:));
X__ZnZt_updn = Z(cov_Z_up_orig_{1+ncov},:)*transpose(Z(cov_Z_dn_orig_{1+ncov},:));
XR_AAAA_updn_{1+ncov} = diag( X__AnAt_updn * transpose(X__AnAt_updn) );
XC_AAAA_updn_{1+ncov} = diag(transpose(A(cov_A_up_orig_{1+ncov},:)) * X__AnAt_updn * A(cov_A_dn_orig_{1+ncov},:) );
XR_AZZA_updn_{1+ncov} = diag( X__AnZt_updn * transpose(X__AnZt_updn) );
XC_AZZA_updn_{1+ncov} = diag(transpose(A(cov_A_up_orig_{1+ncov},:)) * X__AnZt_updn * Z(cov_Z_dn_orig_{1+ncov},:) );
clear X__AnAt_updn X__AnZt_updn X__ZnZt_updn ;
X__AnAt_dnup = A(cov_A_dn_orig_{1+ncov},:)*transpose(A(cov_A_up_orig_{1+ncov},:));
X__AnZt_dnup = A(cov_A_dn_orig_{1+ncov},:)*transpose(Z(cov_Z_up_orig_{1+ncov},:));
X__ZnZt_dnup = Z(cov_Z_dn_orig_{1+ncov},:)*transpose(Z(cov_Z_up_orig_{1+ncov},:));
XR_AAAA_dnup_{1+ncov} = diag( X__AnAt_dnup * transpose(X__AnAt_dnup) );
XC_AAAA_dnup_{1+ncov} = diag(transpose(A(cov_A_dn_orig_{1+ncov},:)) * X__AnAt_dnup * A(cov_A_up_orig_{1+ncov},:) );
XR_AZZA_dnup_{1+ncov} = diag( X__AnZt_dnup * transpose(X__AnZt_dnup) );
XC_AZZA_dnup_{1+ncov} = diag(transpose(A(cov_A_dn_orig_{1+ncov},:)) * X__AnZt_dnup * Z(cov_Z_up_orig_{1+ncov},:) );
clear X__AnAt_dnup X__AnZt_dnup X__ZnZt_dnup ;
X__AnAt_dndn = A(cov_A_dn_orig_{1+ncov},:)*transpose(A(cov_A_dn_orig_{1+ncov},:));
X__AnZt_dndn = A(cov_A_dn_orig_{1+ncov},:)*transpose(Z(cov_Z_dn_orig_{1+ncov},:));
X__ZnZt_dndn = Z(cov_Z_dn_orig_{1+ncov},:)*transpose(Z(cov_Z_dn_orig_{1+ncov},:));
XR_AAAA_dndn_{1+ncov} = diag( X__AnAt_dndn * transpose(X__AnAt_dndn) );
XC_AAAA_dndn_{1+ncov} = diag(transpose(A(cov_A_dn_orig_{1+ncov},:)) * X__AnAt_dndn * A(cov_A_dn_orig_{1+ncov},:) );
XR_AZZA_dndn_{1+ncov} = diag( X__AnZt_dndn * transpose(X__AnZt_dndn) );
XC_AZZA_dndn_{1+ncov} = diag(transpose(A(cov_A_dn_orig_{1+ncov},:)) * X__AnZt_dndn * Z(cov_Z_dn_orig_{1+ncov},:) );
clear X__AnAt_dndn X__AnZt_dndn X__ZnZt_dndn ;
end;%for ncov=1:ncovs;
cov_A_up_=cov_A_up_orig_;cov_A_dn_=cov_A_dn_orig_;cov_Z_up_=cov_Z_up_orig_;cov_Z_dn_=cov_Z_dn_orig_;
XR_AAAA_full_orig = XR_AAAA_full;XC_AAAA_full_orig = XC_AAAA_full;XR_AZZA_full_orig = XR_AZZA_full;XC_AZZA_full_orig = XC_AZZA_full;
XR_AAAA_upup_orig_ = XR_AAAA_upup_;XC_AAAA_upup_orig_ = XC_AAAA_upup_;XR_AZZA_upup_orig_ = XR_AZZA_upup_;XC_AZZA_upup_orig_ = XC_AZZA_upup_;
XR_AAAA_updn_orig_ = XR_AAAA_updn_;XC_AAAA_updn_orig_ = XC_AAAA_updn_;XR_AZZA_updn_orig_ = XR_AZZA_updn_;XC_AZZA_updn_orig_ = XC_AZZA_updn_;
XR_AAAA_dnup_orig_ = XR_AAAA_dnup_;XC_AAAA_dnup_orig_ = XC_AAAA_dnup_;XR_AZZA_dnup_orig_ = XR_AZZA_dnup_;XC_AZZA_dnup_orig_ = XC_AZZA_dnup_;
XR_AAAA_dndn_orig_ = XR_AAAA_dndn_;XC_AAAA_dndn_orig_ = XC_AAAA_dndn_;XR_AZZA_dndn_orig_ = XR_AZZA_dndn_;XC_AZZA_dndn_orig_ = XC_AZZA_dndn_;
ncovs_rem = 0; 
nrows_rem = MA;
ncols_rem = NA;
